# Perché il tuo sito è bellissimo in localhost e si rompe in produzione

> **Quick Win 1 di 5** · Tempo di lettura: 12 minuti · Modulo collegato: 4 (il viaggio del click)
> *Versione standalone pubblicabile come articolo blog. Il capitolo nel libro è la stessa cosa, con riferimenti incrociati ai moduli.*

---

## Il momento esatto in cui ti rendi conto

Sono le 22:47 di un martedì. Hai appena fatto deploy della prima versione del sito che hai promesso al cliente. In localhost tutto funzionava: il login, il form contatti, il salvataggio dei prodotti. Apri il dominio in produzione, clicchi "accedi", inserisci email e password, premi invio.

Niente.

Il browser si ferma per un secondo, poi una scritta rossa appare in console che non avevi mai visto prima. Il cliente ti scrive: *"Funziona?"*. Tu rispondi *"sì sì, qualche test finale"*.

Apri ChatGPT o Claude e scrivi: *"il login non funziona in produzione, aiutami"*.

Otto messaggi dopo, dopo aver provato cinque modifiche al codice che peggiorano la situazione, ti chiedi se non sia il caso di chiamare un amico programmatore vero. Vai a dormire alle due. Il giorno dopo riapri il PC pensando di aver dimenticato qualcosa di banale. **Avevi dimenticato qualcosa di banale.**

Questo capitolo ti racconta cosa, perché, e — soprattutto — come riconoscerlo in cinque minuti la prossima volta.

---

## Cosa pensa il vibecoder

> *"Se in localhost funziona, in produzione deve funzionare. È lo stesso codice."*

Errato. Il codice è lo stesso, ma il **contesto in cui gira** è completamente diverso. Localhost e produzione sono due ambienti che si somigliano ma non sono identici, e ogni differenza tra i due è un punto in cui qualcosa può rompersi.

Pensa a una macchina. La porti dal meccanico, la prova in officina, frena bene, accelera bene. Tu la porti a casa e ti accorgi che il navigatore non funziona. Cosa è cambiato? Non la macchina. È cambiato il GPS, perché la spia del GPS è collegata al satellite, non al meccanico. Il tuo sito ha decine di "satelliti" invisibili: il dominio, l'HTTPS, le variabili d'ambiente, il database remoto, il CORS, le porte del firewall. In localhost non hai bisogno di nessuno di questi. In produzione li usi tutti.

---

## Cosa succede davvero

Quando il tuo sito è in **localhost** (`http://localhost:3000` o `http://127.0.0.1:3000`):

- Il server gira sulla tua macchina, sulla porta 3000
- Frontend e backend stanno **sullo stesso indirizzo** (entrambi su `localhost:3000`)
- Il browser riconosce localhost come "ambiente fidato" e fa eccezioni di sicurezza
- Le variabili d'ambiente le legge dal tuo `.env.local`
- Il database è un container Docker che gira sul tuo PC, oppure un'istanza Supabase di sviluppo
- HTTPS non c'è, viaggi in HTTP semplice (i cookie non hanno bisogno della flag `Secure`)
- Non ci sono altri utenti, non c'è traffico, non c'è cache CDN

Quando il sito è in **produzione** (es. `https://miosito.com`):

- Il server gira su una macchina remota (VPS Aruba, Vercel, Railway), porta interna 3000 ma esposta come 443 (HTTPS)
- Il frontend e il backend potrebbero essere su domini diversi (es. `miosito.com` e `api.miosito.com`)
- Il browser applica tutte le regole di sicurezza standard, senza eccezioni
- Le variabili d'ambiente le legge dal pannello del provider, non dal tuo `.env`
- Il database è un'istanza separata, su un server cloud, raggiungibile solo via stringa di connessione configurata
- HTTPS è obbligatorio, i cookie devono avere flag `Secure` per funzionare
- Esiste traffico, esiste cache CDN, esiste rate limiting, esiste fail2ban

Già qui hai sei differenze. La maggior parte dei "non funziona in produzione" è una di queste sei.

---

## I 5 motivi per cui il tuo sito si è rotto (in ordine di frequenza)

### 1. Le variabili d'ambiente non sono settate

Il tuo `.env.local` ha 12 righe. `OPENAI_API_KEY=sk-...`, `DATABASE_URL=postgres://...`, `NEXTAUTH_SECRET=...`. In localhost le legge automaticamente. In produzione, su Vercel/Netlify/Aruba, **devi inserirle manualmente** nel pannello del servizio. Se ne dimentichi una, l'app crasha o si comporta in modo imprevedibile.

**Sintomo**: l'app si avvia, la home si vede, ma appena tocchi una funzione che usa quella variabile (es. login, fetch da API esterna, query DB) ricevi un 500 senza spiegazione, oppure un comportamento "vuoto" senza errore.

**Diagnosi rapida**: apri i log del server. Cerca righe tipo `undefined is not a function` o `Cannot read property 'X' of undefined` o `connection refused`. Se vedi qualcosa che si chiama proprio come una tua variabile (`OPENAI_API_KEY`, `DATABASE_URL`), hai trovato il colpevole.

**Soluzione**: vai nel pannello del provider di hosting → sezione "Environment Variables" → aggiungi la riga mancante → redeploy. Su Vercel basta un click. Su Aruba VPS è un edit del file `.env.production` e un restart PM2.

### 2. CORS

Il tuo frontend è su `https://miosito.com` e il tuo backend è su `https://api.miosito.com`. Il browser, per sicurezza, vieta al primo di parlare col secondo se il secondo non lo autorizza esplicitamente. È il **CORS** (Cross-Origin Resource Sharing).

In localhost non succede mai perché frontend e backend stanno entrambi su `localhost:3000` — stesso "origine", nessun problema. In produzione, appena il dominio cambia, il browser chiede al backend "ehi, autorizzi anche miosito.com a parlarti?". Se il backend non risponde con il giusto header (`Access-Control-Allow-Origin`), il browser blocca la richiesta e tu vedi un errore rosso in console che inizia con *"has been blocked by CORS policy..."*.

**Sintomo**: vedi un errore esplicito *"CORS policy"* o *"Access-Control-Allow-Origin"* nella console del browser (non nei log del server, è il browser che lo blocca prima che la richiesta arrivi). Spesso questo è il **primo** errore che si manifesta dopo un deploy.

**Soluzione**: nel codice del backend devi configurare CORS per accettare richieste da `https://miosito.com`. In Express è una riga (`app.use(cors({ origin: 'https://miosito.com' }))`). In Next.js API routes è qualche riga in più. **NON usare mai `*`** in produzione: lascia entrare chiunque, è un buco di sicurezza.

### 3. La build non è quella che pensi

Tu hai modificato un file alle 22:30. Hai fatto `git push` alle 22:35. Sono le 22:50 e il sito mostra ancora la vecchia versione. **Hai fatto la build?**

Molti deploy automatici (Vercel, Netlify, GitHub Actions) ricostruiscono ogni volta che fai push, ma su VPS Aruba con PM2 devi farlo a mano: `pnpm build` e `pm2 restart`. Se non lo fai, il server gira ancora con la build precedente. La cache del browser e della CDN possono peggiorare la cosa.

**Sintomo**: hai modificato qualcosa di evidente (testo di un bottone, colore di un'intestazione) e il sito mostra la versione vecchia. Cancelli la cache, hard reload (Ctrl+Shift+R), niente.

**Diagnosi**: sul server, controlla la data di modifica della cartella `.next` (Next.js) o `dist` (Vite). Se è di ieri, non hai ricompilato.

**Soluzione**: `git pull && pnpm build && pm2 restart <progetto>`. Se anche dopo il browser mostra la vecchia versione, è cache CDN/browser: hard reload, oppure aggiungi `?v=2` all'URL come query param di test.

### 4. Cookie e HTTPS si tradiscono a vicenda

Il tuo login funzionava in localhost. In produzione l'utente fa login, viene reindirizzato alla dashboard, e... viene rimandato al login. Continua all'infinito.

Quasi sempre è la flag `Secure` del cookie di sessione. In produzione il sito è HTTPS, il cookie viene impostato come `Secure` (cioè "viaggia solo su HTTPS"). Se per qualche motivo c'è un redirect su HTTP, il cookie non viene inviato e il server pensa che l'utente non sia loggato. Loop infinito.

**Sintomo**: login che funziona ma poi si comporta come se non avessi fatto login. Oppure login che funziona oggi e domani sei sloggato.

**Soluzione**: forzare HTTPS dovunque (redirect `http://` → `https://` in nginx). Verificare che il dominio del cookie sia corretto (se sei su `app.miosito.com` e il cookie è settato su `miosito.com`, non funziona). Verificare le configurazioni di NextAuth/Supabase per `useSecureCookies` e `cookieDomain`.

### 5. Il database remoto non è lo stesso del database locale

In localhost hai un Postgres che gira sul tuo PC (Docker o installato direttamente). Hai 12 utenti di test, hai aggiunto la colonna `phone_number` ieri, hai fatto qualche query che ha funzionato.

In produzione il database è un'altra cosa: un'istanza Supabase, o un Postgres su Neon, o uno spuntato in un container del provider. Quel database **non ha la colonna `phone_number`** se non hai fatto la migration. Quando il codice prova a leggere `user.phone_number`, riceve `undefined`. Quando prova a scriverlo, riceve un errore SQL `column "phone_number" does not exist`.

**Sintomo**: errore 500 con messaggio nei log che cita una colonna o tabella inesistente. Oppure dati che non vengono salvati silenziosamente.

**Soluzione**: applicare le migration in produzione. Con Drizzle: `pnpm drizzle-kit push` (o `migrate`) puntando al `DATABASE_URL` di produzione. Con Prisma: `prisma migrate deploy`. Con Supabase via dashboard: SQL editor + script DDL.

---

## Il framework "Diagnostica in 5 minuti"

Quando il sito si rompe in produzione, segui questo ordine. Non saltare passi.

**Minuto 1 — Apri la console del browser (F12)**
Vai su Network tab. Ricarica la pagina rotta. Cerca richieste in rosso. Cliccaci sopra e guarda lo status code. **Annota il numero**: 401, 403, 404, 500, CORS error, Failed to fetch.

**Minuto 2 — Apri i log del server**
Vercel: Functions tab → Logs. Aruba VPS: `pm2 logs <progetto> --lines 50`. Cerca riga con timestamp vicino a quando hai cliccato. **Copia l'errore completo, non solo il primo paragrafo.**

**Minuto 3 — Identifica la categoria**
- Errore in console che dice CORS → è CORS (motivo 2)
- 500 + log che dice "undefined" su una variabile dal nome familiare → variabili d'ambiente (motivo 1)
- 500 + log che dice "column does not exist" → migration DB (motivo 5)
- Login loop → cookie/HTTPS (motivo 4)
- Sito vecchio nonostante deploy → build (motivo 3)

**Minuto 4 — Leggi la sezione corrispondente di questo capitolo**
Una pagina, soluzione concreta.

**Minuto 5 — Applica la soluzione**
Una modifica alla volta. Non tutto insieme. Se la prima soluzione non funziona, **rimettila esattamente come prima** e prova la seconda.

Se in 5 minuti non capisci la categoria, è il momento di descrivere il problema a Claude. Ma ora sai descriverlo bene.

---

## Come parlarne a Claude per ottenerlo bene

> **Prompt da NON usare** (e perché ti farà perdere 30 minuti):
> *"il sito non funziona in produzione, in locale sì, aiutami"*
>
> Claude non ha visibilità sul tuo ambiente, sui log, sul codice, sul provider. Risponderà con una lista generica di "controlla A, B, C" che troverai inutile. Ti farà perdere 5 iterazioni a chiarire cose che potevi dire dall'inizio.

> **Prompt da usare** (e perché ti farà ottenere la soluzione in 1 iterazione):
>
> *"Sito Next.js 16 deployato su Vercel con dominio custom HTTPS (`miosito.com`). Backend e frontend stesso progetto. Database Supabase EU. NextAuth v5 con provider credenziali.
>
> Sintomo: l'utente fa login con successo (vedo `200 OK` su `/api/auth/callback/credentials` nel network tab), viene reindirizzato a `/dashboard`, ma `/dashboard` lo rimanda subito a `/login`. Loop infinito.
>
> In `localhost:3000` funziona perfettamente. Cosa potrebbe essere e in che ordine controllare?"*

Differenza nel risultato:
- Prima versione: Claude propone 8 cose generiche, ne provi 4, ne nessuna funziona.
- Seconda versione: Claude in genere ti chiede una verifica precisa (es. "stampa qui il valore di `cookies()` dentro la dashboard server component") perché sa già che è probabilmente un problema di cookie/secure flag su NextAuth v5.

Il pattern è sempre questo:
1. **Stack**: dichiara il framework, il provider di hosting, il database, lo strumento di auth.
2. **Sintomo preciso**: cosa fa il sito? Cosa vedi nei log? Cosa vedi nel network tab? Quale status code?
3. **Confronto localhost/produzione**: cosa è uguale, cosa è diverso?
4. **Cosa hai già provato**: per non far ripetere a Claude soluzioni già scartate.

Più contesto dai, meno iterazioni servono. Una volta che hai questo riflesso, hai trasformato Claude da "suggeritore generico" a "secondo paio di occhi specializzato".

---

## La regola che ti porti a casa

> **Localhost mente.** Funziona in localhost vuol dire "il codice è probabilmente giusto", non "il sito è pronto per la produzione".

Le cose che si rompono in produzione si rompono per via dell'**ambiente**, non del codice. Variabili, domini, HTTPS, database remoto, build, CORS. Cinque dei sei sono cose configurate fuori dal tuo IDE, in pannelli di provider di hosting o in file `.env` che non versioni.

Per ognuna delle cinque, ora hai un sintomo, una diagnosi, una soluzione, e un prompt buono per Claude. Tienile a portata di mano la prossima volta — possibilmente prima delle 22:47.

---

> 📚 Ti è piaciuto questo capitolo? È uno dei 5 Quick Win del libro **Vibecoding Serio**. Gli altri 4 trattano: cosa è davvero un'API REST, perché il login dimentica l'utente (cookie e sessioni), come non perdere i dati del database, e CORS spiegato per fixarlo da solo.
> Pre-order a 19€ (early bird) → vibecodingserio.vibecanyon.com

---

*Capitolo redatto: 2026-04-25 · Ultimo aggiornamento: 2026-04-25 · Versione 1.0*
