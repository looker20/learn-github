'use strict';

// Bind original text nodes once so changing language preserves DOM, focus and state.
// Translations use textContent/attributes only: no HTML injection or remote service.
const languageSelect = document.querySelector('#language');
if (languageSelect && typeof portfolioTranslations !== 'undefined') {
  const supportedLanguages = ['fr', 'en', 'nl'];
  const preferenceKey = 'portfolio-language';
  const bindings = [];
  const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
  while (walker.nextNode()) {
    const node = walker.currentNode;
    if (node.parentElement.closest('script, style, select, noscript, [role=status]')) continue;
    const key = node.textContent.trim();
    if (key) bindings.push({ node, original: node.textContent, key });
  }
  const attributes = ['aria-label', 'alt'].flatMap(attribute =>
    Array.from(document.querySelectorAll(`[${attribute}]`), node => ({ node, attribute, key: node.getAttribute(attribute) }))
  );
  const description = document.querySelector('meta[name="description"]');
  if (description) attributes.push({ node: description, attribute: 'content', key: description.content });
  const originalTitle = document.title;
  const announcements = { fr: 'Français sélectionné.', en: 'English selected.', nl: 'Nederlands geselecteerd.' };
  const translate = (key, language) => language === 'fr' ? key : portfolioTranslations[language][key] ?? key;
  const applyLanguage = (language, announce = false) => {
    if (!supportedLanguages.includes(language)) return;
    for (const binding of bindings) {
      binding.node.textContent = binding.original.replace(binding.key, () => translate(binding.key, language));
    }
    for (const binding of attributes) binding.node.setAttribute(binding.attribute, translate(binding.key, language));
    document.title = translate(originalTitle, language);
    document.documentElement.lang = language;
    languageSelect.value = language;
    if (announce) document.querySelector('#language-status').textContent = announcements[language];
    document.dispatchEvent(new Event('portfolio:languagechange'));
  };
  let savedLanguage;
  try { savedLanguage = localStorage.getItem(preferenceKey); } catch { /* Storage may be disabled. */ }
  const browserLanguage = Array.from(navigator.languages || [navigator.language])
    .map(language => language.toLowerCase().split('-')[0])
    .find(language => supportedLanguages.includes(language));
  applyLanguage(supportedLanguages.includes(savedLanguage) ? savedLanguage : browserLanguage || 'fr');
  languageSelect.closest('.language-switch').hidden = false;
  languageSelect.addEventListener('change', () => {
    const language = languageSelect.value;
    applyLanguage(language, true);
    try { localStorage.setItem(preferenceKey, language); } catch { /* Switching still works for this visit. */ }
  });
}

// Useful interaction, with every project still visible when JavaScript is off.
const projectFilters = document.querySelector('.project-filters');
if (projectFilters) {
  const projects = Array.from(document.querySelectorAll('[data-project-topic]'));
  const projectGrid = document.querySelector('.project-grid');
  const projectStatus = document.querySelector('#project-status');
  const announceResults = () => {
    const count = projects.filter(project => !project.hidden).length;
    const messages = {
      fr: `${count} réalisation${count === 1 ? '' : 's'} affichée${count === 1 ? '' : 's'}.`,
      en: `${count} project${count === 1 ? '' : 's'} shown.`,
      nl: `${count} project${count === 1 ? '' : 'en'} weergegeven.`
    };
    projectStatus.textContent = messages[document.documentElement.lang] || messages.fr;
  };
  document.addEventListener('portfolio:languagechange', () => {
    if (projectStatus.textContent) announceResults();
  });
  projectFilters.hidden = false;
  projectFilters.addEventListener('click', event => {
    const button = event.target.closest('button[data-project-filter]');
    if (!button) return;
    const filter = button.dataset.projectFilter;
    for (const control of projectFilters.querySelectorAll('button')) control.setAttribute('aria-pressed', String(control === button));
    for (const project of projects) project.hidden = filter !== 'all' && project.dataset.projectTopic !== filter;
    projectGrid.hidden = !projectGrid.querySelector('[data-project-topic]:not([hidden])');
    announceResults();
  });
}

// Native progress value avoids inline styles and has no tracking or persistence.
const readingProgress = document.querySelector('.reading-progress');
if (readingProgress) {
  readingProgress.hidden = false;
  let scheduled = false;
  const updateProgress = () => {
    const distance = document.documentElement.scrollHeight - window.innerHeight;
    readingProgress.value = distance > 0 ? Math.min(100, Math.max(0, window.scrollY / distance * 100)) : 0;
    scheduled = false;
  };
  const scheduleProgress = () => {
    if (!scheduled) { scheduled = true; requestAnimationFrame(updateProgress); }
  };
  window.addEventListener('scroll', scheduleProgress, { passive: true });
  window.addEventListener('resize', scheduleProgress);
  if ('ResizeObserver' in window) new ResizeObserver(scheduleProgress).observe(document.body);
  updateProgress();
}

if ('IntersectionObserver' in window) {
  const links = Array.from(document.querySelectorAll('#navigation a'));
  const sections = Array.from(document.querySelectorAll('main section[id]'));
  const updateActiveSection = () => {
    let current = null;
    for (const section of sections) {
      if (section.getBoundingClientRect().top <= window.innerHeight * .5) current = section;
    }
    for (const link of links) {
      if (current && link.hash === `#${current.id}`) link.setAttribute('aria-current', 'location');
      else link.removeAttribute('aria-current');
    }
  };
  const sectionObserver = new IntersectionObserver(updateActiveSection, { rootMargin: '-15% 0px -45% 0px', threshold: 0 });
  sections.forEach(section => sectionObserver.observe(section));

  // Animation is opt-in and finite; content stays visible if setup fails.
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
  if (!reducedMotion.matches) {
    document.documentElement.classList.add('motion-ready');
    const revealObserver = new IntersectionObserver(entries => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue;
        entry.target.classList.add('is-revealed');
        revealObserver.unobserve(entry.target);
      }
    }, { threshold: .08 });
    document.querySelectorAll('.about-grid, .expertise-card, .project-feature, .project-small, .journey-grid, .contact-panel').forEach(element => {
      element.classList.add('reveal');
      revealObserver.observe(element);
    });
    reducedMotion.addEventListener('change', event => {
      if (event.matches) {
        document.querySelectorAll('.reveal').forEach(element => element.classList.add('is-revealed'));
        revealObserver.disconnect();
      }
    });
  }
}

// Progressive enhancement: links remain visible when JavaScript is unavailable.
const menuButton = document.querySelector('.menu-toggle');
const navigation = document.querySelector('#navigation');

if (menuButton && navigation) {
  menuButton.hidden = false;
  navigation.dataset.enhanced = 'true';
  const setOpen = (open) => {
    menuButton.setAttribute('aria-expanded', String(open));
    navigation.dataset.open = String(open);
  };
  menuButton.addEventListener('click', () => {
    setOpen(menuButton.getAttribute('aria-expanded') !== 'true');
  });
  navigation.addEventListener('click', (event) => {
    if (event.target.closest('a')) setOpen(false);
  });
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && menuButton.getAttribute('aria-expanded') === 'true') {
      setOpen(false);
      menuButton.focus();
    }
  });
  document.addEventListener('click', (event) => {
    if (!navigation.contains(event.target) && !menuButton.contains(event.target)) setOpen(false);
  });
  window.matchMedia('(min-width: 901px)').addEventListener('change', () => setOpen(false));
}
