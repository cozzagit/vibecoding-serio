# Vibecoding Serio — Indice completo

> Versione: 0.1 · Data: 2026-04-25 · Status: da supervisionare e validare
>
> Questo è il sommario dettagliato del libro. Ogni voce qui sotto diventerà un capitolo o sotto-capitolo nel manoscritto. **Validalo prima di iniziare la scrittura full**: cambiare un titolo qui costa 30 secondi, dopo costa giorni.

---

## Dati del libro

- **Titolo provvisorio**: Vibecoding Serio
- **Sottotitolo**: Il manuale per chi costruisce siti con l'AI ma non capisce cosa sta costruendo
- **Autore**: Luca Cozza
- **Lunghezza target**: ~130 pagine, 7 ore di lettura
- **Formato**: PDF (Typst), versione lite EPUB su KDP
- **Prezzo**: 29€ Standard / 4.99€ Lite KDP / 49€ Bundle Pro
- **Lingua**: italiano
- **Edizione**: 1.0

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

Tre modalità: lineare (da inizio a fine), Quick Wins (vai ai 5 capitoli killer), riferimento (consulta glossario quando ti serve).

---

## MODULO 0 — Cosa sta succedendo davvero quando premi "Deploy"
*4 capitoli · 12 pagine · 45 min*

L'introduzione operativa. Prima di spiegare HTML o HTTP, ancoriamo il lettore.

### 0.1 Il vibecoder e il meccanico
*~3 pagine*

Metafora di apertura: chi guida una macchina senza capirla, e chi la apre quando si ferma. Tu hai costruito qualcosa, ma sei a metà strada. Questo libro ti porta dall'altra parte.

### 0.2 La mappa del territorio
*~3 pagine*

Dove vive il tuo sito quando è online: browser dell'utente, server (la tua macchina su Aruba/Vercel), database (di solito altrove), CDN (cache distribuita), DNS (l'elenco telefonico). Schema visivo.

### 0.3 Cosa fa davvero Claude quando scrivi un prompt
*~3 pagine*

Caso studio: prompt "fammi un sito con login Google". Cosa Claude scrive in concreto (frontend page, backend API, OAuth redirect, callback, session storage, DB user) e perché ognuno di questi pezzi esiste. Il lettore inizia a vedere "il sito" come un sistema di parti, non come un blocco unico.

### 0.4 Il flusso completo di una richiesta web in 8 passi
*~3 pagine*

Dal click al risultato:
1. Utente clicca un link
2. Browser risolve il dominio (DNS)
3. Browser apre connessione TCP/TLS
4. Browser manda richiesta HTTP
5. Server riceve, esegue codice, magari interroga DB
6. Server risponde (HTML, JSON, immagine)
7. Browser parsa, esegue JS, renderizza
8. Utente vede il risultato

Schema visivo. Ogni passo richiama un capitolo successivo.

**🎯 Esempio killer**: *Hai chiesto a Lovable "crea un'app con login Google". Ecco i 6 pezzi di codice che ha scritto al posto tuo e cosa fa ognuno.*

---

## MODULO 1 — Il browser è stupido (ma fa tutto lui)
*5 capitoli · 18 pagine · 1h 10min*

Frontend. Tutto quello che vede l'utente.

### 1.1 HTML: lo scheletro che nessuno legge ma tutti usano
*~3 pagine*

Cosa è un tag, perché esistono tag con significato (`<header>`, `<main>`, `<article>`, `<button>`) vs `<div>` puro. Perché Claude usa `<button>` e non `<div onClick>` (e perché tu dovresti volerlo). Accessibilità in 1 paragrafo.

### 1.2 CSS: perché il tuo sito è bello su Figma e brutto su iPhone SE
*~4 pagine*

Box model in 30 secondi. Flexbox e Grid: la differenza spiegata con la metafora del bancomat (Flex = una fila, Grid = una griglia di sportelli). Media query mobile-first. Cosa è "responsive" davvero.

### 1.3 JavaScript: la pagina si aggiorna o si ricarica?
*~3 pagine*

Differenza tra "navighi a un'altra pagina" (full reload) e "aggiorni un pezzo" (JS modifica DOM). Perché esistono SPA (single page application) e MPA. Perché il tuo sito Next.js si comporta in entrambi i modi.

### 1.4 Il DOM: dove Claude mette le mani
*~3 pagine*

Il DOM è la rappresentazione "viva" della pagina. Quando JS dice `document.getElementById(...)` sta toccando il DOM. Quando React fa `setState(...)`, dietro le quinte sta riscrivendo pezzi del DOM. Capire questo = capire perché il tuo bottone non aggiorna il contatore.

### 1.5 Componenti React/Vue: perché il tuo "card" è un pezzo indipendente
*~5 pagine*

Cos'è un componente, props, state, perché esistono. Differenza tra logica del componente e stile. Quando Claude scrive `<ProductCard product={p} />` sta riusando un blocco. Tu impari a riconoscerlo e a chiederlo bene.

**🎯 Esempio killer**: *Hai chiesto "aggiungi un accordion per le FAQ". Claude ha scritto 40 righe. Questo capitolo spiega perché erano necessarie.*

---

## MODULO 2 — Il server è il cameriere che nessuno vede
*5 capitoli · 20 pagine · 1h 15min*

Backend e API.

### 2.1 Frontend e backend: perché esistono separati
*~4 pagine*

Cosa fa il frontend (mostra). Cosa fa il backend (calcola, salva, autorizza). Perché certe cose DEVONO stare sul backend (chiavi API, query DB, validazione). Quando si possono fondere (Next.js full-stack, server actions). Caso pratico: il tuo "form contatti che invia email" — chi manda davvero la mail?

### 2.2 Cos'è un'API REST — la metafora del menù ristorante
*~4 pagine*

Cliente (browser) ordina dal menù (endpoint). Cameriere (HTTP) porta l'ordine in cucina (server). Cucina prepara e ritorna (JSON response). Se l'ordine è sbagliato il cameriere torna con un errore (4xx, 5xx). Spiegato così, REST diventa ovvio in 4 pagine.

### 2.3 I verbi HTTP: GET, POST, PUT, PATCH, DELETE
*~3 pagine*

Quando usare quale e perché. Perché il tuo "salva" è POST e non GET (idempotenza, side effect, dimensioni payload). Tabella di esempio con 10 endpoint reali.

### 2.4 I codici di stato: 200, 404, 401, 403, 500 — cosa sta gridando il server
*~5 pagine*

Lista pratica dei codici che incontri davvero. Per ognuno: cosa significa, dove guardare, cosa dire a Claude. Mini-decoder dei più frequenti:
- 200/201/204 → tutto bene
- 301/302 → redirect
- 400 → richiesta malformata
- 401 → non autenticato
- 403 → autenticato ma non autorizzato
- 404 → la rotta non esiste
- 422 → validazione fallita
- 429 → rate limit
- 500 → bug del server
- 502/503/504 → server giù o sovraccarico

### 2.5 Headers, body, JSON: il formato in cui parlano browser e server
*~4 pagine*

Anatomia di una richiesta HTTP letta nel network tab del browser. Headers (chi sei, cosa accetti, autenticazione). Body (cosa mandi). JSON come lingua franca. Aprire il network tab del browser e leggerlo è un'arma.

**🎯 Esempio killer**: *Perché la tua app Supabase funziona in locale e ritorna 401 in produzione — CORS, token, dominio che cambia.*

---

## MODULO 3 — Il database non è un foglio Excel (quasi)
*5 capitoli · 18 pagine · 1h 10min*

### 3.1 Tabelle, righe, colonne
*~3 pagine*

Mental model del database come Excel. Differenze importanti: tipi rigidi, vincoli, index, transazioni. Perché un database su 1 milione di righe gestisce ricerche in millisecondi mentre Excel piange.

### 3.2 Chiavi primarie e relazioni: perché l'utente si lega all'ordine
*~4 pagine*

`id` come identificatore unico. Foreign key. Relazioni 1-a-N (un utente, molti ordini), N-a-N (utenti e ruoli). Perché quando cancelli un utente devi pensare cosa fare degli ordini (CASCADE vs SET NULL).

### 3.3 SQL in 10 minuti: SELECT, INSERT, UPDATE, DELETE
*~4 pagine*

Le 4 query che Claude scrive il 95% delle volte. Sintassi base, esempi reali. Perché `SELECT *` è comodo ma pericoloso. WHERE, ORDER BY, LIMIT, JOIN.

### 3.4 Supabase / Firebase / Neon / PlanetScale: cosa è un DB cloud
*~4 pagine*

Quando il database non è "sulla tua macchina" ma da qualche altra parte. Pro/contro. Perché tutti i tuoi progetti AI-generated usano Supabase o Firebase. Cosa cambia tra Postgres (Supabase, Neon) e NoSQL (Firestore, Mongo).

### 3.5 Cosa succede se non fai backup (e come farlo senza piangere)
*~3 pagine*

Storia vera (anonimizzata) di chi ha perso 6 mesi di dati. Strategie di backup per i 3 casi più comuni: Supabase, Postgres su VPS, file SQLite. Setup in 10 minuti.

**🎯 Esempio killer**: *Hai aggiunto una colonna alla tabella users in locale. Il sito in produzione crasha. Si chiama "migration" e Claude può aiutarti se glielo chiedi giusto.*

---

## MODULO 4 — Il viaggio del click: dalla tastiera al server e ritorno
*6 capitoli · 22 pagine · 1h 30min*

Modulo più tecnico. Quello che separa "developer wannabe" da "freelancer che consegna senza paura".

### 4.1 DNS: perché "miosito.it" diventa un numero
*~3 pagine*

DNS = elenco telefonico di Internet. Record A, CNAME, MX, TXT. Cosa fa Cloudflare. Cosa succede quando registri un dominio Aruba/Namecheap.

### 4.2 HTTPS e certificati SSL: il lucchetto che Aruba ti installa
*~4 pagine*

Perché HTTPS e non HTTP. Cosa è Let's Encrypt. Certbot in 5 minuti. Cosa fare se il certificato scade (e perché 99% delle volte è automatico).

### 4.3 Nginx: il buttafuori del server
*~4 pagine*

Cosa fa nginx (riceve richieste, le smista). Reverse proxy spiegato semplice. Perché il tuo sito Next.js gira su porta 3000 ma l'utente vede porta 443. Esempio config commentato per progetto Next.js su VPS.

### 4.4 Variabili d'ambiente: perché la tua API key non va nel codice
*~3 pagine*

Cos'è un `.env`. Perché esiste. Cosa NON metterci (segreti pubblici client-side). Differenza tra `.env.local` (sviluppo) e variabili d'ambiente del server in produzione. `.env.example` come pattern.

### 4.5 Cookie e sessioni: come il sito ricorda chi sei
*~4 pagine*

HTTP è stateless. Sessione = nota che il server tiene su di te. Cookie = piccolo testo che il browser salva. JWT come alternativa. `httpOnly`, `Secure`, `SameSite` spiegati. Perché il tuo login si comporta diverso in localhost e in produzione.

### 4.6 CORS: l'errore più odiato spiegato in 3 paragrafi
*~4 pagine*

Cos'è CORS, perché esiste (sicurezza), perché Claude lo sbaglia. Come configurarlo correttamente per:
- Frontend e backend stesso dominio (no problem)
- Frontend statico + API su altro dominio (configurazione richiesta)
- Sviluppo localhost vs produzione (i due mondi diversi)

**🎯 Esempio killer**: *Il login funziona in localhost:3000 e dà errore CORS in produzione. Cosa chiedere a Claude per fixarlo senza rompere tutto.*

---

## MODULO 5 — Parlare a Claude come uno sviluppatore
*5 capitoli · 16 pagine · 1h*

Modulo applicativo. Tutto quello che hai imparato si traduce in prompt migliori.

### 5.1 Il problema del "fai una cosa bella": prompt vago, risultato vago
*~3 pagine*

Anatomia del prompt vibecoder generico vs prompt informato. Esempi prima/dopo: stesso obiettivo, prompt diverso, codice 10x migliore.

### 5.2 Descrivere il layout con nomi corretti
*~3 pagine*

"Metti un drawer mobile per il menu" vs "fai un menu che esce". "Toast verde dopo il submit" vs "messaggio di conferma". 20 esempi prima/dopo applicati al glossario UI.

### 5.3 Descrivere il comportamento con nomi corretti
*~3 pagine*

"Fetcha i prodotti al mount" vs "carica i prodotti". "Submit con prevent default e validazione client-side" vs "fai funzionare il form". Il lessico tecnico riduce le iterazioni.

### 5.4 Spiegare un bug a Claude senza sapere il bug
*~4 pagine*

Il pattern "incolla l'errore + descrivi il contesto + ipotesi". Come usare il network tab del browser e i log del server come diagnostica. Cosa NON dire mai: "non funziona", "fa cose strane".

### 5.5 Il ciclo debug del vibecoder
*~3 pagine*

Algoritmo: leggi l'errore, isola dove succede, ipotizza la causa, descrivi a Claude. 3 esempi reali completi (errore CORS, 401 in produzione, query DB lenta).

**🎯 Esempio killer**: *"Non funziona il login" vs "l'endpoint /api/auth ritorna 401 dopo deploy su Vercel, in locale funziona con stesso .env" — 5 iterazioni vs 1.*

---

## GLOSSARIO VISIVO
*52 termini · 14 pagine*

Per ogni voce: nome IT/EN, descrizione 1 riga, **come usarlo nel prompt a Claude**.

### A. Componenti UI (26 termini)
header · footer · hero · banner · sidebar · navbar · breadcrumb · tab · accordion · modal · drawer · card · toast · snackbar · skeleton loader · spinner · tooltip · dropdown · stepper · pagination · infinite scroll · empty state · badge · avatar · chip · divider

### B. HTTP & API (12 termini)
GET · POST · PUT · PATCH · DELETE · endpoint · request · response · payload · header HTTP · status code · JSON

### C. Deploy & Infrastruttura (14 termini)
DNS · dominio · sottodominio · IP · porta · SSL/HTTPS · certificato · nginx · reverse proxy · CDN · variabile d'ambiente · build · deploy · CI/CD

---

## APPENDICI

### A. Cheat Sheet — Il Dizionario del Debug
*~4 pagine, formato tabella stampabile*

Per ogni errore frequente: cosa significa, dove guardare, cosa dire a Claude.

### B. Checklist Pre-Deploy in 15 punti
*~2 pagine, checkbox*

Variabili .env? HTTPS attivo? CORS impostato? Database con backup? Errori console puliti? Form validazione client+server? File robots.txt? Sitemap? Analytics? Errori monitorati (Sentry/Logflare)?

### C. I 10 Prompt da Salvare
*~2 pagine*

Prompt copiabili per: debug API, fix CORS, aggiungere autenticazione, gestire upload file, fare query filtrata, scrivere migration DB, scrivere test, scrivere documentazione, refactoring sicuro, ottimizzare performance.

### D. GDPR per Vibecoder Italiani
*~2 pagine*

Cookie banner cosa serve. Privacy policy minimale. Dove vivono i dati (Supabase EU vs US). Trattamento dati per piccoli SaaS italiani. Cosa fare PRIMA di andare online.

---

## Backmatter

- Risorse e link utili (~1 pag)
- Ringraziamenti (~0.5 pag)
- Su l'autore (~0.5 pag)
- Pagina vendita: bundle Pro 49€, sconto early bird, link landing

---

## Stima totale pagine

| Sezione | Pagine |
|---------|--------|
| Prefazione | 3 |
| Modulo 0 | 12 |
| Modulo 1 | 18 |
| Modulo 2 | 20 |
| Modulo 3 | 18 |
| Modulo 4 | 22 |
| Modulo 5 | 16 |
| Glossario | 14 |
| Appendici (A+B+C+D) | 10 |
| Backmatter | 2 |
| **Totale** | **~135** |

Lettura reale: 7 ore distribuite in 2-3 sessioni da 2h.

---

## Cose da decidere prima di scrivere

- [ ] **Nome/titolo finale**: confermo "Vibecoding Serio"?
- [ ] **Sottotitolo**: confermo "Il manuale per chi costruisce siti con l'AI ma non capisce cosa sta costruendo"?
- [ ] **Pattern fisso 3-step** confermato per ogni concetto importante?
- [ ] **5 Quick Wins** confermati come capitoli "killer"? Ne togliamo o aggiungiamo?
- [ ] **Persona pubblica**: firmi "Luca Cozza" o crei brand?
- [ ] **Glossario**: 52 termini sufficienti? Ne aggiungiamo (es. termini AI: prompt, context, embedding, RAG)?
- [ ] **Stack tecnologico citato**: il libro nomina specificamente Supabase, Vercel, Aruba, Next.js — confermi o vuoi mantenere agnostico?
- [ ] **Esempi reali Cantiere/Cozza**: posso fare riferimento a progetti tuoi reali come case study?

---

**Stato**: indice 0.1, da supervisionare. Quando confermi (o cambi), si parte con la scrittura ordinata. Il primo Quick Win (capitolo standalone, pubblicabile anche come articolo) lo trovi in `quick-wins/01-sito-si-rompe-produzione.md`.
