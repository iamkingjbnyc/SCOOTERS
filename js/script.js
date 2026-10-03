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
