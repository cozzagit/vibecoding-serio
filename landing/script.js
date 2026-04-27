/**
 * Vibecoding Serio — Landing interactions
 * - Dot grid reactive background (hero)
 * - HTTP status code decoder
 * - Anatomy page hover tooltips
 * - Fade-in scroll reveals
 * - Magnetic buttons
 */

// =====================================================
// 1. DOT GRID REACTIVE BACKGROUND
// =====================================================
function initDotGrid() {
  const hero = document.querySelector('.hero');
  if (!hero) return;

  const canvas = document.createElement('canvas');
  canvas.className = 'dot-grid-canvas';
  canvas.style.cssText = `
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 0;
    opacity: 0.7;
  `;
  hero.insertBefore(canvas, hero.firstChild);

  const ctx = canvas.getContext('2d');
  let width, height;
  let mouse = { x: -1000, y: -1000 };
  let dots = [];

  const SPACING = 28;
  const DOT_RADIUS = 1.2;
  const INFLUENCE_RADIUS = 140;
  const ACCENT = [255, 122, 61]; // #FF7A3D
  const PRIMARY = [91, 138, 255]; // #5B8AFF
  const BASE_OPACITY = 0.15;

  function resize() {
    const rect = hero.getBoundingClientRect();
    const dpr = window.devicePixelRatio || 1;
    width = rect.width;
    height = rect.height;
    canvas.width = width * dpr;
    canvas.height = height * dpr;
    canvas.style.width = width + 'px';
    canvas.style.height = height + 'px';
    ctx.scale(dpr, dpr);
    buildDots();
  }

  function buildDots() {
    dots = [];
    const cols = Math.ceil(width / SPACING);
    const rows = Math.ceil(height / SPACING);
    const offsetX = (width - (cols - 1) * SPACING) / 2;
    const offsetY = (height - (rows - 1) * SPACING) / 2;
    for (let i = 0; i < cols; i++) {
      for (let j = 0; j < rows; j++) {
        dots.push({
          x: i * SPACING + offsetX,
          y: j * SPACING + offsetY,
          baseX: i * SPACING + offsetX,
          baseY: j * SPACING + offsetY,
        });
      }
    }
  }

  function draw() {
    ctx.clearRect(0, 0, width, height);

    for (const dot of dots) {
      const dx = mouse.x - dot.baseX;
      const dy = mouse.y - dot.baseY;
      const dist = Math.sqrt(dx * dx + dy * dy);

      let opacity = BASE_OPACITY;
      let color = [255, 255, 255];
      let radius = DOT_RADIUS;
      let pushX = 0, pushY = 0;

      if (dist < INFLUENCE_RADIUS) {
        const factor = 1 - dist / INFLUENCE_RADIUS;
        const eased = factor * factor;
        // Glow opacity boost
        opacity = BASE_OPACITY + eased * 0.85;
        // Color blend toward accent
        const blendF = eased;
        color = [
          Math.round(255 * (1 - blendF) + ACCENT[0] * blendF),
          Math.round(255 * (1 - blendF) + ACCENT[1] * blendF),
          Math.round(255 * (1 - blendF) + ACCENT[2] * blendF),
        ];
        // Slight repulsion (push away from mouse)
        const pushAmount = eased * 8;
        const angle = Math.atan2(dy, dx);
        pushX = -Math.cos(angle) * pushAmount;
        pushY = -Math.sin(angle) * pushAmount;
        // Bigger dot near mouse
        radius = DOT_RADIUS + eased * 1.8;
      }

      // Smooth lerp toward target position (creates ripple feel)
      dot.x += (dot.baseX + pushX - dot.x) * 0.15;
      dot.y += (dot.baseY + pushY - dot.y) * 0.15;

      ctx.beginPath();
      ctx.arc(dot.x, dot.y, radius, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(${color[0]}, ${color[1]}, ${color[2]}, ${opacity})`;
      ctx.fill();
    }

    requestAnimationFrame(draw);
  }

  hero.addEventListener('mousemove', (e) => {
    const rect = hero.getBoundingClientRect();
    mouse.x = e.clientX - rect.left;
    mouse.y = e.clientY - rect.top;
  });

  hero.addEventListener('mouseleave', () => {
    mouse.x = -1000;
    mouse.y = -1000;
  });

  // Touch support
  hero.addEventListener('touchmove', (e) => {
    if (e.touches.length > 0) {
      const rect = hero.getBoundingClientRect();
      mouse.x = e.touches[0].clientX - rect.left;
      mouse.y = e.touches[0].clientY - rect.top;
    }
  }, { passive: true });

  resize();
  window.addEventListener('resize', resize);
  draw();
}

// =====================================================
// 2. SPOTLIGHT CURSOR (subtle glow follower across page)
// =====================================================
function initSpotlight() {
  const spot = document.createElement('div');
  spot.className = 'spotlight';
  spot.style.cssText = `
    position: fixed;
    top: 0;
    left: 0;
    width: 480px;
    height: 480px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255, 122, 61, 0.07) 0%, transparent 60%);
    pointer-events: none;
    z-index: 1;
    transform: translate(-50%, -50%);
    transition: opacity 0.3s;
    opacity: 0;
    will-change: transform;
  `;
  document.body.appendChild(spot);

  let targetX = 0, targetY = 0;
  let curX = 0, curY = 0;

  document.addEventListener('mousemove', (e) => {
    targetX = e.clientX;
    targetY = e.clientY;
    spot.style.opacity = '1';
  });
  document.addEventListener('mouseleave', () => {
    spot.style.opacity = '0';
  });

  function animate() {
    curX += (targetX - curX) * 0.1;
    curY += (targetY - curY) * 0.1;
    spot.style.transform = `translate(${curX}px, ${curY}px) translate(-50%, -50%)`;
    requestAnimationFrame(animate);
  }
  animate();
}

// =====================================================
// 3. HTTP STATUS CODE DECODER
// =====================================================
const STATUS_CODES = {
  '200': {
    family: '2xx',
    familyColor: '#2A9D8F',
    familyLabel: 'SUCCESSO',
    name: 'OK',
    meaning: 'Tutto è andato bene. La risposta standard per le richieste GET, PATCH, PUT andate a buon fine.',
    where: 'Niente da diagnosticare — tutto sotto controllo.',
    prompt: 'Status 200, va tutto bene. (Non vedrai mai un prompt per il 200.)',
  },
  '201': {
    family: '2xx',
    familyColor: '#2A9D8F',
    familyLabel: 'SUCCESSO',
    name: 'Created',
    meaning: 'Una nuova risorsa è stata creata. Risposta tipica per POST.',
    where: 'Niente da fixare.',
    prompt: 'Tutto regolare per POST.',
  },
  '301': {
    family: '3xx',
    familyColor: '#D97706',
    familyLabel: 'REDIRECT',
    name: 'Moved Permanently',
    meaning: 'La risorsa è stata spostata definitivamente a un altro URL. Il browser segue automaticamente.',
    where: 'Solo da configurare se vuoi reindirizzare URL vecchi a nuovi.',
    prompt: 'Configura un 301 redirect da /vecchia-url a /nuova-url nel server (nginx o middleware Next.js).',
  },
  '304': {
    family: '3xx',
    familyColor: '#D97706',
    familyLabel: 'REDIRECT',
    name: 'Not Modified',
    meaning: 'Il browser ha già la versione aggiornata in cache. Il server non rispedisce il body.',
    where: 'Cache funzionante. Niente da fare.',
    prompt: 'La cache funziona correttamente.',
  },
  '400': {
    family: '4xx',
    familyColor: '#EA580C',
    familyLabel: 'ERRORE CLIENT (colpa tua)',
    name: 'Bad Request',
    meaning: 'Hai mandato una richiesta malformata: JSON sbagliato, parametri mancanti, tipo dati invalido.',
    where: 'Apri il network tab del browser, controlla il body della richiesta. Probabile JSON malformato o campo obbligatorio mancante.',
    prompt: 'POST a /api/X ritorna 400. Il body inviato è: {…}. Mi aspetto invece la struttura {…}. Verifica la validation Zod sull\'endpoint e correggi il body del client.',
  },
  '401': {
    family: '4xx',
    familyColor: '#EA580C',
    familyLabel: 'ERRORE CLIENT (colpa tua)',
    name: 'Unauthorized',
    meaning: 'Non sei autenticato: manca il token, il cookie di sessione, o sono scaduti.',
    where: 'DevTools → Application → Cookies. C\'è il cookie di sessione? È scaduto? In produzione è settato Secure ma il sito è HTTP?',
    prompt: 'Endpoint /api/profile ritorna 401 in produzione. In locale funziona. Sospetto problema di cookie httpOnly + Secure su HTTPS. Come configuro NextAuth cookies.sessionToken.options per dominio production?',
  },
  '403': {
    family: '4xx',
    familyColor: '#EA580C',
    familyLabel: 'ERRORE CLIENT (colpa tua)',
    name: 'Forbidden',
    meaning: 'Sei autenticato, ma non hai i permessi per questa operazione (es. utente normale che cerca di fare azioni admin).',
    where: 'Verifica nel codice del backend la logica di autorizzazione: ruoli, permessi, ownership della risorsa.',
    prompt: 'L\'utente loggato come role: "user" riceve 403 su DELETE /api/posts/42. Voglio che possa cancellare solo i propri post (autore). Verifica il middleware di autorizzazione.',
  },
  '404': {
    family: '4xx',
    familyColor: '#EA580C',
    familyLabel: 'ERRORE CLIENT (colpa tua)',
    name: 'Not Found',
    meaning: 'La rotta o la risorsa che hai chiesto non esiste sul server.',
    where: 'Hai sbagliato URL? Il file di route esiste? In Next.js: app/api/X/route.ts? In Express: app.get(\'/api/X\', …)?',
    prompt: 'GET /api/users/42 ritorna 404. Il file app/api/users/[id]/route.ts esiste e esporta GET. Lo user 42 esiste in DB. Possibile problema con il routing dinamico Next.js?',
  },
  '422': {
    family: '4xx',
    familyColor: '#EA580C',
    familyLabel: 'ERRORE CLIENT (colpa tua)',
    name: 'Unprocessable Entity',
    meaning: 'La validation server-side è fallita: email malformata, campo obbligatorio vuoto, valore fuori range.',
    where: 'Il server ha la validation con Zod / Joi / Pydantic. Cerca i log per capire quale campo ha fallito.',
    prompt: 'POST /api/register ritorna 422 con body {"error": "email already registered"}. Mostra l\'errore inline sotto il campo email del form, non come toast generico.',
  },
  '429': {
    family: '4xx',
    familyColor: '#EA580C',
    familyLabel: 'ERRORE CLIENT (colpa tua)',
    name: 'Too Many Requests',
    meaning: 'Hai superato il rate limit del servizio (es. OpenAI, Stripe, il tuo backend con upstash/ratelimit).',
    where: 'Implementa exponential backoff: aspetta 1s, ritenta. Se fallisce, 2s, poi 4s, poi 8s. Aggiungi caching delle risposte ripetute.',
    prompt: 'OpenAI API ritorna 429 in produzione. Implementa exponential backoff (3 retry: 1s, 2s, 4s) con AbortController. Aggiungi cache 5 min con LRU per request identiche.',
  },
  '500': {
    family: '5xx',
    familyColor: '#BE123C',
    familyLabel: 'ERRORE SERVER (colpa loro)',
    name: 'Internal Server Error',
    meaning: 'Bug nel codice del server, eccezione non gestita. Qualcosa è esploso lato backend.',
    where: 'NEI LOG DEL SERVER, non nel browser. Vercel Functions Logs, PM2 logs (pm2 logs), Railway logs. Cerca lo stack trace.',
    prompt: 'POST /api/checkout ritorna 500. Log Vercel: "TypeError: Cannot read property \'id\' of undefined at line 42". Codice attuale: [paste snippet]. Il bug è probabilmente che sto accedendo a user.id senza controllare se user è null. Aggiungi optional chaining e gestione esplicita dell\'errore.',
  },
  '502': {
    family: '5xx',
    familyColor: '#BE123C',
    familyLabel: 'ERRORE SERVER (colpa loro)',
    name: 'Bad Gateway',
    meaning: 'Nginx (o reverse proxy) non riesce a comunicare col backend. App giù o crashed.',
    where: 'SSH al VPS: pm2 status. L\'app è online? È sulla porta giusta? Verifica nginx config: proxy_pass http://localhost:PORT.',
    prompt: 'Nginx restituisce 502 Bad Gateway dal mio backend Express in pm2. pm2 status mostra l\'app errored. Vedi il log: [paste]. Verifica la causa del crash e suggerisci come migliorare error handling per evitare crash totali.',
  },
  '503': {
    family: '5xx',
    familyColor: '#BE123C',
    familyLabel: 'ERRORE SERVER (colpa loro)',
    name: 'Service Unavailable',
    meaning: 'Il server è temporaneamente non raggiungibile, sovraccarico, o in manutenzione.',
    where: 'Controllare se è un errore generato dal tuo provider (Vercel/Aruba) o dal tuo codice. Se è il tuo, scaling.',
    prompt: 'L\'app risponde 503 sotto carico (~100 req/s). VPS Aruba single instance. Suggerisci come scalare: PM2 cluster mode, o spostarmi su Vercel/Railway con auto-scaling.',
  },
  '504': {
    family: '5xx',
    familyColor: '#BE123C',
    familyLabel: 'ERRORE SERVER (colpa loro)',
    name: 'Gateway Timeout',
    meaning: 'Il backend ci ha messo troppo tempo a rispondere (>60s default nginx). Spesso query DB lente.',
    where: 'Profila l\'endpoint lento. Query DB con EXPLAIN ANALYZE. Cerca query N+1 o JOIN senza indici.',
    prompt: 'Endpoint GET /api/dashboard impiega 12s in produzione → 504 timeout nginx. Sospetto query N+1 nel fetch dashboard. Mostra query attuale [paste], suggerisci come ottimizzare con eager loading e indici.',
  },
};

function initDecoder() {
  const input = document.getElementById('status-input');
  const btn = document.getElementById('decode-btn');
  const output = document.getElementById('decoder-output');
  const suggestions = document.querySelectorAll('.suggestion');
  if (!input) return;

  function renderResult(code) {
    const data = STATUS_CODES[code];
    if (!data) {
      output.classList.add('decoder-empty');
      output.innerHTML = `
        <div class="decoder-placeholder">
          <div class="placeholder-icon">🤔</div>
          <p>Codice <code>${code}</code> non comune.</p>
          <p class="placeholder-hint">Prova 200, 301, 401, 404, 422, 429, 500, 502…</p>
        </div>
      `;
      return;
    }
    output.classList.remove('decoder-empty');
    output.innerHTML = `
      <div class="decoder-result">
        <div class="result-header">
          <div class="result-code" style="color: ${data.familyColor}">${code}</div>
          <div>
            <div class="result-family" style="color: ${data.familyColor}">${data.familyLabel}</div>
            <div class="result-name">${data.name}</div>
          </div>
        </div>
        <div class="result-body">
          <div class="result-block">
            <div class="result-block-label">Cosa significa</div>
            <div class="result-block-content">${data.meaning}</div>
          </div>
          <div class="result-block">
            <div class="result-block-label">Dove guardare</div>
            <div class="result-block-content">${data.where}</div>
          </div>
          <div class="result-block">
            <div class="result-block-label">Come parlarne a Claude</div>
            <div class="result-prompt">${data.prompt}</div>
          </div>
        </div>
      </div>
    `;
  }

  function decode() {
    const code = input.value.trim();
    if (!code) {
      output.classList.add('decoder-empty');
      output.innerHTML = `
        <div class="decoder-placeholder">
          <div class="placeholder-icon">⌨️</div>
          <p>Digita un codice di errore HTTP qui sopra</p>
          <p class="placeholder-hint">o clicca uno dei suggerimenti</p>
        </div>
      `;
      return;
    }
    renderResult(code);
  }

  btn.addEventListener('click', decode);
  input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') decode();
  });
  input.addEventListener('input', () => {
    if (input.value.length === 3) decode();
  });
  suggestions.forEach((s) => {
    s.addEventListener('click', () => {
      input.value = s.dataset.code;
      decode();
      // Smooth scroll input into view if needed
    });
  });
}

// =====================================================
// 4. ANATOMY HOVER TOOLTIPS
// =====================================================
const ANATOMY_PROMPTS = {
  'Header': 'Header sticky con logo a sinistra, navbar centrale, CTA primary a destra. Su mobile collassa in hamburger menu.',
  'Navbar (sub)': 'Sub-navbar orizzontale sotto l\'header, link secondari, sticky su scroll.',
  'Sidebar': 'Sidebar 280px sticky a sinistra con filtri categoria e prezzo. Su mobile diventa drawer apribile.',
  'Breadcrumb': 'Breadcrumb in cima al main content, separatore "›", ultimo livello non cliccabile.',
  'Hero': 'Hero a piena larghezza con h1 grande, sottotitolo, due CTA (primary + ghost), illustrazione a destra.',
  'Grid di Card': 'Grid prodotti 4 colonne desktop, 2 tablet, 1 mobile. Gap 24px. Card con immagine 4:3, titolo, prezzo, bottone.',
  'Pagination': 'Pagination con frecce + numeri + ellipsis. 12 risultati per pagina. Pagina attiva sfondo nero.',
  'Footer': 'Footer 3 colonne: contatti, link rapidi, newsletter signup. Riga sotto con copyright e link social.',
};

function initAnatomy() {
  const blocks = document.querySelectorAll('.anat-block');
  const tooltip = document.getElementById('anatomy-tooltip');
  if (!tooltip) return;
  const ttName = tooltip.querySelector('.tt-name');
  const ttDesc = tooltip.querySelector('.tt-desc');

  function showInfo(name, desc) {
    ttName.textContent = name;
    ttDesc.textContent = desc;
    // Inject prompt-ready
    const prompt = ANATOMY_PROMPTS[name];
    let promptEl = tooltip.querySelector('.tt-prompt');
    if (prompt) {
      if (!promptEl) {
        promptEl = document.createElement('div');
        promptEl.className = 'tt-prompt';
        tooltip.appendChild(promptEl);
      }
      promptEl.innerHTML = `<span class="tt-prompt-label">Prompt-ready</span>${prompt}`;
      promptEl.style.display = 'block';
    } else if (promptEl) {
      promptEl.style.display = 'none';
    }
  }

  blocks.forEach((b) => {
    b.addEventListener('mouseenter', () => {
      blocks.forEach((x) => x.classList.remove('is-active'));
      b.classList.add('is-active');
      const name = b.dataset.name;
      const desc = b.dataset.desc;
      if (name && desc) showInfo(name, desc);
    });
  });

  // Reset on mouse leave
  const mockup = document.getElementById('anatomy-mockup');
  if (mockup) {
    mockup.addEventListener('mouseleave', () => {
      blocks.forEach((x) => x.classList.remove('is-active'));
      ttName.textContent = 'Hover su un elemento';
      ttDesc.textContent = 'Passa il mouse sopra una zona della pagina-tipo per scoprire il suo nome corretto + come usarlo nel prompt a Claude.';
      const promptEl = tooltip.querySelector('.tt-prompt');
      if (promptEl) promptEl.style.display = 'none';
    });
  }
}

// =====================================================
// 5. FADE-IN SCROLL REVEAL
// =====================================================
function initFadeIn() {
  const items = document.querySelectorAll('.fade-in');
  if (!('IntersectionObserver' in window)) {
    items.forEach((i) => i.classList.add('is-visible'));
    return;
  }
  const obs = new IntersectionObserver((entries) => {
    entries.forEach((e) => {
      if (e.isIntersecting) {
        e.target.classList.add('is-visible');
        obs.unobserve(e.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -50px 0px' });
  items.forEach((i) => obs.observe(i));
}

// =====================================================
// 6. MAGNETIC BUTTONS (subtle pull toward cursor)
// =====================================================
function initMagneticButtons() {
  const buttons = document.querySelectorAll('.btn-primary');
  buttons.forEach((btn) => {
    btn.addEventListener('mousemove', (e) => {
      const rect = btn.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;
      btn.style.transform = `translate(${x * 0.18}px, ${y * 0.18}px) translateY(-2px)`;
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.transform = '';
    });
  });
}

// =====================================================
// 7. INIT
// =====================================================
document.addEventListener('DOMContentLoaded', () => {
  initFadeIn();
  initDotGrid();
  initSpotlight();
  initDecoder();
  initAnatomy();
  initMagneticButtons();
});
