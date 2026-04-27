# Vibecoding Serio — Indice completo

> Versione: 0.2 · Data: 2026-04-25 · Status: da supervisionare e validare
>
> Questo è il sommario dettagliato del libro. Ogni voce qui sotto diventerà un capitolo o sotto-capitolo. **Validalo prima di iniziare la scrittura full**: cambiare un titolo qui costa 30 secondi, dopo costa giorni.

---

## Dati del libro

- **Titolo provvisorio**: Vibecoding Serio
- **Sottotitolo**: Il manuale per chi costruisce siti con l'AI ma non capisce cosa sta costruendo
- **Autore**: Lupo Carro
- **Lunghezza target**: ~165 pagine, 8-9 ore di lettura
- **Formato**: PDF (Typst), versione lite EPUB su KDP
- **Prezzo**: 29€ Standard / 4.99€ Lite KDP / 49€ Bundle Pro
- **Lingua**: italiano
- **Edizione**: 1.0
- **Caratteristica chiave**: **manuale visuale**, ~15 infografiche dedicate (vedi sezione finale)

---

## Prefazione (3 pagine)

### A chi è rivolto questo libro
Una pagina che rispecchia il lettore: "Hai costruito qualcosa con Claude/Bolt/Cursor. Funziona. Ma se ti chiedessero perché funziona non sapresti rispondere. Questo libro è per te."

### Cosa NON è questo libro
- Non un corso di programmazione da zero
- Non un tutorial su un singolo framework
- Non un "diventa sviluppatore in 30 giorni"
- Non teoria accademica
- Non uno sproloquio nostalgico su come si programmava nel 2010

### Come leggerlo
Tre modalità: lineare, Quick Wins (5 capitoli killer), riferimento (glossari + cheat sheet).

---

## MODULO 0 — Le parole che ti servono per partire
*4 capitoli · 14 pagine · 50 min · CONCETTI BASICI*

Modulo introduttivo dedicato al lessico minimo. Il vibecoder spesso non sa cosa significa "produzione", confonde "server" con "hosting", non capisce cosa fa un DNS. Qui smontiamo tutto in modo accessibile.

### 0.1 Cosa significa "deploy", "produzione", "ambiente"
*~3 pagine · 🎨 Infografica 1: I 3 ambienti (localhost, staging, produzione)*

- **Localhost**: sta sul tuo PC, lo vedi solo tu. È la sandbox in cui costruisci.
- **Sviluppo (dev)**: ambiente di test condiviso, online ma non pubblico (es. `dev.miosito.com`). Ci provano modifiche prima di pubblicarle.
- **Produzione (prod)**: il sito live, quello che vede il cliente. Si rompe → arrivano email arrabbiate.
- **Staging**: copia esatta della produzione usata per test finali prima del rilascio.
- **Deploy**: l'azione di "spostare il codice" da uno di questi ambienti a quello superiore.

Tabella riassuntiva: per ogni ambiente → URL tipico, chi lo vede, cosa contiene, cosa rompere costa.

### 0.2 Server, hosting, dominio: tre cose diverse spesso confuse
*~4 pagine · 🎨 Infografica 2: Anatomia di un sito online*

Il vibecoder dice "ho il server da Aruba". Sta dicendo tre cose insieme. Le smontiamo:

- **Server**: la macchina fisica/virtuale che esegue il tuo codice. Su Aruba VPS, su Vercel, su AWS. È dove "vive" il tuo sito.
- **Hosting**: il servizio che ti vende quel server (Aruba, Hetzner, Vercel, Netlify). È la differenza tra "casa" (server) e "agenzia immobiliare" (hosting).
- **Dominio**: il nome che digiti nel browser (`miosito.it`). Si compra separatamente, anche da provider diverso dall'hosting.
- **DNS**: il sistema che traduce "miosito.it" nell'indirizzo IP del server. È un elenco telefonico distribuito.

Esempio reale: "Compro dominio su Namecheap, server su Aruba, configuro il record A su Cloudflare per puntare l'uno all'altro."

### 0.3 Cos'è un'API, una libreria, un framework, un pacchetto
*~3 pagine · 🎨 Infografica 3: Le scatole di Lego del codice*

Termini che Claude usa continuamente, di solito senza spiegarli.

- **Libreria**: pezzo di codice riusabile per fare una cosa specifica (es. `axios` per fare richieste HTTP).
- **Framework**: insieme di librerie + struttura imposta (es. Next.js, Laravel). Decide come scrivi il codice.
- **Pacchetto / Package**: file zippato di una libreria/framework distribuito via npm, pip, composer.
- **API**: porta d'ingresso al tuo backend o a un servizio esterno. È un menù di "cose che puoi chiedere".
- **SDK**: kit di strumenti per usare un'API in modo facile (es. SDK Stripe).

Differenza pratica: usare Stripe = API. Usare il pacchetto `stripe-js` = libreria. Usare il file zippato che npm scarica = pacchetto.

### 0.4 FTP, SSH, Git: i tre modi per spostare codice
*~4 pagine · 🎨 Infografica 4: Da localhost al server in 3 modi*

Il vibecoder che usa Bolt/Lovable non sa come il codice arrivi sul server. Lo spieghiamo con i 3 modi storici.

- **FTP** (vecchia scuola): trascini i file dal tuo PC al server con un programma tipo FileZilla. Funziona, è lento, è insicuro (FTPS è la versione cifrata).
- **SSH** (modo serio): apri una "shell remota" sul server, lavori come se fossi lì. Modifichi file, lanci comandi. Più potente, richiede configurazione.
- **Git push + deploy automatico** (modo moderno): tu fai `git push`, GitHub manda un notifica al tuo provider (Vercel/Netlify/CI), il provider scarica il codice, lo compila, lo mette online. Zero touch.

Quale usi? Su Vercel/Netlify: solo Git. Su VPS Aruba: Git + SSH (Git per scaricare, SSH per configurare). FTP solo se hai un legacy PHP su hosting condiviso.

---

## MODULO 1 — Cosa sta succedendo davvero quando premi "Deploy"
*4 capitoli · 14 pagine · 50 min*

Il modulo che ancora il lettore al funzionamento di un sistema web prima di smontare le parti.

### 1.1 Il vibecoder e il meccanico
*~3 pagine*

Metafora di apertura: chi guida una macchina senza capirla, e chi la apre quando si ferma.

### 1.2 La mappa del territorio
*~3 pagine · 🎨 Infografica 5: Dove vive un sito*

Schema visivo: utente → browser → DNS → CDN → server → database. Le 6 entità, dove vivono, chi parla con chi.

### 1.3 Cosa fa davvero Claude quando scrivi un prompt
*~4 pagine*

Caso studio: prompt "fammi un sito con login Google". I 6 pezzi di codice che Claude scrive (page frontend, API backend, OAuth redirect, callback, session storage, DB user) e perché ognuno esiste.

### 1.4 Il flusso di una richiesta web in 8 passi
*~4 pagine · 🎨 Infografica 6: Il viaggio del click*

Dal click al risultato, tutto schematizzato.

**🎯 Esempio killer**: *Hai chiesto a Lovable "crea un'app con login Google". Ecco i 6 pezzi di codice che ha scritto al posto tuo.*

---

## MODULO 2 — Client e server: chi fa cosa
*5 capitoli · 18 pagine · 1h 10min*

Il modulo concettuale più importante: la **divisione tra client e server**. Quasi tutti gli errori dei vibecoder nascono dal non capire questa divisione.

### 2.1 Il modello client-server in 5 minuti
*~3 pagine · 🎨 Infografica 7: La danza client-server*

Cliente chiede, server risponde. Punto. Tutto il resto del web sono variazioni su questo tema. Schema con frecce, esempi quotidiani (browser ↔ server, app mobile ↔ API, frontend Next.js ↔ backend Next.js).

### 2.2 I linguaggi del client (frontend)
*~4 pagine · 🎨 Infografica 8: Quali linguaggi vivono dove*

Cosa gira nel browser, e quindi cosa scrivono Claude/Cursor quando dicono "frontend".

- **HTML**: lo scheletro
- **CSS / Tailwind**: la pelle
- **JavaScript / TypeScript**: i muscoli
- **React / Vue / Svelte / Angular**: i framework UI (gestiscono la complessità del DOM)
- **Next.js / Nuxt / SvelteKit**: meta-framework (React/Vue + ottimizzazioni)

Quando senti "Next.js" pensa "React + tante feature pronte". Quando senti "Tailwind" pensa "CSS scritto come classi". Mappa rapida.

### 2.3 I linguaggi del server (backend)
*~4 pagine*

Cosa gira sul server, dove non vede l'utente. Il libro non insegna a programmarli — ti insegna a riconoscerli quando Claude li tira fuori.

- **Node.js + Express / Fastify**: JavaScript server-side
- **PHP + Laravel / Symfony**: classico, gira su Apache/Nginx, hosting condiviso (Aruba)
- **Python + Django / Flask / FastAPI**: scientifico/AI, ottimo per progetti con ML
- **Ruby + Rails**: produttività massima, popolare in startup classiche
- **Go**: performance e semplicità per microservizi
- **Java / Kotlin / .NET**: enterprise

Tabella decisionale: "se il tuo progetto è X, Claude probabilmente userà Y". Esempio: "ecommerce con WordPress di base" → PHP. "Dashboard moderna con AI" → Python o Node.js.

### 2.4 Quando un linguaggio sta su entrambi (full-stack)
*~3 pagine*

JavaScript e TypeScript sono speciali: girano in entrambi (Node.js sul server, browser sul client). Per questo Next.js è popolare: stesso codice, due ambienti. Spiegato con esempio: la stessa funzione `validateEmail()` può girare lato client (per feedback istantaneo) o lato server (per sicurezza vera).

### 2.5 Il database: il terzo pilastro
*~4 pagine · 🎨 Infografica 9: Triangolo client-server-database*

I database non sono un "linguaggio" ma un sistema separato. SQL come lingua per parlarci. Cosa è un ORM (Drizzle, Prisma, Sequelize) — il "traduttore" tra il tuo codice e il database.

**🎯 Esempio killer**: *Hai chiesto a Claude "crea un'app con login". Ha scritto codice React (client), API Node (server), schema SQL (database). Ecco quale parte fa cosa.*

---

## MODULO 3 — L'anatomia di una pagina web
*5 capitoli · 22 pagine · 1h 30min · MOLTO VISIVO*

Modulo dedicato esclusivamente alla **struttura visiva** di una pagina e ai nomi giusti dei suoi componenti. È quello che ti serve per descrivere a Claude cosa vuoi senza usare parole vaghe.

### 3.1 I 5 macro-blocchi di ogni pagina
*~4 pagine · 🎨 Infografica 10: Anatomia di una pagina (FONDAMENTALE)*

Header, navigation, main content, sidebar, footer. Spiegati con un disegno annotato di una pagina-tipo (e-commerce + blog + dashboard). Quale serve a cosa, quando si omette, quando si aggiunge.

### 3.2 Componenti di navigazione
*~4 pagine · 🎨 Infografica 11: Componenti di navigazione*

Disegno annotato:
- Navbar (orizzontale in alto)
- Sidebar (verticale laterale)
- Breadcrumb (la traccia "sei qui")
- Tab (linguette)
- Stepper (indicatore avanzamento)
- Pagination (sotto le liste)
- Hamburger menu (mobile)

Per ognuno: come si chiama, come si disegna, quando usarlo.

### 3.3 Componenti di contenuto
*~4 pagine · 🎨 Infografica 12: Componenti di contenuto*

- Hero (la "prima impressione")
- Card (riquadro autocontenuto)
- Banner (avviso/promozione)
- List (lista verticale)
- Grid (griglia)
- Carousel (immagini scorrevoli)
- Accordion (espandibili)
- Table (tabella)

### 3.4 Componenti di interazione
*~5 pagine · 🎨 Infografica 13: Componenti di interazione*

- Modal (popup centrale)
- Drawer (pannello che esce dal lato)
- Toast / Snackbar (notifica temporanea)
- Tooltip (suggerimento al hover)
- Dropdown (menù a tendina)
- Form (input di testo, checkbox, radio, select)
- Button (primario, secondario, ghost, icon-only)
- Badge / Chip / Tag (etichette)

Ogni componente: nome IT/EN, **come usarlo nel prompt** ("usa un drawer dal basso per il menu mobile" è preciso, "fai un menu che esce" è impreciso).

### 3.5 Stati e feedback visivi
*~5 pagine · 🎨 Infografica 14: Stati di un componente*

Come si comporta un componente nel tempo:
- Empty state (lista vuota)
- Loading state (caricamento)
- Error state (errore)
- Skeleton loader (placeholder grigio)
- Spinner (icona rotante)
- Disabled state (bottone grigiato)
- Hover / Focus / Active state

**🎯 Esempio killer**: *Hai chiesto "aggiungi un accordion per le FAQ". Claude ha scritto 40 righe. Questo capitolo spiega perché erano necessarie e come avresti potuto chiederlo meglio in 3 righe.*

---

## MODULO 4 — Il browser è stupido (ma fa tutto lui)
*5 capitoli · 18 pagine · 1h 10min*

Approfondimento frontend (dopo aver visto la struttura nel Modulo 3).

### 4.1 HTML in 30 minuti
*~3 pagine*

Tag con significato (`<header>`, `<main>`, `<button>`) vs `<div>` puro. Accessibilità in 1 paragrafo.

### 4.2 CSS: layout responsive senza piangere
*~4 pagine*

Box model, flexbox vs grid (metafora bancomat), media query mobile-first.

### 4.3 JavaScript: aggiornare vs ricaricare
*~3 pagine*

SPA vs MPA, perché il tuo Next.js si comporta in entrambi i modi.

### 4.4 Il DOM e React
*~4 pagine*

Come Claude tocca il DOM. Componenti, props, state.

### 4.5 Server Components vs Client Components (Next.js 14+)
*~4 pagine*

Distinzione che il vibecoder Next.js incontra senza capirla. `'use client'` cosa significa, perché serve, quando NON metterlo.

---

## MODULO 5 — Il server è il cameriere che nessuno vede
*5 capitoli · 20 pagine · 1h 15min*

### 5.1 Frontend e backend separati: perché
*~4 pagine*

### 5.2 API REST — la metafora del menù
*~4 pagine*

### 5.3 I verbi HTTP: GET, POST, PUT, PATCH, DELETE
*~3 pagine*

### 5.4 I codici di stato: 200, 404, 401, 500
*~5 pagine · 🎨 Infografica 15: Decoder degli status code*

### 5.5 Headers, body, JSON
*~4 pagine*

**🎯 Esempio killer**: *Perché Supabase funziona in locale e ritorna 401 in produzione.*

---

## MODULO 6 — Il database non è un foglio Excel (quasi)
*5 capitoli · 18 pagine · 1h 10min*

### 6.1 Tabelle, righe, colonne
*~3 pagine*

### 6.2 Chiavi primarie e relazioni
*~4 pagine*

### 6.3 SQL in 10 minuti
*~4 pagine*

### 6.4 SQL vs NoSQL — Supabase, Firebase, Neon
*~4 pagine*

### 6.5 Migration e backup
*~3 pagine*

**🎯 Esempio killer**: *Hai aggiunto una colonna in locale. Il sito in produzione crasha. Si chiama "migration".*

---

## MODULO 7 — Il viaggio del click in produzione
*6 capitoli · 22 pagine · 1h 30min*

### 7.1 DNS: l'elenco telefonico di Internet
*~3 pagine · 🎨 Infografica 16: DNS resolution flow*

### 7.2 HTTPS e certificati SSL
*~4 pagine*

### 7.3 Nginx: il buttafuori
*~4 pagine*

### 7.4 Variabili d'ambiente
*~3 pagine*

### 7.5 Cookie e sessioni
*~4 pagine*

### 7.6 CORS in 3 paragrafi
*~4 pagine*

**🎯 Esempio killer**: *CORS in produzione. Cosa chiedere a Claude.*

---

## MODULO 8 — Parlare a Claude come uno sviluppatore
*5 capitoli · 16 pagine · 1h*

### 8.1 Prompt vago vs prompt informato
*~3 pagine*

### 8.2 Descrivere il layout con nomi corretti
*~3 pagine*

(Riprende il Modulo 3: glossario UI applicato al prompt.)

### 8.3 Descrivere il comportamento con nomi corretti
*~3 pagine*

### 8.4 Spiegare un bug senza sapere il bug
*~4 pagine*

### 8.5 Il ciclo debug del vibecoder
*~3 pagine*

**🎯 Esempio killer**: *"Non funziona il login" vs "endpoint /api/auth ritorna 401 dopo deploy" — 5 iterazioni vs 1.*

---

## GLOSSARIO 1 — Programmazione e architettura
*~80 termini · 18 pagine · 🎨 Infografica visiva integrata*

Termini di backend/infrastruttura organizzati per categoria. Ogni voce: nome IT/EN · descrizione 1 riga · esempio d'uso · come usarlo nel prompt a Claude.

### A. Ambienti e deploy (10)
localhost, sviluppo (dev), staging, produzione (prod), deploy, build, hot reload, environment variable, .env file, CI/CD

### B. Infrastruttura web (14)
server, hosting, VPS, dominio, sottodominio, IP, porta, DNS, record A, record CNAME, CDN, reverse proxy, load balancer, firewall

### C. Trasferimento codice (6)
FTP, SFTP, SSH, Git, push, pull request

### D. Linguaggi e framework (16)
HTML, CSS, JavaScript, TypeScript, React, Vue, Svelte, Next.js, PHP, Laravel, Python, Django, Flask, Node.js, Express, Tailwind

### E. Concetti backend (12)
API, endpoint, REST, GraphQL, webhook, microservizio, monolite, serverless, container, Docker, Kubernetes, CI

### F. Sicurezza e autenticazione (10)
HTTPS, certificato SSL, CORS, JWT, OAuth, session, cookie, token, hashing password, rate limiting

### G. Database (12)
SQL, NoSQL, MySQL, PostgreSQL, SQLite, MongoDB, Firebase, Supabase, Neon, ORM, migration, backup

---

## GLOSSARIO 2 — Anatomia di una pagina web
*~50 termini · 14 pagine · 🎨 Tutte le 5 infografiche del Modulo 3 ricapitolate*

Termini di UI/UX organizzati per zona della pagina. Ogni voce: nome IT/EN · come si disegna · esempio · prompt-ready.

### A. Layout (5)
header, footer, main, sidebar, navigation

### B. Navigazione (8)
navbar, sidebar nav, breadcrumb, tab, stepper, pagination, hamburger menu, anchor link

### C. Contenuto (12)
hero, card, banner, list, grid, carousel, accordion, table, gallery, embed, blockquote, divider

### D. Interazione (15)
modal, drawer, popover, tooltip, dropdown, button, link, form, input, checkbox, radio, select, slider, toggle, datepicker

### E. Feedback (8)
toast, snackbar, alert, progress bar, spinner, skeleton, empty state, error state

### F. Tipografia e layout fine (5)
heading (h1-h6), paragraph, list (ul/ol), badge, chip

---

## APPENDICI

### A. Cheat Sheet — Il Dizionario del Debug (4 pag)
Per ogni errore frequente: cosa significa, dove guardare, cosa dire a Claude.

### B. Checklist Pre-Deploy in 15 punti (2 pag)
Variabili .env, HTTPS, CORS, backup, errori console, validazione, robots.txt, sitemap, analytics, monitoring.

### C. I 10 Prompt da Salvare (3 pag)
Debug API, fix CORS, autenticazione, upload file, query filtrata, migration DB, test, documentazione, refactoring, performance.

### D. GDPR per Vibecoder Italiani (2 pag)
Cookie banner, privacy policy, dove vivono i dati (Supabase EU vs US).

### E. Decoder dei messaggi di errore comuni (3 pag) — NUOVA
Tabella: messaggio errore → in quale linguaggio appare → cosa significa → cosa cercare. Es: `EADDRINUSE`, `Cannot read property of undefined`, `404 Not Found`, `429 Too Many Requests`, `npm ERR!`, `npm WARN`, `Module not found`, `CORS policy`, ecc.

---

## 🎨 SPECIFICHE INFOGRAFICHE (16 totali)

Ogni infografica è progettata per essere **leggibile in 10 secondi** e **autosufficiente** (memorizzabile anche fuori dal contesto del libro). Stile: piatto, palette ridotta (3-4 colori), testo minimo, frecce evidenti.

| # | Modulo | Titolo | Cosa mostra |
|---|--------|--------|-------------|
| 1 | 0 | I 3 ambienti | Localhost / Staging / Produzione affiancati con URL, "chi vede", "cosa rompere costa" |
| 2 | 0 | Anatomia di un sito online | Server + Hosting + Dominio + DNS come 4 entità distinte connesse |
| 3 | 0 | Le scatole di Lego del codice | API / Library / Framework / Package / SDK come scatole annidate |
| 4 | 0 | Da localhost al server in 3 modi | FTP vs SSH vs Git push, frecce e tempi |
| 5 | 1 | Dove vive un sito | Mappa: utente, browser, DNS, CDN, server, DB con frecce |
| 6 | 1 | Il viaggio del click | 8 passi numerati con icone (click, DNS lookup, TCP, HTTP request, server, DB, response, render) |
| 7 | 2 | La danza client-server | Cliente parla, server risponde, schema scambio messaggi |
| 8 | 2 | Quali linguaggi vivono dove | Diagramma a 2 colonne (Client / Server) con loghi linguaggi nelle posizioni giuste, JS/TS al centro |
| 9 | 2 | Triangolo client-server-database | Schema relazionale 3-vertici |
| **10** | **3** | **Anatomia di una pagina (FONDAMENTALE)** | **Disegno di pagina-tipo annotato: header, nav, main, sidebar, footer, hero, cards, ecc. Tutte le etichette in IT+EN. La spina dorsale visiva del libro.** |
| 11 | 3 | Componenti di navigazione | 7 componenti disegnati con etichette (navbar, sidebar, breadcrumb, tab, stepper, pagination, hamburger) |
| 12 | 3 | Componenti di contenuto | Card, hero, banner, carousel, accordion, table disegnati e annotati |
| 13 | 3 | Componenti di interazione | Modal, drawer, toast, dropdown, form disegnati e annotati |
| 14 | 3 | Stati di un componente | Stesso bottone in 7 stati diversi (idle, hover, focus, active, disabled, loading, success) |
| 15 | 5 | Decoder degli status code | Mappa dei codici HTTP raggruppati per famiglia (2xx, 3xx, 4xx, 5xx) con icone e colori |
| 16 | 7 | DNS resolution flow | Browser → resolver locale → root → TLD → authoritative → IP risolto |

**Stack di produzione infografiche**:
- Excalidraw / Figma / Affinity Designer per la versione master
- Esportate in SVG (per stampa) e PNG (per blog/social)
- Le 5 infografiche del Modulo 3 (componenti) sono **vendibili anche da sole** come poster/cheat sheet — bonus per Bundle Pro

---

## Backmatter

- Risorse e link utili (~1 pag)
- Ringraziamenti (~0.5 pag)
- Su l'autore (~0.5 pag)
- Pagina vendita

---

## Stima totale pagine

| Sezione | Pagine |
|---------|--------|
| Prefazione | 3 |
| Modulo 0 (concetti basici) | 14 |
| Modulo 1 (deploy) | 14 |
| Modulo 2 (client-server-linguaggi) | 18 |
| **Modulo 3 (anatomia pagina, visivo)** | **22** |
| Modulo 4 (frontend) | 18 |
| Modulo 5 (backend) | 20 |
| Modulo 6 (database) | 18 |
| Modulo 7 (deploy avanzato) | 22 |
| Modulo 8 (parlare a Claude) | 16 |
| **Glossario 1 — Programmazione** | **18** |
| **Glossario 2 — Anatomia pagina** | **14** |
| Appendici A-E | 14 |
| Backmatter | 2 |
| **Totale** | **~213** |

> ⚠️ **Da 135 a 213 pagine.** È più del previsto, ma giustificato: l'utente ha esplicitamente richiesto i due glossari separati, il modulo dedicato ai concetti basici (deploy/server/hosting/DNS/FTP) e il modulo visivo sull'anatomia della pagina con infografiche.

Lettura reale: 8-9 ore in 3-4 sessioni da 2h, oppure consulto da riferimento (glossari + infografiche).

---

## Cose da decidere prima di scrivere

- [ ] **Titolo finale**: confermo "Vibecoding Serio"?
- [ ] **Sottotitolo**: confermo?
- [ ] **Struttura modulare 9 moduli** (era 6 prima, +3 dopo questo aggiornamento) ti convince?
- [ ] **2 glossari separati** (Programmazione + Anatomia pagina) ti convincono o preferisci uno unico?
- [ ] **16 infografiche** sono troppe / poche / giuste? (Stima realistica: 1 giorno di lavoro per infografica → ~3 settimane solo per quelle. Vale la pena.)
- [ ] **Pattern fisso 3-step** confermato?
- [ ] **5 Quick Wins** confermati?
- [ ] **Esempi reali Cantiere/Cozza** come case study?
- [ ] **Fai tu le infografiche o le commissioni?** (Fiverr ~30€ cad → 480€ totali. Self-made → tempo ma controllo totale.)
- [ ] **Stack citato** specifico (Supabase, Vercel, Next.js, Aruba) o agnostico?

---

**Stato**: indice 0.2, aggiornato con concetti basici + linguaggi + anatomia pagina. Da supervisionare.
Quando confermi, parto con la scrittura ordinata. Il primo Quick Win (capitolo 7.x del nuovo indice) è già scritto in `quick-wins/01-sito-si-rompe-produzione.md`.
