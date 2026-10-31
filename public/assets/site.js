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
    if (node.parentElement.closest('script, style, select, noscript, #language-status')) continue;
    const key = node.textContent.trim();
    if (key) bindings.push({ node, original: node.textContent, key });
  }
  const attributes = Array.from(document.querySelectorAll('[aria-label]'), node => ({
    node, attribute: 'aria-label', key: node.getAttribute('aria-label')
  }));
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
