# Glossario 1 — Programmazione & architettura

> ~80 termini · 18 pagine · Riferimento rapido
>
> Per ogni voce: nome italiano + inglese · descrizione 1-2 righe · come usarlo nel prompt a Claude (quando applicabile).
> Organizzato per categoria. Stampabile come dizionario di riferimento.

---

## A. Ambienti e deploy (10 termini)

**Localhost** *(local host)*
Il tuo PC, raggiungibile da `localhost:3000` o `127.0.0.1`. Lo vedi solo tu. Sandbox per sviluppo.
↳ *"Voglio testare la feature X in localhost prima di deployare."*

**Sviluppo (Dev)** *(development)*
Ambiente non-produttivo, di solito condiviso col team, accessibile online ma non pubblico (es. `dev.miosito.com`). Per test prima del rilascio.

**Staging**
Copia esatta della produzione usata per test finali. Stesso DB schema, dati spesso anonimizzati. "Prova generale".

**Produzione (Prod)** *(production)*
Il sito live, visibile a tutti. Quello che vedono i clienti veri. Errori = email arrabbiate.
↳ *"Deploya in produzione solo dopo aver testato in staging."*

**Deploy**
L'azione di "spostare" il codice da un ambiente a quello superiore (locale → dev → staging → prod). Tipicamente automatizzato.
↳ *"Configura il deploy automatico su Vercel da push a main."*

**Build**
Il processo che trasforma il tuo codice sorgente in artefatti pronti per il server (HTML, CSS, JS bundlato, ottimizzato).
↳ *"Lancia `pnpm build` e poi controlla la cartella `.next/`."*

**Hot reload** *(hot module replacement, HMR)*
Tecnica che durante lo sviluppo ricarica solo il modulo cambiato senza riavviare tutto. Velocissimo. Tipico di Vite/Next dev.

**Environment variable** *(.env)*
Valore configurabile letto a runtime, non hardcoded nel codice. Tipico per segreti (API key) o config diverse per ambiente.
↳ *"Sposta `OPENAI_API_KEY` in env, mai nel codice."*

**`.env.example`**
File template versionato in git che mostra **i nomi** delle variabili necessarie senza i valori veri. Aiuta i collaboratori.

**CI/CD** *(Continuous Integration / Continuous Deployment)*
Automazione: ogni push fa partire test, build, deploy. Strumenti tipici: GitHub Actions, GitLab CI, CircleCI.
↳ *"Aggiungi un workflow GitHub Actions che esegue test e linting su ogni PR."*

---

## B. Infrastruttura web (14 termini)

**Server**
La macchina (fisica o virtuale) che esegue il tuo codice backend. Sta in un data center, attiva 24/7.

**Hosting**
Il fornitore che ti vende il server (Aruba, Vercel, AWS). "Agenzia immobiliare" del web.

**VPS** *(Virtual Private Server)*
Macchina virtuale dedicata. Hai accesso root completo. Costo: 5-30€/mese. Tipica per progetti seri self-hosted.
↳ *"Prendi un VPS su Aruba a 5€/mese per ospitare l'app Next.js."*

**Dominio** *(domain)*
Il nome che digiti nel browser (`miosito.it`). Si compra annualmente da un registrar (Namecheap, Aruba domini).

**Sottodominio** *(subdomain)*
Prefisso al dominio principale: `app.miosito.it`, `api.miosito.it`, `dev.miosito.it`. Gratis, configuri da DNS.

**IP** *(Internet Protocol address)*
Numero univoco di un server, tipo `188.213.170.214` (IPv4) o equivalente IPv6.

**Porta** *(port)*
Numero che identifica un servizio specifico su un server. HTTP = 80, HTTPS = 443, app dev tipiche = 3000, 8080.

**DNS** *(Domain Name System)*
Sistema mondiale che traduce nomi (miosito.it) in IP. Elenco telefonico distribuito.
↳ *"Configura il record A su Cloudflare per puntare miosito.it al VPS."*

**Record A**
Record DNS che lega un dominio a un IP. Esempio: `miosito.it → 188.213.170.214`.

**Record CNAME**
Record DNS che lega un dominio a un altro dominio (alias). Esempio: `www.miosito.it → miosito.it`.

**CDN** *(Content Delivery Network)*
Rete di server distribuiti nel mondo che cachano file statici. Cloudflare, Cloudfront, Fastly.
↳ *"Metti Cloudflare davanti al sito per cache CDN globale."*

**Reverse proxy**
Server intermedio che riceve richieste e le inoltra a un'app interna. Nginx fa questo.

**Load balancer**
Bilanciatore: distribuisce traffico tra più server identici. Per scalabilità.

**Firewall**
Filtro che decide quale traffico passa al server. Su VPS Linux: `ufw`, `iptables`, fail2ban.

---

## C. Trasferimento codice (6 termini)

**FTP** *(File Transfer Protocol)*
Protocollo vecchio per copiare file dal PC al server. FileZilla è il client più diffuso. Insicuro: usa **SFTP** invece.

**SFTP** *(Secure FTP)*
Versione cifrata di FTP. Usabile dovunque sia disponibile SSH.

**SSH** *(Secure Shell)*
Apre una shell remota sul server. Esegui comandi come se fossi seduto davanti. Modo principale di gestire un VPS.
↳ *"Connettiti via SSH al VPS per riavviare PM2."*

**Git**
Sistema di versionamento del codice. Traccia ogni modifica nel tempo, permette branch/merge, lavoro in team.

**Git push** *(push to remote)*
Manda i tuoi commit locali al repository remoto (GitHub, GitLab). Innesca il deploy se hai CI/CD.

**Pull request (PR)** *(merge request)*
Proposta di merge da un branch a un altro. Permette code review prima dell'integrazione.

---

## D. Linguaggi e framework (16 termini)

**HTML** *(HyperText Markup Language)*
Linguaggio di markup per la struttura della pagina. Tag come `<h1>`, `<p>`, `<button>`.

**CSS** *(Cascading Style Sheets)*
Linguaggio per lo stile della pagina. Colori, font, layout, animazioni.

**JavaScript (JS)**
Linguaggio di programmazione del web. Gira nel browser e — grazie a Node.js — anche sul server.

**TypeScript (TS)**
JavaScript con controllo dei tipi. Riduce bug. Default oggi nei progetti seri.
↳ *"Inizializza il progetto in TypeScript invece di JavaScript."*

**React**
Libreria UI di Meta. La più diffusa. Si scrive in JSX (JS + HTML inline). Componenti, props, state, hook.

**Vue**
Alternativa a React, più semplice da imparare. Popolare in Europa.

**Svelte**
Framework UI moderno (2019). Più snello, performance migliori.

**Next.js**
Meta-framework basato su React. Aggiunge routing, server-side rendering, API routes. Default oggi per app web moderne.

**PHP**
Linguaggio classico del web. WordPress, Drupal. Ancora il 40% di Internet.

**Laravel**
Framework PHP elegante e moderno. Sintassi pulita, batterie incluse.

**Python**
Linguaggio scientifico per eccellenza. AI/ML, data science. Anche per web (Django, Flask, FastAPI).

**Django**
Framework Python "batterie incluse" per app web complete.

**Flask**
Framework Python minimalista. Tu costruisci tutto.

**Node.js**
Runtime che esegue JavaScript fuori dal browser. Permette JS lato server.

**Express**
Framework Node.js minimalista per API. Il "Flask di Node".

**Tailwind CSS**
Libreria di classi CSS atomiche. Scrivi `className="px-6 py-3 rounded-lg"` invece di file CSS separati. Standard moderno.

---

## E. Concetti backend (12 termini)

**API** *(Application Programming Interface)*
Lista di endpoint che un server espone, accessibili via HTTP. Il "menu" del server.

**Endpoint**
Singolo URL di un'API che risponde a un certo tipo di richiesta. Es. `POST /api/users`.

**REST** *(Representational State Transfer)*
Stile di progettazione delle API basato su HTTP standard. Risorse identificate da URL, operazioni con verbi HTTP.

**GraphQL**
Alternativa moderna a REST. Il client specifica esattamente quali campi vuole. Un solo endpoint.

**Webhook**
URL che il **tuo** server espone per **ricevere** notifiche da servizi esterni. Es. Stripe ti notifica un pagamento andato a buon fine.
↳ *"Configura un webhook Stripe in `/api/webhooks/stripe`."*

**Microservizio** *(microservice)*
Architettura con tanti servizi piccoli specializzati invece di un'app grossa.

**Monolite** *(monolith)*
Architettura "tutto in uno". App singola che fa tutto. Più semplice da gestire per progetti piccoli/medi.

**Serverless**
Codice che gira "su richiesta" senza server dedicato sempre attivo. Vercel Functions, AWS Lambda. Paghi a esecuzione.

**Container**
Pacchetto isolato che contiene app + dipendenze. Tecnicamente: Docker.

**Docker**
Tecnologia di containerizzazione. Permette "funziona qui = funziona ovunque".

**Kubernetes** *(K8s)*
Orchestratore di container. Per produzioni grosse con tanti container distribuiti. Overkill per progetti piccoli.

**CI** *(Continuous Integration)*
Pratica di integrare codice frequentemente con test automatici. Vedi anche CI/CD.

---

## F. Sicurezza e autenticazione (10 termini)

**HTTPS** *(HTTP Secure)*
HTTP cifrato con TLS. Obbligatorio in produzione moderna. Lucchetto verde nella barra del browser.

**Certificato SSL/TLS**
"Passaporto digitale" del server. Emesso da una CA (Certificate Authority). Let's Encrypt = gratis.

**Let's Encrypt**
CA non-profit che emette certificati SSL gratis con rinnovo automatico ogni 90 giorni.

**CORS** *(Cross-Origin Resource Sharing)*
Regola del browser: richieste cross-origin (dominio diverso) bloccate a meno che il server destinatario non autorizzi.
↳ *"Configura CORS sul backend per accettare il dominio del frontend."*

**JWT** *(JSON Web Token)*
Token di autenticazione firmato. Contiene info utente direttamente. Stateless, scalabile.

**OAuth**
Protocollo per "login con Google/GitHub/Facebook". Permette a un sito di autenticare via terzi.

**Session**
Stato che il server tiene per ricordarsi chi è l'utente tra le richieste. Tipicamente collegato a un cookie.

**Cookie**
Piccolo testo che il server invia al browser. Il browser lo rispedisce automaticamente nelle richieste successive.

**Token**
Stringa che identifica un utente o autorizza un'operazione. Es. `Bearer eyJhbGc...`.

**Hashing password** *(bcrypt)*
Trasformazione one-way della password prima di salvarla in DB. Mai salvare password in chiaro. Standard: bcrypt cost 12+.

---

## G. Database (12 termini)

**SQL** *(Structured Query Language)*
Linguaggio per parlare ai database relazionali. SELECT, INSERT, UPDATE, DELETE.

**NoSQL**
Famiglia di database senza schema rigido. MongoDB, Firestore. Documenti tipo JSON.

**PostgreSQL (Postgres)**
Database relazionale open source. Default moderno per app web serie. Robusto, ricco di feature.

**MySQL**
Database relazionale classico. Open source. Ancora ovunque (WordPress lo usa).

**SQLite**
Database "in un file". Perfetto per piccoli progetti, tool, dev. Non per produzione web seria.

**MongoDB**
Database NoSQL documentale. Schema flessibile.

**Supabase**
Servizio che ti dà Postgres + auth + storage + real-time + API REST auto-generata. "Firebase di Postgres".

**Neon**
Postgres serverless. Scaling automatico. Ottimo con Vercel.

**Firebase**
Suite Google di servizi BaaS. Firestore (NoSQL), Auth, Storage. Mobile-first.

**ORM** *(Object-Relational Mapper)*
Libreria che traduce il tuo codice in SQL. Drizzle, Prisma, Eloquent, SQLAlchemy.
↳ *"Usa Drizzle ORM invece di scrivere SQL a mano."*

**Migration**
File versionato che descrive una modifica allo schema (es. aggiungi colonna). Permette di tenere allineati DB locale e produzione.
↳ *"Crea una migration con Drizzle per aggiungere la colonna `phone_number`."*

**Backup**
Copia dei dati del database conservata altrove. Da fare automaticamente. Da testare mensilmente. Senza, sei nelle mani del fato.

---

*Glossario 1 redatto: 2026-04-25 · Versione 1.0 · 80 termini in 7 categorie.*
