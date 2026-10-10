document.getElementById('year').textContent = new Date().getFullYear();

const navToggle = document.getElementById('navToggle');
navToggle.addEventListener('click', () => {
  document.body.classList.toggle('nav-open');
});

document.querySelectorAll('.main-nav a').forEach((link) => {
  link.addEventListener('click', () => {
    document.body.classList.remove('nav-open');
  });
});

const header = document.querySelector('.site-header');
window.addEventListener('scroll', () => {
  header.style.boxShadow = window.scrollY > 10 ? '0 6px 20px rgba(0,0,0,0.35)' : 'none';
});

// Google Ads conversion: "Call Now click (website)" — fires on any tap of a phone link
document.addEventListener('click', (e) => {
  const link = e.target.closest('a[href^="tel:"]');
  if (link && typeof gtag === 'function') {
    gtag('event', 'conversion', { send_to: 'AW-11412137626/Ro8TCN-A0Y4dEJrN3cEq' });
  }
});

// Floating "Text Us" + "Messenger" contact buttons (injected on every page)
(() => {
  const fab = document.createElement('div');
  fab.className = 'contact-fab';
  fab.innerHTML = `
    <a class="contact-fab-btn contact-fab-sms" href="sms:+16469431858" aria-label="Text us at 646-943-1858">
      <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 4h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H8l-4 4V6a2 2 0 0 1 2-2z" fill="currentColor"/><circle cx="8" cy="11" r="1.4" fill="#fff"/><circle cx="12" cy="11" r="1.4" fill="#fff"/><circle cx="16" cy="11" r="1.4" fill="#fff"/></svg>
      <span>Text Us</span>
    </a>
    <a class="contact-fab-btn contact-fab-messenger" href="https://m.me/nycatvs" target="_blank" rel="noopener" aria-label="Message us on Facebook Messenger">
      <svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M12 2C6.36 2 2 6.13 2 11.7c0 2.91 1.19 5.44 3.14 7.17.16.15.26.35.27.57l.05 1.78a.8.8 0 0 0 1.12.71l1.98-.87a.8.8 0 0 1 .53-.04c.91.25 1.88.38 2.91.38 5.64 0 10-4.13 10-9.7S17.64 2 12 2zm6 7.46-2.94 4.66a1.5 1.5 0 0 1-2.17.4l-2.34-1.75a.6.6 0 0 0-.72 0l-3.16 2.4c-.42.32-.97-.19-.69-.64l2.94-4.66a1.5 1.5 0 0 1 2.17-.4l2.34 1.75a.6.6 0 0 0 .72 0l3.16-2.4c.42-.32.97.19.69.64z"/></svg>
      <span>Messenger</span>
    </a>`;
  document.body.appendChild(fab);
})();
