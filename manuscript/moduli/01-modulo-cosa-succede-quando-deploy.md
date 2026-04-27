# Modulo 1 — Cosa sta succedendo davvero quando premi "Deploy"

> 4 capitoli · 14 pagine · 50 minuti di lettura
> Pre-requisiti: Modulo 0 letto. Conosci le parole *deploy, ambiente, server, hosting, dominio, DNS, API, framework*.

---

## Mettiti comodo (di nuovo)

Adesso che hai le parole, possiamo guardare **come si mettono insieme**.

In questo modulo non ti insegno cose nuove — ti insegno a **vedere il sistema**. Quando un utente apre il tuo sito, succedono molte cose in pochi millisecondi. Tu le vedi solo come "ho premuto un link, è apparsa una pagina". Sotto, c'è una piccola coreografia tra browser, DNS, server, database e CDN.

Capirla cambia tutto. Quando il tuo sito si rompe, smetti di pensare "boh", e cominci a pensare "fammi vedere chi ha smesso di rispondere". È la differenza tra il vibecoder che chiude il PC alle due di notte e il freelancer che fixa in dieci minuti.

Quattro tappe in questo modulo:
1. La metafora del meccanico (perché ti è utile capire e non solo usare)
2. La mappa del territorio (le 5 entità che compongono ogni sito web)
3. Cosa fa davvero Claude quando gli scrivi un prompt
4. Il viaggio del click in 8 passi (dal momento del click al risultato in pagina)

Andiamo.

---

## 1.1 — Il vibecoder e il meccanico

> *Una metafora prima dei tecnicismi.*

### Due livelli di automobilisti

Ci sono due livelli di chi guida un'automobile.

**Livello 1**: chi sa guidare. Mette la chiave (o preme un pulsante), accelera, frena, parcheggia. Va dal punto A al punto B. È il 99% delle persone. È un livello onesto, valido. La macchina è uno strumento.

**Livello 2**: chi sa anche **cosa succede dentro**. Quando si accende la spia del motore, sa se è grave o se può aspettare il prossimo tagliando. Quando frena e sente un cigolio, sa che probabilmente sono le pastiglie consumate. Non è meccanico professionista. Ma quando qualcosa va storto, **non si sente nel panico**.

### La differenza che conta

Il vibecoder oggi è al **livello 1** della programmazione web. Chiede a Claude di "fare un sito", riceve qualcosa che funziona, lo mette online. Va dal punto A al punto B.

Funziona finché tutto funziona. Quando si rompe (e si rompe sempre prima o poi), il vibecoder di livello 1 non sa neanche **dove guardare**. Apre Claude, scrive "non funziona", ottiene risposte generiche, prova fix a caso. Otto messaggi dopo, è peggio di prima.

Il **vibecoder serio** — quello che vogliamo diventare in questo libro — non è uno sviluppatore senior. Non scrive codice da zero. Continua a usare l'AI. Ma ha imparato il **livello 2**: quando il sito si rompe, sa **dove guardare** — e quindi sa **cosa chiedere a Claude**.

### Cosa significa "capire il sistema"

Capire il sistema non significa saper costruire ogni pezzo da zero. Significa sapere:

- **Cosa** sta succedendo (browser → server → database)
- **Dove** può rompersi (DNS, certificato SSL, CORS, variabile d'ambiente mancante)
- **Quale entità** sta probabilmente avendo problemi quando vedi un certo errore
- **Chi chiamare**: a volte è il provider di hosting, a volte è il registrar del dominio, a volte è una variabile da settare nel pannello

Una volta che hai questa mappa mentale, il "non funziona" smette di essere uno spavento. Diventa una **diagnosi**. E le diagnosi si fanno in dieci minuti, non in dieci ore.

I prossimi tre capitoli ti danno questa mappa.

### Cosa ti porti via

1. Esistono due livelli di vibecoder: chi *usa* e basta, chi *capisce abbastanza da diagnosticare*.
2. Il livello 2 non è "diventa programmatore senior". È "smetti di andare nel panico quando qualcosa si rompe".
3. La mappa mentale del sistema è quello che separa i due livelli. È quello che costruiamo da qui in poi.

---

## 1.2 — La mappa del territorio: dove vive un sito

> *🎨 Infografica 5: Dove vive un sito — utente, browser, DNS, CDN, server, database.*

### Il sito non è "un posto"

Quando un utente visita `miosito.com`, il sito non vive in un solo posto. Vive in **almeno cinque entità diverse** che lavorano insieme.

Te le mostro tutte. Poi nei prossimi moduli le studieremo una per una.

### Le cinque entità

**1. Il browser dell'utente** (Chrome, Safari, Firefox, Edge)

È il programma che gira sul PC o sul telefono dell'utente. È la "porta d'ingresso" al tuo sito. Esegue il codice frontend (HTML, CSS, JavaScript) che il server gli ha mandato.

Caratteristica importante: il browser è **stupido per design**. Non si fida di niente, applica regole rigide di sicurezza (CORS, cookie httpOnly, HTTPS), e fa il minimo indispensabile da solo.

**2. Il sistema DNS**

L'elenco telefonico mondiale di cui abbiamo parlato nel Modulo 0. Quando l'utente digita `miosito.com`, il browser chiede al DNS dove vive il sito (qual è l'indirizzo IP del server). Il DNS risponde con un numero tipo `188.213.170.214`.

Ci vogliono 20-100 millisecondi. Se il DNS non risponde, il sito non parte nemmeno.

**3. La CDN** (Content Delivery Network) — *opzionale ma diffusissima*

La CDN è una **rete di server distribuiti nel mondo**, ognuno con una copia dei file statici del tuo sito (immagini, CSS, JavaScript, font). Servizi come Cloudflare, Cloudfront (AWS), Fastly.

Quando un utente di Tokyo apre il sito, riceve i file dal server CDN più vicino a lui (Tokyo o Seoul) — invece che dal tuo server in Italia. Risparmia tempo: 200ms invece di 800ms.

Non tutti i siti usano una CDN. Vercel e Netlify ne hanno una integrata gratis. Su VPS Aruba la aggiungi tu (Cloudflare gratuito è perfetto).

**4. Il server (la tua applicazione)**

La macchina che esegue il **codice backend** del tuo sito. Quando il browser ha bisogno di dati dinamici (login, lista prodotti, salvataggio form), chiede al server.

Il server riceve la richiesta, **esegue il tuo codice**, magari interroga il database, e risponde.

Sui PaaS (Vercel, Netlify) il server è invisibile a te. Su VPS lo gestisci tu (con SSH, nginx, PM2).

**5. Il database**

Dove vivono i dati persistenti: utenti, ordini, prodotti, sessioni. Postgres, MySQL, MongoDB, Supabase, Firebase.

Il database **non parla mai direttamente col browser**. Solo il server può interrogare il database. Questa regola è fondamentale per la sicurezza: se il browser potesse interrogare direttamente il DB, chiunque potrebbe rubare i dati di tutti.

### Una mappa visuale

Queste cinque entità sono connesse da frecce. Il flusso è sempre lo stesso:

```
   Utente
     │ apre miosito.com
     ▼
  Browser
     │
     ▼
    DNS         (chi mi dà l'IP di miosito.com?)
     │
     ▼
   CDN         (file statici cachati vicino all'utente)
     │
     ▼
  Server       (codice backend, decide cosa fare)
     │
     ▼
 Database     (dati persistenti)
```

Le frecce vanno **a doppio senso** in realtà — il server risponde al browser, il database risponde al server. Ho semplificato per leggibilità.

### Quando qualcosa si rompe, dove guardare

Questa mappa è oro. Quando il sito non funziona, percorrila in ordine:

| Sintomo | Probabile colpevole |
|---------|---------------------|
| "Sito irraggiungibile" / errore DNS | DNS non configurato o non propagato |
| Sito si carica ma immagini/css mancano | CDN o asset non deployati |
| Pagina carica ma login non funziona | Server (codice o variabili d'ambiente) |
| Login funziona ma "il prodotto è sparito" | Database o query sbagliata |
| Errore CORS in console | Server (regole CORS errate) |
| Lentezza solo in certe regioni del mondo | CDN mancante o configurata male |

Vedi la differenza? Senza la mappa, dici "non funziona". Con la mappa, dici "il browser non riesce a parlare col server, probabilmente CORS o variabile mancante" — che è già un'ipotesi diagnostica.

### Cosa ti porti via

1. Ogni sito web vive in **5 entità connesse**: browser, DNS, CDN (opzionale), server, database.
2. Il flusso va sempre **dall'utente al database e ritorno**.
3. Il **browser non parla mai col database**. Solo il server può interrogare il database. Questa regola ti salva la vita molte volte.
4. Quando qualcosa si rompe, **percorri la catena in ordine** invece di cercare a caso.

---

## 1.3 — Cosa fa davvero Claude quando scrivi un prompt

> *Caso studio: il prompt più comune del vibecoder.*

### Il prompt che hai scritto cento volte

> *"Crea un'app web con login Google e una dashboard utente."*

Lo hai scritto a Claude. Lui ti ha risposto con uno schema e con codice. Tu hai copiato, hai premuto qualche tasto, hai fatto deploy. Funziona.

Cosa ha fatto Claude in concreto? **Ha scritto sei pezzi di codice diversi, ognuno per una delle cinque entità che abbiamo appena visto** + una sesta entità (un servizio esterno). Te li mostro uno per uno.

### I sei pezzi

**Pezzo 1 — Pagina di login (frontend, gira nel browser)**

Una pagina HTML con un bottone *"Accedi con Google"*. Quando l'utente lo clicca, il browser viene reindirizzato a Google.

```javascript
<button onClick={() => signIn('google')}>Accedi con Google</button>
```

Banale. Ma è solo l'inizio.

**Pezzo 2 — Configurazione OAuth (codice backend, gira sul server)**

Il tuo backend deve dire a Google: *"Ehi Google, sono il sito miosito.com, voglio che tu autentichi i miei utenti per me. Ecco le mie credenziali (client_id e client_secret)."*

Per fare questo, qualcuno deve essere andato sulla console di Google Cloud, aver creato un'applicazione OAuth, copiato due chiavi, e messe in un file `.env`. Spesso questo passaggio Claude lo dimentica di citarlo, e tu ti chiedi perché il login non parte.

**Pezzo 3 — Endpoint di callback (codice backend, gira sul server)**

Quando Google ha autenticato l'utente, lo manda di ritorno al tuo sito su un URL specifico, tipo `https://miosito.com/api/auth/callback/google`. Il tuo backend deve avere una rotta che riceve questa chiamata, verifica con Google che sia tutto ok, e crea una sessione per l'utente.

**Pezzo 4 — Salvataggio sessione (cookie + database)**

Una volta autenticato l'utente, devi **ricordare** che è autenticato. Altrimenti la prossima richiesta non lo riconosce.

Si fa con due strumenti:
- Un **cookie** nel browser (un piccolo testo che il browser re-invia ad ogni richiesta)
- Una **sessione** sul database (una nota che dice "questo cookie corrisponde a questo utente")

Più tutto quello che Google ha mandato sull'utente: nome, email, foto profilo. Da salvare nel database.

**Pezzo 5 — Pagina protetta (frontend + middleware backend)**

La dashboard. Prima che il browser la renderizzi, il server deve verificare: *"chi sta chiedendo questa pagina è autenticato?"* Si guarda il cookie, si controlla la sessione, e se va bene si manda la dashboard. Se no, redirect al login.

**Pezzo 6 — Servizio esterno (Google OAuth)**

Tutto questo non funziona senza Google. Google è il **sesto pezzo**, ed è una delle cose più importanti da capire: **molti pezzi del tuo sito non sono "sul tuo server"**. Sono altrove, su servizi esterni che tu chiami via API.

Esempi di pezzi che spesso vivono altrove:
- Autenticazione → Auth0, Clerk, Supabase Auth, Google
- Pagamenti → Stripe, PayPal
- Email transazionali → Resend, Postmark, SendGrid
- File storage → Cloudflare R2, AWS S3, Supabase Storage
- AI → OpenAI, Anthropic, Replicate

Ognuno di questi è un pezzo "outsourcing" del tuo sistema. Tu gli mandi richieste API, loro fanno il lavoro complesso, ti rispondono.

### Perché te li ho mostrati tutti

Quando il login Google "non funziona", **uno di questi sei pezzi è rotto**.

- Il bottone non parte → pezzo 1 (frontend)
- Google non riconosce il sito → pezzo 2 (configurazione OAuth)
- Dopo l'autenticazione redirect a una pagina di errore → pezzo 3 (callback URL non configurato in produzione)
- "L'utente è autenticato ma viene sloggato subito" → pezzo 4 (cookie non `Secure`, sessione non salvata)
- "La dashboard non protegge la pagina" → pezzo 5 (middleware mancante)
- "Errore 500 al click su Accedi" → variabili d'ambiente di Google mancanti in produzione

Senza questa mappa, scrivi a Claude *"il login Google non funziona"* e lui ti propone di provare 8 cose. Con questa mappa, scrivi *"al click su Accedi vengo reindirizzato a Google ma poi sul callback ricevo un 401"* e Claude ti porta dritto al pezzo 3.

### Cosa ti porti via

1. Un prompt apparentemente semplice come *"crea un login Google"* nasconde **almeno 6 pezzi di codice diversi**.
2. I pezzi vivono in posti diversi: frontend, backend, database, e servizi esterni (Google, Stripe, ecc.).
3. **Buona parte del tuo sito non sta sul tuo server**: vive su servizi esterni che chiami via API.
4. Quando qualcosa "non funziona", il problema è quasi sempre in **uno specifico pezzo** — saperlo isolare riduce le iterazioni con Claude da 8 a 1.

---

## 1.4 — Il viaggio del click in 8 passi

> *🎨 Infografica 6: Il viaggio del click — 8 passi numerati con icone e tempi.*

### Una microstoria di 200 millisecondi

Un utente in un bar di Roma apre il telefono, digita `miosito.com`, preme invio. Dopo circa 200-800 millisecondi vede la pagina. In quei millisecondi succedono **otto cose distinte**.

Te le racconto come fossero scene di un film in slow motion. Le ho numerate.

### Passo 1 — Il click

L'utente preme invio nel browser. Il browser vede `miosito.com` e si pone una domanda: *"Dove diavolo è miosito.com?"*

Lui non lo sa. È un nome, mica un indirizzo. Deve scoprirlo.

⏱️ Tempo: istantaneo

### Passo 2 — DNS lookup

Il browser fa una richiesta al **resolver DNS** locale (di solito quello del provider di Internet, o il famoso `8.8.8.8` di Google).

*"Hey, dov'è miosito.com?"*

Il resolver, se non l'ha già in cache, fa una catena di chiamate ad altri server DNS (root, TLD, authoritative — tutto questo lo vediamo nell'infografica 16, Modulo 7) finché non trova la risposta: *"miosito.com → 188.213.170.214"*.

Il browser adesso ha l'**indirizzo IP**. Sa dove andare.

⏱️ Tempo: 20-100 ms (10-30 ms se in cache)

### Passo 3 — Connessione TCP + TLS

Il browser non può semplicemente "spedire" la richiesta. Deve **stabilire una connessione** col server. Si fa in due fasi:

**TCP handshake** (3 messaggi): *"Ciao server, ci sei?"* — *"Sì, sono qui."* — *"Bene, parliamo."* È il modo in cui Internet stabilisce ogni connessione.

**TLS handshake** (più messaggi): *"Vorrei parlare in modo cifrato. Ecco la mia chiave."* — *"Ecco il mio certificato firmato dall'autorità X."* — *"OK, da adesso parliamo cifrato."* È quello che fa apparire il **lucchetto verde** nella barra del browser. Senza TLS, sarebbe HTTP "puro" e tutti potrebbero leggere i dati che viaggiano.

⏱️ Tempo: 50-200 ms

### Passo 4 — HTTP request

Adesso che la connessione è aperta e cifrata, il browser manda finalmente la **richiesta vera**:

```
GET / HTTP/1.1
Host: miosito.com
User-Agent: Mozilla/5.0 ...
Accept: text/html, ...
Cookie: session_id=abc123...
```

Tradotto: *"Dammi la pagina principale (`/`). Ah, e ti mando anche un cookie che dice chi sono."*

⏱️ Tempo: 10-30 ms (è solo l'invio dei dati)

### Passo 5 — Server processa

Il server riceve la richiesta. Adesso esegue il tuo codice. A seconda di cosa fa la pagina, può:

- **Leggere file statici** (HTML, CSS, immagini) → veloce, pochi ms
- **Eseguire codice backend** (verificare il cookie, fare una query al database, chiamare un'API esterna) → da 10ms a parecchi secondi
- **Renderizzare HTML** dinamicamente con i dati appena letti dal database

Se il server deve fare 3 query al database e chiamare l'API di Stripe, qui ci vogliono 200-500 ms. Se è solo un file statico, 5 ms.

Questo è di solito il **collo di bottiglia** dei siti lenti. Quando un sito ci mette 4 secondi a caricare, il 95% di quelli sono qui dentro.

⏱️ Tempo: 5-2000 ms (estremamente variabile)

### Passo 6 — HTTP response

Il server ha finito. Manda la **risposta** al browser:

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Set-Cookie: session_id=xyz789; HttpOnly; Secure

<!DOCTYPE html>
<html>...
```

Tre cose:
- Lo **status code** (200, 404, 500...) — dice se è andata bene
- Gli **headers** (tipo di contenuto, cookie da settare, regole di cache...)
- Il **body** — il contenuto vero, in questo caso l'HTML della pagina

⏱️ Tempo: 10-50 ms

### Passo 7 — Browser parsa e renderizza

Il browser riceve l'HTML. Inizia a "leggerlo" — in gergo si dice *parsing*. Mentre lo legge, scopre che la pagina ha bisogno di altri file:

- Un foglio di stile CSS (`<link rel="stylesheet" href="/style.css">`)
- Uno script JavaScript (`<script src="/app.js">`)
- Tre immagini (`<img src="...">`)

Per ognuno di questi file, il browser fa **un'altra richiesta** (passo 4 di nuovo, ma stavolta è più veloce perché la connessione è già aperta). Mentre li scarica, costruisce gradualmente la pagina:

1. **DOM**: la struttura della pagina (vedi Modulo 4)
2. **Stili applicati**: ogni elemento riceve i suoi colori, font, layout
3. **JavaScript eseguito**: aggiunge interattività (form, click, animazioni)
4. **Immagini caricate**: appaiono progressivamente

⏱️ Tempo: 100-1000 ms (dipende da quanto è "pesante" la pagina)

### Passo 8 — L'utente vede

Finalmente, dopo tutto questo, **l'utente vede la pagina**. Probabilmente in 300-800 millisecondi totali, se tutto va bene.

Lui ha aspettato meno di un secondo. Non sa che dietro sono successe **otto cose distinte**. Tu, adesso, sì.

### Riepilogo coi tempi

| # | Cosa | Tempo tipico |
|---|------|--------------|
| 1 | Click | 0 ms |
| 2 | DNS lookup | 20-100 ms |
| 3 | TCP + TLS handshake | 50-200 ms |
| 4 | HTTP request | 10-30 ms |
| 5 | Server processa (codice + DB) | 5-2000 ms |
| 6 | HTTP response | 10-50 ms |
| 7 | Browser parsa + scarica risorse | 100-1000 ms |
| 8 | Visualizzazione | — |
| | **Totale tipico** | **300-1500 ms** |

### Perché questa lista è oro

Quando uno strumento di analisi (Lighthouse, GTmetrix, Vercel Speed Insights) ti dice *"il tuo sito è lento, score 47/100"*, ti sta dicendo: *"uno di questi 8 passi sta richiedendo più tempo di quanto dovrebbe"*.

- Lentezza al passo 2 → DNS lento o non in cache
- Lentezza al passo 3 → TLS lento (raro), server geograficamente lontano
- Lentezza al passo 5 → query DB lente, codice mal scritto, API esterne lente — **questo è il 80% delle ottimizzazioni**
- Lentezza al passo 7 → file CSS/JS troppo grossi, troppi script bloccanti

Senza la lista, "il sito è lento" è un'affermazione vaga. Con la lista, è una **diagnosi**.

### Cosa ti porti via

1. Quando un utente clicca un link, succedono **8 cose** in sequenza in poche centinaia di millisecondi.
2. Il **collo di bottiglia tipico** è il passo 5 (server + database).
3. Conoscere i passi ti aiuta a **diagnosticare la lentezza** invece di "boh il sito è lento".
4. È anche utile per la **sicurezza**: HTTPS al passo 3 protegge tutto quello che viaggia da lì in poi.

---

## Chiusura del Modulo 1

Adesso hai due cose nuove in testa:

- **La mappa delle 5 entità** (browser, DNS, CDN, server, database) — il sistema in cui vive ogni sito web
- **Il viaggio del click in 8 passi** — la sequenza temporale di cosa succede quando l'utente apre una pagina

Più importante di tutto: hai capito che **il "sito" non è una cosa sola**. È un sistema di pezzi distribuiti che lavorano insieme. Ogni pezzo può rompersi indipendentemente. Sapere quali sono i pezzi è il primo passo per sapere dove guardare.

Nel **Modulo 2** entriamo nel cuore della distinzione più importante: **client e server**. Quali linguaggi vivono dove. Perché esistono separati. E perché JavaScript è speciale (gira in entrambi).

---

## 🎯 Mini-quiz di autovalutazione

**1. L'utente apre un sito. Il browser non riesce a contattare il server. Quale dei 5 pezzi del sistema è probabilmente il colpevole?**

**2. Il sito si carica ma il login non funziona ("Accedi con Google" non parte). Quale pezzo del Modulo 1.3 cercheresti per primo?**

**3. Lighthouse ti dice che la pagina è lenta. Il "Time To First Byte" (TTFB) è di 1.8 secondi. In quale degli 8 passi del viaggio del click sta succedendo il rallentamento?**

**4. Perché il browser non può parlare direttamente col database?**

**5. Vero o falso: una CDN serve solo se il tuo sito ha utenti in tutto il mondo.**

---

### Risposte

1. **Il DNS** (probabilmente). Se il browser non riesce a "trovare" il server, di solito il DNS non risponde, non è configurato, o non si è propagato dopo una modifica recente. Il server potrebbe essere giù, ma il sintomo "sito irraggiungibile" punta più spesso al DNS che al server.

2. **Il pezzo 1 (frontend del bottone)** o, più probabile in produzione, **il pezzo 2 (configurazione OAuth con Google)** — magari le credenziali Google sono nel `.env` locale ma non in quello di produzione.

3. **Passo 5 — il server processa**. TTFB elevato significa che il server impiega troppo tempo a generare la risposta. Spesso sono query lente al database, codice non ottimizzato, o chiamate ad API esterne sincrone.

4. **Per sicurezza**. Se il browser potesse parlare direttamente col database, qualunque utente con un po' di malizia potrebbe leggere/modificare i dati di tutti. Il server fa da "filtro autorizzato": riceve la richiesta, verifica chi sei, decide cosa farti vedere.

5. **Falso**. Una CDN aiuta anche se i tuoi utenti sono tutti italiani — perché serve i file statici da nodi geograficamente vicini (Milano, Roma) molto più velocemente del tuo server centralizzato. Plus: scarica il tuo server dal traffico delle immagini/CSS, e ti protegge da picchi di traffico.

---

> Se hai sbagliato più di 2 risposte, rileggi i capitoli relativi prima del Modulo 2. Non c'è fretta. La mappa che stiamo costruendo qui è quella che userai per i prossimi 100 prompt a Claude.

---

*Modulo 1 redatto: 2026-04-25 · Versione 1.0 · ~14 pagine · ~3700 parole*
