/* Shared behaviour for every page: nav, theme toggle, scroll reveal, cursor comet. */
(function(){

  // ---- Mark the tab for the page we're on ----
  var path = location.pathname.replace(/index\.html$/, '');
  if(path.length > 1 && path.slice(-1) !== '/') path += '/';
  var tabs = Array.prototype.slice.call(document.querySelectorAll('.tab[data-path]'));
  var best = null;
  tabs.forEach(function(a){
    var p = a.dataset.path;
    if(path === p || (p !== '/' && path.indexOf(p) === 0)){
      if(!best || p.length > best.dataset.path.length) best = a;
    }
  });
  tabs.forEach(function(a){ a.classList.toggle('active', a === best); });
  if(best) best.setAttribute('aria-current', 'page');

  // ---- Legacy /#work style anchors now have real pages ----
  var LEGACY = { '#about': '/', '#work': '/work/', '#writing': '/writing/', '#experience': '/experience/', '#contact': '/contact/' };
  if(path === '/' && LEGACY[location.hash] && LEGACY[location.hash] !== '/'){
    location.replace(LEGACY[location.hash]);
    return;
  }

  // ---- Mobile menu ----
  var tabsNav = document.getElementById('tabs');
  var burger  = document.getElementById('burger');

  function closeMenu(){
    tabsNav.classList.remove('open');
    burger.setAttribute('aria-expanded', 'false');
    burger.textContent = '☰';
  }

  if(tabsNav && burger){
    burger.addEventListener('click', function(){
      var open = tabsNav.classList.toggle('open');
      burger.setAttribute('aria-expanded', open);
      burger.textContent = open ? '✕' : '☰';
    });
    tabs.forEach(function(a){ a.addEventListener('click', closeMenu); });
    document.addEventListener('click', function(e){
      if(!tabsNav.classList.contains('open')) return;
      if(e.target === burger || burger.contains(e.target)) return;
      if(tabsNav.contains(e.target)) return;
      closeMenu();
    });
    document.addEventListener('keydown', function(e){
      if(e.key === 'Escape' && tabsNav.classList.contains('open')){
        closeMenu();
        burger.focus();
      }
    });
  }

  // ---- Theme toggle ----
  var themeToggle = document.getElementById('themeToggle');
  if(themeToggle){
    themeToggle.addEventListener('click', function(){
      var root = document.documentElement;
      var next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      root.setAttribute('data-theme', next);
      try{ localStorage.setItem('theme', next); }catch(e){}
    });
  }

  // ---- Scroll reveal ----
  var io = ('IntersectionObserver' in window)
    ? new IntersectionObserver(function(entries){
        entries.forEach(function(e){ if(e.isIntersecting){ e.target.classList.add('in'); io.unobserve(e.target); } });
      }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' })
    : null;

  var els = document.querySelectorAll('.reveal');
  Array.prototype.forEach.call(els, function(t){
    if(io){ io.observe(t); } else { t.classList.add('in'); }
  });
  requestAnimationFrame(function(){
    Array.prototype.forEach.call(els, function(t){
      if(t.getBoundingClientRect().top < window.innerHeight * 0.9){
        t.classList.add('in');
        if(io) io.unobserve(t);
      }
    });
  });
})();

/* ---- Cursor comet ---- */
(function(){
  if(window.matchMedia('(hover: none), (pointer: coarse)').matches) return;
  if(window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  var HOVER_SEL = 'a, button, .tab, .btn, .pill, .feature, .hl-card, .case-cell, .stat';
  var mx = -100, my = -100;
  var hoverTarget = null;

  document.addEventListener('mousemove', function(e){ mx = e.clientX; my = e.clientY; });
  document.addEventListener('mouseover', function(e){
    var t = e.target.closest(HOVER_SEL);
    if(t) hoverTarget = t;
  });
  document.addEventListener('mouseout', function(e){
    var t = e.target.closest(HOVER_SEL);
    if(t && t === hoverTarget) hoverTarget = null;
  });

  var N = 8;
  var dots = Array.from({ length: N }, function(){
    var d = document.createElement('div');
    d.className = 'cur-comet-dot';
    document.body.appendChild(d);
    return d;
  });
  var hist = Array.from({ length: N }, function(){ return { x: mx, y: my }; });
  var tick = 0;

  (function frame(){
    tick++;
    if(tick % 2 === 0){ hist.pop(); hist.unshift({ x: mx, y: my }); }
    dots.forEach(function(d, i){
      var p = hist[i];
      var scale = 1 - i / N;
      d.style.transform = 'translate(' + p.x + 'px,' + p.y + 'px) translate(-50%,-50%) scale(' + scale + ')';
      d.style.opacity = (1 - i / N) * 0.8;
      d.classList.toggle('hover', !!hoverTarget);
    });
    requestAnimationFrame(frame);
  })();
})();
