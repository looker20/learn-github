'use strict';

// Run before the stylesheet to avoid a flash of the wrong theme.
(() => {
  let preference;
  try { preference = localStorage.getItem('portfolio-theme'); } catch { /* Optional storage. */ }
  const theme = ['light', 'dark'].includes(preference)
    ? preference
    : window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  document.documentElement.dataset.theme = theme;
  document.querySelector('meta[name="theme-color"]').content = theme === 'dark' ? '#152126' : '#e8e5de';
})();
