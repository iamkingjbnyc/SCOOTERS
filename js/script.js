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
