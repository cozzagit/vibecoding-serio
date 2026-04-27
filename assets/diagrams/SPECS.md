# Specifiche Infografiche — Vibecoding Serio

> 16 infografiche totali. Ogni scheda contiene: scopo, contenuti precisi, layout suggerito, palette, dimensioni, stato.
> Stile generale: piatto, leggibile in 10 secondi, palette ridotta (3-4 colori), testo minimo, frecce evidenti, niente skeumorfismo.

---

## Sistema di design comune

**Palette base** (da raffinare con art-director):
- Sfondo: `#FAFAF7` (off-white, caldo)
- Primario: `#2D5BFF` (blu acceso, "tecnologia")
- Secondario: `#FF7A3D` (arancione, "azione/calore")
- Errore: `#E63946`
- Successo: `#2A9D8F`
- Testo: `#1A1A1A`
- Testo secondario: `#666`

**Tipografia**:
- Headline: Inter Bold 24-32pt
- Etichette: Inter Medium 14-16pt
- Caption: Inter Regular 12pt

**Iconografia**:
- Set unico (consigliato: Lucide Icons o Heroicons)
- Stile: outline, stroke 1.5px
- No emoji nelle infografiche del libro (tranne che in icone "neutre" tipo cursore/lucchetto/server)

**Dimensioni**:
- Versione libro: 1200×800 px (rapporto pagina A4 landscape)
- Versione social/blog: 1080×1080 (square) e 1080×1920 (story)
- Esportazione: SVG master + PNG @1x, @2x

**Stato lavorazione**:
- 🟥 Da fare
- 🟨 Bozza in revisione
- 🟩 Finale approvata

---

## Infografica 1 — I 3 ambienti
**Modulo**: 0 · **Stato**: 🟥

**Scopo**: chiarire che localhost / staging / produzione sono **ambienti separati** con regole diverse.

**Layout**: 3 colonne affiancate, ciascuna con icona + URL tipico + 4 attributi.

| Colonna | Icona | URL | Chi vede | Cosa contiene | Cosa rompere costa |
|---------|-------|-----|----------|---------------|---------------------|
| **Localhost** | 💻 PC | `localhost:3000` | Solo tu | Codice + DB di test | Niente (perdi 30 min) |
| **Staging / Dev** | 🔧 Ingranaggi | `dev.miosito.com` | Te + team | Copia produzione + dati finti | Imbarazzo interno |
| **Produzione** | 🌍 Globo | `miosito.com` | Tutti | Sistema reale + dati clienti | Email arrabbiate, soldi persi |

**Note grafiche**: gradiente di intensità da sinistra (chiaro/safe) a destra (scuro/critico). Una freccia tratteggiata "deploy" che attraversa le 3 colonne in alto.

---

## Infografica 2 — Anatomia di un sito online
**Modulo**: 0 · **Stato**: 🟥

**Scopo**: smontare il "sito su Aruba" in 4 entità distinte.

**Layout**: 4 box collegati da frecce bidirezionali. Al centro un browser che fa partire la richiesta.

```
[Browser utente]
       │
       ▼ digita "miosito.it"
   [DOMINIO]  ←── (registrar: Namecheap/Aruba)
       │ chiede a
       ▼
    [DNS]      ←── (Cloudflare, registrar)
       │ risponde con IP
       ▼
   [HOSTING]   ←── (Aruba VPS, Vercel...)
       │ contiene
       ▼
   [SERVER]    ←── (la macchina che esegue il codice)
```

**Etichette aggiuntive sotto ogni entità**:
- Dominio: "Il nome — si compra annualmente"
- DNS: "L'elenco telefonico — traduce nome → IP"
- Hosting: "Il fornitore — ti vende server e servizi"
- Server: "La macchina — esegue il tuo codice"

**Caption**: *"Quando dici 'ho il server da Aruba' stai parlando di queste 4 cose insieme."*

---

## Infografica 3 — Le scatole di Lego del codice
**Modulo**: 0 · **Stato**: 🟥

**Scopo**: distinguere API / Library / Framework / Package / SDK.

**Layout**: 5 scatole con dimensioni proporzionali alla "scala" del concetto.

- **Package** (la più piccola): "Il file zippato che npm scarica"
- **Library** (più grande): "Codice riusabile per UNA cosa specifica"
- **Framework** (ancora più grande): "Codice + struttura imposta"
- **SDK**: "Kit di librerie per usare un servizio"
- **API**: "La porta d'ingresso — non codice, ma protocollo"

Esempi colorati sotto ogni scatola:
- Package → `axios-1.6.0.tgz`
- Library → `axios`, `react-icons`, `dayjs`
- Framework → `Next.js`, `Laravel`, `Django`
- SDK → `Stripe SDK`, `Supabase SDK`
- API → `OpenAI API`, `Stripe API`, `il tuo backend`

---

## Infografica 4 — Da localhost al server in 3 modi
**Modulo**: 0 · **Stato**: 🟥

**Scopo**: visualizzare come il codice arriva online. FTP / SSH / Git push.

**Layout**: 3 strisce orizzontali, ognuna con icona, frecce, descrizione e tempo di esecuzione.

1. **FTP** 🗄️: laptop → frecce a "trascinamento" → server. Etichetta: *"Vecchia scuola, lento, insicuro (preferisci SFTP)"*. Tempo medio: 2-10 min.
2. **SSH** 🔐: laptop → terminale → server. Etichetta: *"Modo serio, shell remota, controllo totale"*. Tempo medio: 1-3 min.
3. **Git push + deploy automatico** 🚀: laptop → GitHub → Vercel → server. Etichetta: *"Modo moderno, zero touch dopo setup"*. Tempo medio: 30 sec.

**Caption finale**: *"Tu probabilmente usi #3 senza saperlo, quando 'fai deploy' su Vercel."*

---

## Infografica 5 — Dove vive un sito
**Modulo**: 1 · **Stato**: 🟥

**Scopo**: mappa concettuale delle 6 entità che compongono un sistema web.

**Layout**: schema circolare con utente al centro o radiale.

```
                 [Utente]
                    │
                    ▼
                [Browser]
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
      [DNS]      [CDN]       [Server]
                    │           │
                    │           ▼
                    │      [Database]
                    │
              (cache statica)
```

Colori distinti per ogni entità. Frecce annotate con il "cosa viaggia" (HTML, JSON, SQL...).

---

## Infografica 6 — Il viaggio del click
**Modulo**: 1 · **Stato**: 🟥

**Scopo**: 8 passi numerati dal click al render.

**Layout**: timeline orizzontale con 8 nodi.

1. 🖱️ **Click** sul link
2. 🔍 **DNS lookup** (browser chiede dov'è `miosito.com`)
3. 🤝 **TCP + TLS handshake** (browser apre connessione cifrata)
4. 📤 **HTTP request** (GET /pagina)
5. ⚙️ **Server processa** (esegue codice, magari interroga DB)
6. 📥 **HTTP response** (HTML/JSON ritorna)
7. 🎨 **Browser parsa e renderizza**
8. 👁️ **Utente vede il risultato**

Tempo tipico totale: 200-800ms. Mostrare microscale (DNS 20ms, TCP 50ms, ecc.).

---

## Infografica 7 — La danza client-server
**Modulo**: 2 · **Stato**: 🟥

**Scopo**: visualizzare lo scambio di messaggi tra client e server.

**Layout**: due colonne (Client | Server) con frecce orizzontali numerate.

```
CLIENT                          SERVER
  │                                │
  │ 1. POST /api/login {email,pw} │
  │ ────────────────────────────► │
  │                                │
  │ 2. 200 OK + cookie sessione   │
  │ ◄──────────────────────────── │
  │                                │
  │ 3. GET /api/user + cookie     │
  │ ────────────────────────────► │
  │                                │
  │ 4. 200 OK + dati utente       │
  │ ◄──────────────────────────── │
```

Esempio quotidiano: il login. 4 messaggi spiegati nella didascalia.

---

## Infografica 8 — Quali linguaggi vivono dove
**Modulo**: 2 · **Stato**: 🟥 — **CHIAVE**

**Scopo**: una mappa di riferimento "quando senti X, è frontend o backend?".

**Layout**: 2 colonne grandi separate da una linea verticale tratteggiata. Una zona centrale "ponte" per i linguaggi che girano in entrambi.

| FRONTEND (browser) | PONTE (entrambi) | BACKEND (server) |
|---|---|---|
| HTML | **JavaScript** | PHP + Laravel |
| CSS / Tailwind | **TypeScript** | Python + Django/Flask/FastAPI |
| React | Node.js (è server-side ma stesso linguaggio del browser) | Ruby + Rails |
| Vue / Svelte | Next.js / Nuxt / Remix (full-stack frameworks) | Go |
| Angular | | Java / Kotlin |
| | | C# .NET |

Loghi reali sotto ogni nome (con licenza). La zona "ponte" colorata in modo distinto per evidenziare la "magia" del JS full-stack.

**Caption**: *"Quando Claude scrive 'use client' in Next.js, sta dicendo: 'questo pezzo gira nel browser'. Senza, gira sul server. Stesso linguaggio, due ambienti."*

---

## Infografica 9 — Triangolo client-server-database
**Modulo**: 2 · **Stato**: 🟥

**Scopo**: mostrare i 3 vertici di ogni applicazione web.

**Layout**: triangolo equilatero con 3 vertici etichettati.

```
              [CLIENT]
              (browser, app mobile)
                /\
               /  \
              /    \
        HTTP /      \ HTTP
            /        \
           /          \
   [SERVER]──────────[DATABASE]
   (logica, API)  (dati persistenti)
                  SQL / ORM
```

Sotto ogni vertice 2-3 esempi: "Client = React, Vue, Flutter". "Server = Node, Laravel, Django". "Database = PostgreSQL, MongoDB, Supabase".

**Caption**: *"Ogni applicazione web ha questi 3 vertici. Cambia dove vivono (locale, cloud), ma ci sono sempre."*

---

## Infografica 10 — Anatomia di una pagina (FONDAMENTALE)
**Modulo**: 3 · **Stato**: 🟥 — **PIÙ IMPORTANTE DI TUTTE**

**Scopo**: una pagina-tipo annotata con TUTTI i nomi corretti dei suoi pezzi. Riferimento rapido che il lettore dovrebbe poter staccare e tenere appeso.

**Layout**: rendering di una pagina-tipo (mockup di un e-commerce o dashboard) con frecce e etichette numerate.

**Elementi annotati** (~20):
- Header (in alto)
  - Logo
  - Navbar
  - User menu (dropdown)
  - Search bar
  - Cart icon (con badge)
- Hero section (sopra la fold)
  - Heading h1
  - Subtitle
  - CTA button (primary)
  - Hero image
- Sidebar (laterale)
  - Filtri
  - Categorie
- Main content
  - Breadcrumb
  - Cards in grid
  - Pagination
- Footer
  - Link legali
  - Social icons
  - Newsletter form

**Versione mobile** affiancata: stessa pagina ridotta a single-column con hamburger menu, drawer, sticky bottom nav.

**Stile**: rendering "wireframe colorato" — non foto, illustrazione vettoriale piatta. Etichette in callout numerati (1, 2, 3...) con legenda laterale.

**Output bonus**: questa infografica viene venduta anche come **poster A2 stampato** nel Bundle Pro (49€). Vale da sola la differenza di prezzo.

---

## Infografica 11 — Componenti di navigazione
**Modulo**: 3 · **Stato**: 🟥

**Layout**: griglia 2×4 con un componente per cella, ognuno disegnato + etichettato.

1. **Navbar** — barra orizzontale con logo + link + user menu
2. **Sidebar nav** — barra verticale con icone + label
3. **Breadcrumb** — `Home > Categoria > Sotto > Pagina`
4. **Tab** — 3 linguette, una attiva
5. **Stepper** — 4 cerchi connessi (1 completato, 1 attivo, 2 futuri)
6. **Pagination** — `« 1 2 3 4 5 »`
7. **Hamburger menu** — icona 3 linee + drawer aperto
8. **Anchor link** — link con `#sezione` evidenziato

Ogni cella: nome IT + EN + 1 frase d'uso.

---

## Infografica 12 — Componenti di contenuto
**Modulo**: 3 · **Stato**: 🟥

**Layout**: griglia 2×4 con esempi reali.

1. **Hero** — banda alta con titolo + CTA + immagine
2. **Card** — riquadro con immagine + testo + bottone
3. **Banner** — barra orizzontale di avviso/promo
4. **List** — lista verticale di elementi
5. **Grid** — griglia di card 3×2
6. **Carousel** — immagini scorrevoli con frecce
7. **Accordion** — 4 sezioni, una espansa
8. **Table** — tabella con header + righe + colonne

---

## Infografica 13 — Componenti di interazione
**Modulo**: 3 · **Stato**: 🟥

**Layout**: griglia 2×4.

1. **Modal** — popup centrale con overlay
2. **Drawer** — pannello laterale che esce
3. **Toast** — notifica in basso a destra
4. **Tooltip** — bubble che appare all'hover
5. **Dropdown** — menu a tendina aperto
6. **Form** — input + label + checkbox + button
7. **Button states** — primario / secondario / ghost / icon-only
8. **Badge / Chip / Tag** — etichette colorate

---

## Infografica 14 — Stati di un componente
**Modulo**: 3 · **Stato**: 🟥

**Layout**: una griglia 2×4 con lo **stesso bottone** in 8 stati diversi (per dimostrare la differenza visiva).

1. **Idle** (neutro)
2. **Hover** (mouse sopra)
3. **Focus** (selezionato da tastiera)
4. **Active** (premuto)
5. **Disabled** (grigiato, non cliccabile)
6. **Loading** (spinner dentro)
7. **Success** (icona check verde)
8. **Error** (icona X rossa)

Sotto: stessa logica applicata a un input form (idle / focus / error / disabled).

**Caption**: *"Quando chiedi a Claude 'fai un bottone', stai chiedendo 8 stati diversi senza saperlo."*

---

## Infografica 15 — Decoder degli status code HTTP
**Modulo**: 5 · **Stato**: 🟥

**Layout**: matrice colorata raggruppata per famiglia.

- 🟢 **2xx — Successo** (sfondo verde chiaro)
  - 200 OK · 201 Created · 204 No Content
- 🟡 **3xx — Redirect** (sfondo giallo)
  - 301 Moved Permanently · 302 Found · 304 Not Modified
- 🟠 **4xx — Errore client (colpa tua)** (sfondo arancio)
  - 400 Bad Request · 401 Unauthorized · 403 Forbidden · 404 Not Found · 422 Unprocessable · 429 Too Many Requests
- 🔴 **5xx — Errore server (colpa loro)** (sfondo rosso chiaro)
  - 500 Internal Server Error · 502 Bad Gateway · 503 Service Unavailable · 504 Gateway Timeout

Per ogni codice: nome + 1 riga "cosa significa" + dove guardare per fixare.

**Caption**: *"Quando il server ti grida un numero, sappi cosa ti sta dicendo."*

---

## Infografica 16 — DNS resolution flow
**Modulo**: 7 · **Stato**: 🟥

**Layout**: sequence diagram dal browser ai server DNS.

```
Browser
  │
  │ "Dov'è miosito.com?"
  ▼
Resolver locale (ISP/router)
  │ "Non lo so, chiedo al root"
  ▼
Root DNS server (.)
  │ "Vai al TLD .com"
  ▼
TLD server (.com)
  │ "Vai al server authoritative di miosito.com"
  ▼
Authoritative DNS server
  │ "L'IP è 188.213.170.214"
  ▼
Browser → contatta 188.213.170.214
```

Tempi tipici a fianco di ogni step (10-50ms per step, totale 50-200ms).

---

## Pianificazione produzione

| Tappa | Tempo stimato | Strumento | Output |
|-------|---------------|-----------|--------|
| 1. Bozze low-fi (tutte 16) | 1 settimana | Excalidraw | Bozze rivedibili |
| 2. Refinement art-director | 2 giorni | Briefing + iterazioni | Brief visivo definitivo |
| 3. Versioni master | 2 settimane | Figma / Affinity Designer | SVG editabili |
| 4. Export multi-formato | 1 giorno | Figma plugin / batch | SVG + PNG @1x, @2x, @3x |
| 5. Integrazione Typst | 2 giorni | Inline nei capitoli | Manuscritto con tutte le immagini |

**Stima totale**: 3-4 settimane.

**Decisione aperta**: tu disegni o commissioni?
- **Self-made** (consigliato per le 4 più semplici, #1, #3, #4, #14): controllo, costo zero, può iterare
- **Fiverr / illustratore** (consigliato per #10, #11, #12, #13 — i 4 visivi pesanti): ~30-50€ cad → 200€ totali, qualità professional
- **Agente Claude art-director** se vuoi farle in tutto autonomamente con AI tools (Figma + plugin AI): ~10€ di crediti, qualità da raffinare

**Raccomandazione**: ibrido. Le 4 chiave (#10, #11, #12, #13) commissionate; le altre 12 self-made in Excalidraw (stile coerente, già usato in tech blog moderni). Costo totale ~200€, tempo totale ~2 settimane.

---

## Riferimenti utili

- [Excalidraw](https://excalidraw.com) — bozze veloci stile lavagna
- [Figma](https://figma.com) — design professionale gratis
- [Lucide Icons](https://lucide.dev) — icone outline coerenti
- [Heroicons](https://heroicons.com) — alternativa Lucide
- Esempio di stile: le infografiche di [Josh Comeau](https://www.joshwcomeau.com/css/interactive-guide-to-flexbox/) o [Lin Clark @ Mozilla](https://hacks.mozilla.org/2017/04/inside-a-super-fast-css-engine-quantum-css-aka-stylo/)
