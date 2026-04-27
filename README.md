# Vibecoding Serio

Manuale pratico per chi costruisce siti con l'AI ma non capisce cosa sta costruendo.

> *Smetti di copiare prompt. Inizia a capire cosa stai costruendo.*

**Autore**: Luca Cozza
**Data inizio**: 2026-04-25
**Stato**: pre-MVP / scrittura
**Target lancio**: 6 settimane (giugno 2026)

---

## Struttura del repo

```
vibecoding-serio/
├── README.md                    questo file
├── manuscript/                  contenuto del libro
│   ├── 00-indice.md             SOMMARIO COMPLETO (supervisionato)
│   ├── 01-prefazione.md
│   ├── moduli/                  6 moduli del libro
│   │   ├── 00-cosa-succede-quando-deploy.md
│   │   ├── 01-browser-stupido.md
│   │   ├── 02-server-cameriere.md
│   │   ├── 03-database-non-excel.md
│   │   ├── 04-viaggio-del-click.md
│   │   └── 05-parlare-a-claude.md
│   ├── quick-wins/              i 5 capitoli killer (anche standalone come articoli blog)
│   │   ├── 01-sito-si-rompe-produzione.md     ✓ PRIMO QUICK WIN
│   │   ├── 02-api-rest-spiegata.md
│   │   ├── 03-cookie-sessioni.md
│   │   ├── 04-database-perde-dati.md
│   │   └── 05-cors-spiegato.md
│   ├── glossario.md             52 termini con "come usarlo nel prompt a Claude"
│   └── appendici/
│       ├── A-cheat-sheet-debug.md
│       ├── B-checklist-pre-deploy.md
│       ├── C-10-prompt-template.md
│       └── D-gdpr-vibecoder.md
├── landing/                     landing page Astro/Next per pre-order
├── marketing/                   asset di lancio
│   ├── tiktok-scripts/          script reel da 60 sec
│   ├── linkedin-posts/          post lunghi
│   └── blog/                    articoli SEO (capitoli quick-wins rielaborati)
└── assets/
    ├── cover/                   cover libro
    └── diagrams/                schemi del libro (DNS flow, request lifecycle, ecc.)
```

---

## Setup repository GitHub (da fare)

```bash
cd /c/work/Cozza/vibecoding-serio
git init
git add .
git commit -m "feat: initial project scaffold"

# Crea repo su GitHub
gh repo create cozzagit/vibecoding-serio --private --source=. --remote=origin --push
```

Repo **private** finché non lanci. Pubblico in fase 2 con sample chapter aperto.

---

## Setup dominio (decisione 2026-04-25)

**Subdomain VPS in fase MVP**: `vibecodingserio.vibecanyon.com`.
Dominio dedicato `.com` valutato in fase 2 dopo le prime 50 vendite.

**Record A da configurare** (su gestore DNS di vibecanyon.com):
- `A     vibecodingserio     188.213.170.214`

**Nginx config su VPS** (`/etc/nginx/sites-available/vibecodingserio`):
```nginx
server {
    listen 80;
    server_name vibecodingserio.vibecanyon.com;
    root /var/www/vibecodingserio;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

Poi `certbot --nginx -d vibecodingserio.vibecanyon.com --non-interactive --agree-tos --redirect`.

---

## Stack di produzione

| Cosa | Strumento | Note |
|------|-----------|------|
| Scrittura | Markdown | Versioned in git, leggibile da chiunque |
| PDF finale | **Typst** | Layout pulito senza LaTeX, output PDF professionale |
| Cover | Affinity Publisher / Figma | Mockup tipografico minimalista per MVP |
| Landing | Astro statico | Hostata su VPS Aruba, subpath /vibecodingserio o dominio dedicato |
| Pre-order | **Lemon Squeezy** | Gestisce VAT EU automaticamente (preferito vs Gumroad per IT) |
| Email | Buttondown / ConvertKit free tier | Newsletter dal mese 2 |
| Amazon KDP | Pandoc → EPUB | Versione lite 4.99€ come funnel |

---

## Roadmap (6 settimane)

| Sett. | Cosa | Output |
|-------|------|--------|
| 1 | Indice finale + Modulo 0 + Modulo 1 (30 pag.) | Indice pubblicato su LinkedIn, primi 30% del libro |
| 2 | Modulo 2 + Modulo 3 (38 pag.) + 5 reel TikTok teaser | Validazione interesse + prime email |
| 3 | Modulo 4 + Modulo 5 (38 pag.) + landing pre-order 19€ early bird | Landing live, primi pre-ordini |
| 4 | Glossario + 4 Appendici (24 pag.) + revisione + layout PDF | Manoscritto completo |
| 5 | Cover + 5 reel lancio + 3 post LinkedIn + email newsletter | Asset di lancio pronti |
| 6 | Lancio soft + KDP versione lite | **PRODOTTO LIVE** |

---

## KPI a 90 giorni

- **100+ copie** vendute → validato, fase 2
- **50-99 copie** → itera positioning + canali
- **<50 copie** → pivot

Metriche secondarie: 500+ TikTok follower, 30+ newsletter, 3+ testimonianze spontanee.

---

## Stato attuale (2026-04-25)

- [x] Brainstorming completo (`C:\work\Cozza\docs\2026-04-25-brainstorming-vibecoding-serio.md`)
- [x] Scaffold repository
- [x] Indice completo (`manuscript/00-indice.md`)
- [x] Primo Quick Win scritto (`manuscript/quick-wins/01-sito-si-rompe-produzione.md`)
- [ ] Repo GitHub
- [ ] Dominio + DNS
- [ ] Setup Typst per output PDF
- [ ] Landing statica
- [ ] Modulo 0
- [ ] Modulo 1

---

## Decisioni aperte

1. **Nome finale**: `Vibecoding Serio` o alternative?
2. **Dominio**: `.com` dedicato o subdomain VPS in fase MVP?
3. **Persona pubblica**: firmi "Luca Cozza" o crei brand dedicato?
4. **Cover**: minimalista tipografico self-made o commissionata?
5. **Newsletter dal lancio o dopo**?
6. **Canale primario**: TikTok o LinkedIn?
