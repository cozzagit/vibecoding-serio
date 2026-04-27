# Modulo 2 — Client e server: chi fa cosa

> 5 capitoli · 18 pagine · 1 ora 10 minuti
> Pre-requisiti: Moduli 0 e 1 letti. Conosci le 5 entità (browser, DNS, CDN, server, database) e il viaggio del click.

---

## Mettiti comodo

Adesso entriamo nel concetto **più importante** di tutto il libro.

Se assorbi solo questo modulo e lasci perdere il resto, hai già ottenuto il 60% del valore di "Vibecoding Serio". Tutto quello che farai con Claude da qui in poi sarà più chiaro, più diretto, con meno iterazioni perse.

Il concetto è: **client** e **server** sono due mondi separati, con regole diverse. Sapere quale codice gira da una parte e quale dall'altra ti permette di:

- Capire perché certi errori succedono (e dove cercarli)
- Scrivere prompt più precisi a Claude
- Riconoscere subito cosa Claude sta scrivendo (o sbagliando)
- Non commettere errori di sicurezza ovvi

In questo modulo:

1. Il modello client-server in 5 minuti
2. I linguaggi del client (frontend) — cosa gira nel browser
3. I linguaggi del server (backend) — cosa gira sul server
4. Quando un linguaggio sta su entrambi (full-stack)
5. Il database: il terzo pilastro

Andiamo.

---

## 2.1 — Il modello client-server in cinque minuti

> *🎨 Infografica 7: La danza client-server*

### Una conversazione in due

Tutta Internet, fondamentalmente, funziona così: **qualcuno chiede, qualcun altro risponde**.

- Tu apri un sito: il tuo browser **chiede**, il server del sito **risponde**.
- Apri una mail su Gmail: il browser **chiede**, il server di Google **risponde**.
- L'app di tua banca aggiorna il saldo: l'app **chiede**, il server della banca **risponde**.

Chi chiede si chiama **client**. Chi risponde si chiama **server**. Sempre.

### Le due parti hanno ruoli diversi

Sono due metà della stessa moneta, ma fanno cose diverse.

**Il client** (di solito il browser dell'utente, o un'app mobile):
- Mostra cose all'utente (testi, immagini, bottoni)
- Riceve i suoi click, le sue digitazioni
- Manda **richieste** al server
- Riceve **risposte** e aggiorna lo schermo

**Il server**:
- Aspetta richieste
- Esegue codice (esempio: cerca nel database, calcola un prezzo, manda un'email)
- Risponde al client con il risultato
- Non vede mai l'utente. Sa solo che gli arrivano richieste.

Pensa al ristorante: il **cliente al tavolo** ordina dal menù. Il **cuoco in cucina** non vede il cliente. Riceve il foglietto dal cameriere (la richiesta), prepara il piatto (esegue codice), manda il piatto al cameriere (la risposta). Mai contatto diretto. Le due parti **non si conoscono**, parlano per messaggi.

### Perché esistono separati

Una domanda legittima: *"perché il browser non fa tutto da solo? Perché serve un server?"*

Tre risposte, in ordine di importanza:

**1. Sicurezza**

Se il browser potesse fare tutto da solo, qualunque utente con un po' di malizia potrebbe leggere/modificare i dati di tutti. Un'app bancaria che gira "tutta nel browser" significherebbe che chiunque apre Chrome DevTools potrebbe vedere i saldi di tutti gli altri.

Il server agisce da **filtro autorizzato**: riceve la richiesta, verifica chi sei (autenticazione), decide cosa farti vedere (autorizzazione), e ti manda solo il pezzo che ti spetta.

**2. Dati condivisi**

Se hai un blog con 1000 utenti che leggono e commentano, quei dati (post, commenti) devono stare in un posto **centralizzato**. Non possono stare "nel browser di Mario", perché Lucia non vedrebbe mai i commenti di Mario.

Il server tiene i dati in un posto unico (il database), accessibile a tutti i client autorizzati.

**3. Cose che il browser non può fare**

Mandare un'email, processare un pagamento Stripe, integrare un servizio AI come OpenAI, salvare un file su un disco — queste cose il browser non le fa. O perché non ha gli strumenti, o perché sarebbe insicuro fargliele fare.

Il server le fa per conto del client.

### Quando il confine si sposta (full-stack moderni)

Una nota importante. In progetti moderni come **Next.js**, frontend e backend possono **condividere lo stesso codice** e girare in entrambi i mondi.

Esempio: una funzione `validateEmail()` che controlla se una mail è ben formattata può girare:
- **Lato client** per dare feedback istantaneo all'utente mentre digita
- **Lato server** per la sicurezza vera (perché lato client si può ingannare)

Stessa funzione, stesso file, due ambienti. Lo vedremo in 2.4.

### Cosa ti porti via

1. Tutta Internet è una **conversazione client-server**: chi chiede, chi risponde.
2. **Il client** mostra e raccoglie input. **Il server** custodisce dati e fa cose pesanti.
3. Esistono separati per **sicurezza, dati condivisi, e cose che il browser non sa fare**.
4. La regola generale: **se richiede una password o un dato di altri utenti, deve passare dal server**. Senza eccezioni.

---

## 2.2 — I linguaggi del client (frontend)

> *🎨 Infografica 8: Quali linguaggi vivono dove — la mappa di riferimento di tutto il libro.*

### Cosa gira nel browser

Quando apri Chrome, Firefox o Safari, dentro al browser girano **solo tre tecnologie native**:

- **HTML** — la struttura della pagina
- **CSS** — l'aspetto visivo
- **JavaScript** — l'interattività

Punto. Tutto il resto che vedi su un sito (React, Vue, Tailwind, Svelte…) è **costruito sopra** queste tre tecnologie. Il browser non sa cosa è React. Sa solo HTML, CSS e JavaScript. I framework alla fine si "compilano" in questi tre.

Vediamoli uno per uno, senza mistificare.

### HTML — lo scheletro

L'**HTML** (HyperText Markup Language) è una specie di Word per la struttura. Dici "questo è un titolo", "questo è un paragrafo", "questo è un bottone", "questa è un'immagine". Non dici **come si vede** (lo fa il CSS), né **come si comporta** (lo fa il JavaScript). Solo la struttura.

```html
<header>...</header>
<main>
  <h1>Titolo della pagina</h1>
  <p>Un paragrafo di testo.</p>
  <button>Cliccami</button>
</main>
<footer>...</footer>
```

Quando Claude scrive una pagina, scrive HTML. È la prima cosa che genera.

### CSS — la pelle

Il **CSS** (Cascading Style Sheets) descrive come si vede l'HTML. Colori, font, spaziature, layout, animazioni.

```css
button {
  background: #2563EB;
  color: white;
  padding: 12px 24px;
  border-radius: 8px;
}
```

Tutto il "design" di un sito è CSS. È quello che separa un sito che sembra del 1998 da uno che sembra del 2026.

> 💡 **Tailwind CSS**: la libreria CSS più popolare oggi. Invece di scrivere `padding: 12px 24px`, scrivi `className="py-3 px-6"`. Stessa cosa, sintassi più compatta. Quando Claude scrive interfacce moderne, quasi sempre usa Tailwind.

### JavaScript — i muscoli

Il **JavaScript** (JS) è il linguaggio che dà **vita** alla pagina. Quando clicchi un bottone, quando un menù si apre, quando un form si valida prima di inviarsi — tutto JavaScript.

```javascript
button.addEventListener('click', () => {
  alert('Hai cliccato il bottone!');
});
```

Senza JavaScript, una pagina è una specie di brochure: la guardi, ma non interagisce.

### TypeScript — JavaScript con i superpoteri

Il **TypeScript** (TS) è JavaScript con un controllo aggiuntivo dei "tipi". Tu dici "questa variabile è un numero", "questa funzione ritorna una stringa", e lo strumento ti avvisa se sbagli prima ancora di provare il codice.

```typescript
function somma(a: number, b: number): number {
  return a + b;
}

somma('ciao', 5); // ❌ TypeScript ti dice "errore: 'ciao' non è un numero"
```

In progetti seri si usa TypeScript invece di JavaScript "puro". Riduce i bug. Claude oggi quasi sempre scrive TypeScript per i progetti nuovi.

### React, Vue, Svelte — i framework UI

Scrivere applicazioni complesse direttamente in JavaScript è faticoso. I **framework UI** ti danno strumenti per organizzare il codice in **componenti riusabili**.

- **React** (di Meta): il più diffuso. Creato nel 2013. Quello che Claude usa di default.
- **Vue**: alternativa più semplice da imparare. Popolare in Europa.
- **Svelte**: il più moderno (2019). Più snello, performance migliori.
- **Angular** (di Google): più enterprise, più rigido. Lo trovi in progetti aziendali grandi.

Sono tutti uguali in cosa fanno (UI dichiarativa con componenti) — diversi in come lo fanno. **React vince per popolarità e per quantità di librerie disponibili**, e per questo è quello su cui Claude ha la mano più allenata.

### Next.js, Nuxt, SvelteKit — i meta-framework

Un livello sopra: i **meta-framework**. Prendono un framework UI (es. React) e ci aggiungono tutto quello che serve per costruire un sito serio:

- **Next.js** (basato su React) → il più popolare oggi
- **Nuxt** (basato su Vue)
- **SvelteKit** (basato su Svelte)
- **Remix** (basato su React)
- **Astro** (per siti statici/contenuto, agnostico)

Quando Claude scrive un'app web moderna, in 8 casi su 10 usa **Next.js**.

### Cosa ti porti via

1. Il browser nativamente conosce solo **HTML + CSS + JavaScript**.
2. **Tailwind** è CSS scritto in modo più rapido.
3. **TypeScript** è JavaScript con controllo extra.
4. **React, Vue, Svelte** sono framework UI per organizzare codice JS in componenti. **React vince per popolarità**.
5. **Next.js** è il meta-framework più usato oggi (React + features). Quando vedi `pages/` o `app/`, è Next.js.

---

## 2.3 — I linguaggi del server (backend)

> *Continua l'infografica 8.*

### Cosa gira sul server

Sul server può girare **qualunque linguaggio di programmazione**. Letteralmente. Il browser è limitato a JavaScript, il server no.

I più usati nel mondo web (in ordine di diffusione):

### Node.js — JavaScript sul server

**Node.js** è una runtime che permette di eseguire JavaScript **fuori dal browser**. È la rivoluzione del 2009: per la prima volta, lo stesso linguaggio gira sia frontend che backend.

Framework backend Node.js comuni:
- **Express**: il più semplice, il "Flask" del mondo Node
- **Fastify**: alternativa moderna, performance migliori
- **NestJS**: più strutturato, stile Angular

Quando vedi su Vercel o Netlify un'app Next.js, sotto sta girando Node.js. Quando Claude scrive un endpoint `/api/...`, è codice Node.js.

### PHP — il classico

Il **PHP** è il linguaggio dei siti web "tradizionali". WordPress, Joomla, Drupal — tutti PHP. Sembra antico, ma è ovunque: il **40% di Internet** gira ancora su PHP.

Framework PHP moderni:
- **Laravel**: il più popolare, elegante, sintassi pulita
- **Symfony**: più enterprise, modulare

Su hosting Aruba "Linux Hosting" il default è PHP. Se hai un sito legacy o un'agenzia te ne propone uno, è quasi sicuramente PHP+Laravel o WordPress.

### Python — il linguaggio dell'AI

Il **Python** è il linguaggio scientifico per eccellenza. È diventato lo standard per:
- AI / Machine Learning (TensorFlow, PyTorch, OpenAI SDK)
- Data Science (pandas, numpy, jupyter)
- Web scraping
- Scripting / automation

Per app web esistono framework:
- **Django**: il "Laravel di Python", batterie incluse
- **Flask**: minimalista, fai tutto a mano
- **FastAPI**: il moderno, ottimo per le API

Se il tuo progetto coinvolge AI, processamento dati, modelli ML — quasi sicuramente Python. Cantiere ad esempio ha un servizio Python per l'OCR delle bolle, anche se il sito principale è Next.js.

### Ruby — produttività estrema

**Ruby** + **Rails** è una coppia famosa. Usato in startup classiche (Airbnb, GitHub, Shopify, Basecamp). Ottimo per partire velocissimo. Meno popolare oggi rispetto a Node.js / Next.js, ma ancora forte.

### Go — performance e semplicità

**Go** (o "Golang") è il linguaggio creato da Google. Più "low-level" rispetto a Node/Python, ma molto veloce. Perfetto per microservizi, sistemi che devono reggere tanto traffico, infrastrutture cloud.

### Java, Kotlin, .NET (C#) — enterprise

**Java** (e **Kotlin**, suo cugino moderno) e **.NET** (Microsoft, linguaggio C#) sono i giganti del mondo enterprise. Banche, assicurazioni, grandi aziende. Robusti, super-tipizzati, lenti da scrivere ma stabili.

Se sviluppi un piccolo SaaS o un'app web standard, non li userai. Se finisci a lavorare con un'azienda da 1000 dipendenti, sì.

### Tabella decisionale: cosa userà Claude in base al tuo progetto

| Tipo di progetto | Stack tipico che Claude propone |
|------------------|----------------------------------|
| App web moderna full-stack (login, dashboard, CRUD) | **Next.js** + Supabase / Postgres |
| Sito vetrina + form contatti | **Astro** o **Next.js** statico + form action |
| WordPress / blog tradizionale | **PHP + WordPress** (raramente Claude propone WordPress, ma se hai un legacy…) |
| Backend API per app mobile | **Node.js + Express** o **FastAPI** |
| Progetto AI / machine learning | **Python + FastAPI** + librerie ML |
| Microservizio ad alta performance | **Go** |
| App enterprise | **Java + Spring** o **.NET** |

### Quando vedi un linguaggio in un progetto, pensa subito al contesto

Quando apri un repository e vedi:
- `package.json` → JavaScript / TypeScript / Node
- `composer.json` → PHP
- `requirements.txt` o `pyproject.toml` → Python
- `Gemfile` → Ruby
- `go.mod` → Go
- `pom.xml` o `build.gradle` → Java
- `*.csproj` → .NET / C#

Sono come la **carta d'identità** del progetto. In un secondo capisci con che mondo hai a che fare.

### Cosa ti porti via

1. Sul server può girare **qualsiasi linguaggio**. I più diffusi nel web: **Node.js, PHP, Python, Ruby, Go, Java, .NET**.
2. **Node.js** è il linguaggio del momento. È JavaScript che gira sul server. Vince per Next.js.
3. **PHP** è ancora ovunque (il 40% di Internet). WordPress lo tiene in vita.
4. **Python** è lo standard per AI / ML / data science. Se il tuo progetto tocca quei temi, sarà Python.
5. Quando apri un repo, **i file di dipendenze** ti dicono subito che linguaggio è.

---

## 2.4 — Quando un linguaggio sta su entrambi (full-stack)

### La rivoluzione di JavaScript

JavaScript ha una caratteristica unica: **gira sia nel browser che sul server**. Tutti gli altri linguaggi che abbiamo visto girano solo da una parte (PHP solo server, Python quasi solo server, ecc.).

Questo crea un'opportunità potente per chi sviluppa: **scrivere lo stesso codice una volta, usarlo in due posti**.

### Esempio concreto: validazione email

Vuoi che quando l'utente digita la sua email, il form gli dia subito un feedback ("formato non valido") senza aspettare il submit. Allo stesso tempo, sul server vuoi essere sicuro che la mail sia valida prima di salvarla nel database (perché l'utente potrebbe ingannare la validazione client).

In un progetto **non full-stack** (frontend in React, backend in PHP), dovresti scrivere:
- Una funzione `validateEmail()` in JavaScript per il frontend
- Una funzione `validate_email()` in PHP per il backend
- **Due funzioni che fanno la stessa cosa**, in linguaggi diversi, da mantenere allineate

In un progetto **full-stack JavaScript** (Next.js, Remix, ecc.):

```typescript
// validation.ts — UNA funzione
export function validateEmail(email: string): boolean {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
```

E poi:

```typescript
// app/components/Form.tsx — usata nel CLIENT
import { validateEmail } from '@/lib/validation';

const handleChange = (e) => {
  if (!validateEmail(e.target.value)) {
    setError('Email non valida');
  }
};

// app/api/users/route.ts — usata nel SERVER
import { validateEmail } from '@/lib/validation';

export async function POST(request) {
  const { email } = await request.json();
  if (!validateEmail(email)) {
    return Response.json({ error: 'Email non valida' }, { status: 400 });
  }
  // ...salva nel DB
}
```

Stesso codice, due posti. Una sola fonte di verità. Bug fixato una volta, fixato in entrambi.

### "use client" e "use server" in Next.js

Next.js (e simili) ha portato questo concetto al massimo. Nello stesso file di un componente puoi avere codice che gira:
- **Sul server** (componenti server, default)
- **Nel browser** (componenti client, segnati con `'use client'`)

```tsx
// Questo gira sul server (default)
async function ProductPage({ id }) {
  const product = await fetchFromDatabase(id); // codice server-only
  return <ProductDetail product={product} />;
}

'use client';
// Questo gira nel browser
function AddToCartButton({ productId }) {
  const [adding, setAdding] = useState(false); // codice client-only
  return <button onClick={() => setAdding(true)}>Aggiungi</button>;
}
```

È una distinzione importante. Tu come vibecoder devi sapere che esiste, anche se Claude la gestisce per te. Quando vedi `'use client'` in cima a un file, significa: *"questo pezzo girerà nel browser"*. Senza, gira sul server.

### Quando scegliere full-stack JS

**Pro**:
- Riusi codice tra client e server
- Un solo linguaggio da imparare
- Strumenti unificati (un solo `package.json`, una sola build)
- Deploy semplificato (es. Vercel)

**Contro**:
- Se hai bisogno di librerie scientifiche (ML, AI), Python è meglio
- Se hai team con expertise PHP, ha senso restare in PHP
- Se hai un sito enterprise legacy, non riscrivi tutto

In sintesi: **se parti da zero un progetto web moderno, Next.js full-stack è la scelta più probabile** che Claude ti proporrà — proprio perché unifica i due mondi.

### Cosa ti porti via

1. **JavaScript è speciale**: gira in entrambi (client + server) grazie a Node.js.
2. Questo permette progetti **full-stack JavaScript** dove il codice è condiviso. Il framework principe è **Next.js**.
3. Quando vedi `'use client'` in cima a un file Next.js, significa "questo gira nel browser". Senza, gira sul server.
4. Per progetti web moderni partiti da zero, è la scelta più probabile di Claude.

---

## 2.5 — Il database: il terzo pilastro

> *🎨 Infografica 9: Triangolo client-server-database.*

### Né client, né server: una cosa a parte

Fin qui abbiamo parlato di due entità: client e server. Ma manca la terza, fondamentale: il **database**.

Il database è dove vivono i **dati persistenti** del tuo sito. "Persistenti" significa: che restano lì anche quando spegni il server, anche quando il browser si chiude. Gli utenti, i prodotti, gli ordini, le foto, i commenti — tutto ciò che deve durare nel tempo sta nel database.

### Le tre entità in un triangolo

Ogni applicazione web ha **tre vertici**:

```
              CLIENT
              (browser, app mobile)
                /  \
               /    \
              /      \
         HTTP/        \HTTP
            /          \
           /            \
   SERVER ─────────── DATABASE
   (logica, API)        SQL/ORM
```

- **Client** parla col **server** via HTTP (la conversazione che abbiamo visto in 2.1)
- **Server** parla col **database** via SQL o ORM
- **Client e database NON parlano direttamente**. Mai.

### Perché client e database non parlano direttamente

Lo abbiamo già detto in 2.1: **sicurezza**. Se il browser potesse parlare col DB, qualunque utente con un po' di malizia potrebbe leggere/modificare i dati di tutti.

> ⚠️ **Eccezione importante**: Supabase e Firebase hanno un meccanismo chiamato **Row Level Security** (RLS) che permette al client di parlare col database **direttamente, ma con regole di sicurezza definite a livello DB**. È una soluzione moderna ma rischiosa per chi non sa cosa sta facendo. Quando Claude usa Supabase per un'app, devi sapere che le RLS sono spesso quello che separa "tutti vedono tutto" da "ognuno vede solo i propri dati".

### Come parla il server col database: SQL

Il linguaggio universale dei database **relazionali** (i più diffusi: Postgres, MySQL, SQLite) è **SQL** (Structured Query Language). 4 verbi base:

```sql
SELECT * FROM users WHERE city = 'Como';     -- leggi
INSERT INTO users (name, city) VALUES ('Marco', 'Como'); -- crea
UPDATE users SET city = 'Milano' WHERE id = 1;          -- modifica
DELETE FROM users WHERE id = 1;                         -- cancella
```

Il libro non ti insegna SQL a fondo (è nel Modulo 6). Per ora ti basta sapere che il server, ogni volta che il client gli chiede dei dati, **traduce la richiesta in SQL** e parla col database.

### ORM — il traduttore tra codice e SQL

Scrivere SQL a mano è scomodo e rischioso (rischio SQL injection). I moderni framework usano un **ORM** (Object-Relational Mapper): una libreria che ti permette di scrivere query in modo "naturale" nel tuo linguaggio, e l'ORM le traduce in SQL.

Esempio in TypeScript con **Drizzle** (l'ORM moderno più popolare per Node.js):

```typescript
// Tu scrivi questo (TypeScript):
const userList = await db.select()
  .from(users)
  .where(eq(users.city, 'Como'));

// Drizzle traduce in SQL:
// SELECT * FROM users WHERE city = 'Como';
```

ORM popolari per ogni linguaggio:
- **Node.js / TypeScript** → Drizzle, Prisma, Sequelize
- **PHP** → Eloquent (Laravel)
- **Python** → SQLAlchemy (Flask), Django ORM
- **Ruby** → ActiveRecord (Rails)

Quando Claude scrive un endpoint backend, quasi sempre usa un ORM. Tu come vibecoder devi sapere che esiste e cosa fa: **traduce il tuo codice in query SQL al database**.

### SQL vs NoSQL

Ci sono due famiglie di database:

**Database SQL / relazionali** (PostgreSQL, MySQL, SQLite, Supabase):
- Dati strutturati in tabelle, righe, colonne
- Schema rigido (sai esattamente che dati ci sono dentro)
- Eccellenti per dati relazionati (utente → ordini → prodotti)
- Sono la scelta default per il 90% dei progetti

**Database NoSQL / documentali** (MongoDB, Firestore, DynamoDB):
- Dati come "documenti" simili a JSON
- Schema flessibile (ogni documento può avere campi diversi)
- Buoni per dati molto eterogenei o per scaling massiccio
- Più rischiosi senza disciplina

> 💡 **Per il vibecoder che parte oggi**: punta su **SQL (Postgres su Supabase, Neon, o Aruba VPS)**. È la scelta che genera meno problemi futuri. NoSQL ha ancora senso in casi molto specifici — se Claude ti propone Firestore senza un motivo forte, valuta se non è meglio Supabase.

### Cosa ti porti via

1. Il **database** è il terzo vertice. Ci vivono i dati persistenti (utenti, prodotti, ordini).
2. **Solo il server parla col database**. Il client mai (con eccezioni di Supabase/Firebase + RLS, ma è materia avanzata).
3. Si parla col DB in **SQL** (per i database relazionali). Il server usa un **ORM** per scrivere SQL in modo più sicuro e leggibile.
4. **SQL Postgres** è la scelta default moderna. NoSQL solo per casi specifici.

---

## Chiusura del Modulo 2

Adesso hai in testa la **struttura mentale** che separa un vibecoder ingenuo da uno serio:

- **Client** ⇄ **Server** ⇄ **Database**: i tre vertici di ogni app web
- Quali **linguaggi** vivono dove (HTML/CSS/JS/React lato client; PHP/Python/Node/Go lato server)
- **JavaScript** è speciale: gira in entrambi (full-stack)
- Il **database** parla solo col server, mai col client

Quando Claude ti scrive 200 righe di codice, ora sai:
- Quale parte gira nel browser
- Quale parte gira sul server
- Dove vivono i dati
- Dove cercare quando qualcosa non funziona

Nel **Modulo 3** entriamo nel mondo **visivo**: l'anatomia di una pagina web. Tutti i componenti UI con il nome giusto. Quello che ti serve per dire a Claude *"metti un drawer mobile per il menu"* invece di *"fai un menu che esce"*.

---

## 🎯 Mini-quiz di autovalutazione

**1. Hai un'app dove l'utente compila un form e i dati devono essere salvati. Il browser dell'utente può salvare direttamente nel database?**

**2. Quale linguaggio gira sia lato client che lato server, ed è il motivo per cui esiste Next.js?**

**3. Cosa significa il commento `'use client'` in cima a un file Next.js?**

**4. Apri un nuovo progetto su GitHub e vedi un file `composer.json`. Di che linguaggio è il backend?**

**5. Vero o falso: SQL e NoSQL sono due tipi di linguaggi di programmazione.**

---

### Risposte

1. **No**. Per sicurezza, il client non parla mai direttamente col database. Il flusso è: client → server (via HTTP) → database (via SQL). Il server fa da filtro autorizzato. (Eccezione: Supabase con Row Level Security, ma è una scelta avanzata da fare con piena consapevolezza.)

2. **JavaScript**. Grazie a Node.js, lo stesso linguaggio gira in entrambi. Next.js sfrutta questa caratteristica per far condividere codice tra client e server.

3. *"Questo file (componente) gira nel browser, non sul server"*. Senza la direttiva, in Next.js 14+ i componenti sono "server components" di default. Sapere quale è quale evita molti errori (es. usare API browser-only in un componente server).

4. **PHP**. Il file `composer.json` è il package manager di PHP (come `package.json` per Node.js). Probabilmente il framework è Laravel o Symfony.

5. **Falso**. SQL e NoSQL sono due tipi di **database**, non di linguaggi. SQL è anche un linguaggio (Structured Query Language) usato per parlare ai database relazionali, ma il termine "SQL/NoSQL" si riferisce alla famiglia di database, non al linguaggio del backend.

---

> Se hai sbagliato più di 2 risposte, rileggi prima del Modulo 3. Ma onestamente, se sei arrivato fin qui con attenzione, hai assorbito la mappa. Il resto è solo applicazione.

---

*Modulo 2 redatto: 2026-04-25 · Versione 1.0 · ~18 pagine · ~4400 parole*
