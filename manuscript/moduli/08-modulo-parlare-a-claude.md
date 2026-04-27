# Modulo 8 — Parlare a Claude come uno sviluppatore

> 5 capitoli · 16 pagine · 1 ora
> Pre-requisiti: tutti i moduli precedenti. Hai il vocabolario. Adesso lo applichi.

---

## Mettiti comodo

Sei arrivato all'ultimo modulo. Hai imparato la mappa del sistema (moduli 0-1), la divisione client-server (modulo 2), l'anatomia di una pagina (modulo 3), il frontend (modulo 4), il backend (modulo 5), i database (modulo 6), il deploy (modulo 7).

Adesso **applichiamo tutto** al modo di parlare a Claude. È un lavoro di traduzione: prendere quello che hai in testa e dirlo in modo che Claude generi codice migliore alla prima iterazione.

Cinque capitoli:

1. Il problema del "fai una cosa bella"
2. Descrivere il layout con nomi corretti
3. Descrivere il comportamento con nomi corretti
4. Spiegare un bug a Claude senza sapere il bug
5. Il ciclo debug del vibecoder serio

---

## 8.1 — Il problema del "fai una cosa bella"

### Anatomia di un prompt vago

> *"Fai una pagina di login carina."*

Cosa succede quando mandi questo a Claude?

Claude **deve indovinare**. Quale framework? Quale stile? Quali campi? Validazione? OAuth o credenziali? Cookie o JWT? Come gestisce gli errori? Layout mobile? Animazioni? Persistenza di sessione?

20 decisioni, tutte prese da Claude per te. Il risultato:
- 70% delle volte: una versione **generica e plausibile**, che non corrisponde al tuo progetto reale
- 30% delle volte: qualcosa che **non funziona** col tuo stack, che devi rifare

In entrambi i casi: **2-5 iterazioni** per arrivare al risultato giusto.

### Anatomia di un prompt informato

> *"Aggiungi una pagina di login al mio progetto Next.js 14 con NextAuth v5 e provider Credentials. Form con email + password, validazione client+server con Zod, errori inline sotto i campi. Stile Tailwind, palette terra (vedi `globals.css`). Il submit chiama l'endpoint `/api/auth/callback/credentials` esistente. Gestisci stato loading sul bottone e errore 401 mostrando 'Email o password non corretti'."*

Lo stesso obiettivo, prompt diverso. Claude:
- Non indovina niente — ha tutto specificato
- Genera codice che **si integra** col progetto esistente
- Genera **al primo colpo** quello che vuoi

Differenza: 1 iterazione invece di 5.

### La regola d'oro

Più contesto dai, meno iterazioni servono. **È matematica.**

Ogni dettaglio omesso = una decisione che Claude prende da solo = una probabilità che la sua decisione non sia quella giusta = un'iterazione di correzione.

### Il template di prompt informato

Quando devi chiedere un componente o feature, struttura così:

1. **Stack**: che framework, librerie, versioni stai usando
2. **Cosa esiste già**: file/componenti rilevanti del progetto
3. **Cosa vuoi**: la feature in linguaggio funzionale
4. **Come deve apparire**: lessico UI preciso (vedi 8.2)
5. **Come deve comportarsi**: lessico tecnico preciso (vedi 8.3)
6. **Edge case**: errori, stati vuoti, validazioni
7. **Cosa NON fare**: vincoli espliciti

Esempio compatto:

```
Stack: Next.js 14, Drizzle, Tailwind, Postgres su Supabase.

Esiste: tabella `users` con id, email, password_hash. Endpoint /api/auth/login già funzionante.

Voglio: pagina /login con form.

Layout: Hero centrato 400px width, card bianca con shadow soft.
Form con due input (email, password con toggle show/hide), checkbox "ricordami",
bottone primary full-width "Accedi", link sotto "Non hai un account? Registrati".

Comportamento: validazione client onChange con Zod (email valida, password min 8).
Submit fetch POST a /api/auth/login. Stato loading sul bottone (spinner + "Accesso..."),
errori 401 mostrati sopra il form ("Email o password errati").
Su 200, redirect a /dashboard.

Edge case: campo vuoto = errore inline. Rete giù = toast rosso.

NON: nessun OAuth provider per ora. NON usare 'use client' se non strettamente necessario.
```

Lungo? 12 righe. Tempo di scriverlo: 90 secondi. Tempo risparmiato in iterazioni: 30 minuti.

### Cosa ti porti via

1. **Prompt vago** = Claude indovina = 5 iterazioni.
2. **Prompt informato** = Claude esegue = 1 iterazione.
3. **Più contesto = meno iterazioni**. È matematica.
4. Usa il **template a 7 punti**: stack, esistente, voglio, layout, comportamento, edge case, NON.

---

## 8.2 — Descrivere il layout con nomi corretti

### Il vocabolario UI applicato

Nel Modulo 3 hai imparato il **lessico operativo** dei componenti UI. Adesso lo usi.

Confronta le due colonne:

| ❌ Vago | ✅ Preciso |
|---------|-----------|
| "Un menu che esce" | "Drawer mobile dal basso, dismissibile col swipe down" |
| "Una scritta di conferma" | "Toast verde in basso a destra, 'Salvato', auto-dismiss 4s" |
| "Una barra in cima" | "Navbar sticky con logo a sinistra, 4 link al centro, CTA primary a destra" |
| "Un blocco con la roba" | "Grid 3 colonne desktop / 1 mobile, ogni card con immagine 4:3, titolo, prezzo, bottone 'Aggiungi'" |
| "Un popup di conferma" | "Modal centrale con overlay scuro, testo 'Sei sicuro?', bottoni Annulla (ghost) e Elimina (destructive rosso)" |
| "Una scelta tra opzioni" | "Radio group esclusivo verticale, 3 opzioni, valore selezionato ha bordo accent" |

La colonna destra è 3-4 volte più lunga ma è **infinite volte più chiara**.

### Componenti che il vibecoder confonde più spesso

**Modal vs Drawer**

- **Modal**: appare al **centro** della pagina, overlay scuro dietro, **bloccante** (devi interagire prima di tornare).
- **Drawer**: entra **dal bordo** (sinistra/destra/alto/basso), tipicamente **non bloccante** (puoi anche cliccare fuori per chiudere).

Confonderli è il bug più frequente. Se vuoi un menu mobile, è un **drawer**. Se vuoi una conferma critica, è un **modal**.

**Toast vs Snackbar vs Banner**

- **Toast** / **Snackbar**: notifica **temporanea** (auto-dismiss), in un angolo della pagina.
- **Banner**: notifica **persistente**, in cima alla pagina, dismissibile dall'utente con X.

Se devi avvisare "Salvato!" → toast. Se devi dire "Manutenzione il 15 maggio" → banner.

**Dropdown vs Select**

- **Select** (input form): l'utente sceglie **un valore** da una lista. È un input.
- **Dropdown**: menu di **azioni cliccabili**. Non è un input.

Se l'utente sceglie "Italia" tra paesi → select. Se l'utente clicca "Modifica/Elimina/Esporta" → dropdown.

**Tooltip vs Popover**

- **Tooltip**: piccolo testo al **hover** del mouse. Solo informativo, non interattivo.
- **Popover**: come tooltip ma **al click**, può contenere bottoni e link interattivi.

Vuoi spiegare un'icona → tooltip. Vuoi un pannello quick-action → popover.

### Esempio applicato: la dashboard di SafeTrack

Caso reale. Vuoi una dashboard tipo SafeTrack: sidebar laterale, area centrale con KPI in card, lista di "alert recenti" sotto, e un bottone "Nuovo alert" che apre un modal.

❌ Vago:
> "Fai una dashboard con menu laterale e dentro le notifiche e un bottone per aggiungere."

✅ Preciso:
> "Dashboard con **sidebar nav** fissa sinistra (240px, collassabile su mobile in **hamburger drawer**). **Main content** con padding 32px:
> - **Grid** di 4 **card KPI** in alto (4 colonne desktop, 2 tablet, 1 mobile), ogni card con icona, valore grande, label
> - Sotto, **sezione 'Alert recenti'** con **lista** (max 10), ogni riga con avatar tipo, titolo, timestamp relativo
> - **Bottone primary** sticky in alto a destra 'Nuovo alert' che apre **modal** con form di creazione."

Differenza: il primo prompt produce 4 iterazioni di chiarimenti. Il secondo produce codice subito utilizzabile.

### Cosa ti porti via

1. Usa il **lessico UI preciso** del Modulo 3 nei prompt.
2. Distingui sempre **modal vs drawer**, **toast vs banner**, **dropdown vs select**, **tooltip vs popover**.
3. Specifica sempre **comportamento responsive** (1 col mobile, 2 tablet, 4 desktop).
4. Costruire prompt visivi precisi è **3-4× più lungo**, ma riduce le iterazioni del **70%**.

---

## 8.3 — Descrivere il comportamento con nomi corretti

### Il vocabolario tecnico applicato

Stesso esercizio del 8.2, ma per il comportamento. Con il vocabolario dei moduli 4-7:

| ❌ Vago | ✅ Preciso |
|---------|-----------|
| "Carica le cose" | "Fetch GET /api/products on mount con `useEffect`, mostra skeleton loader durante il caricamento" |
| "Salva quando preme invio" | "Submit handler con preventDefault, validation Zod, fetch POST, toast success o error" |
| "Cambia pagina" | "router.push('/dashboard') con replace=true (no back button)" |
| "Riempi quando arriva" | "useState con stato dei dati, useEffect per il fetch iniziale, refetch on focus con SWR" |
| "Aggiorna automaticamente" | "Polling ogni 30s con setInterval cleanup, oppure WebSocket subscribe ai cambi" |
| "Validalo" | "Validation client con Zod schema, mostrare errori sotto i campi con aria-invalid, validazione anche server-side per sicurezza" |

### Termini tecnici che cambiano tutto nel prompt

**fetch / mutate / refetch**
- *Fetch*: prendi i dati una volta
- *Mutate*: modifica i dati e re-fetch ottimisticamente
- *Refetch*: scarica di nuovo i dati esistenti

**onMount / onChange / onSubmit**
- Specifica quando l'azione si scatena. Sono diversi.

**state / props / context**
- *State*: dati interni al componente
- *Props*: dati passati dall'esterno
- *Context*: dati condivisi tra componenti senza prop drilling

**redirect / router.push / window.location**
- *Redirect*: cambio pagina lato server (Next.js: `redirect()` in server component)
- *router.push*: navigazione SPA lato client (Next.js: dopo submit)
- *window.location*: full page reload (raro, da evitare)

**optimistic update / pessimistic update**
- *Optimistic*: aggiorna la UI subito, rollback se fallisce
- *Pessimistic*: aspetta la conferma del server, poi aggiorna

### Esempio: form di registrazione con tutti gli stati

Compara:

❌ Vago:
> "Form di registrazione che salva l'utente."

✅ Preciso:
> "Form di registrazione con campi email, password, conferma password.
>
> **Comportamento**:
> - Validation **client onChange con Zod** (email valida, password min 12 char, conferma uguale)
> - Errori **inline sotto i campi** con `aria-invalid`
> - **Submit handler**: preventDefault, valida, fetch POST a `/api/auth/register`
> - **Stato loading**: bottone disabled + spinner + 'Creazione account...'
> - **Success (201)**: toast verde 'Account creato!', router.push('/dashboard')
> - **Error 422** (validation server): mostra errori inline (server può dire 'email già registrata')
> - **Error 500**: toast rosso 'Errore del server, riprova tra qualche minuto'
> - **Network error** (fetch fallisce): toast rosso 'Connessione assente, controlla la rete'
>
> **Sicurezza**: email check anche server-side (ovviamente). Password hashata con bcrypt cost 12. Mai loggare la password in chiaro."

Lungo? Sì. Risultato: codice **production-ready** alla prima iterazione, con tutti gli edge case gestiti.

### Cosa ti porti via

1. Usa termini tecnici precisi: **fetch, mutate, onMount, redirect, optimistic**.
2. Descrivi sempre **tutti gli stati**: idle, loading, success, error, edge case.
3. Le **frasi di sicurezza** ("hashed password", "validation server-side") attivano in Claude pattern di codice migliori.
4. Più precisione = codice **production-ready** alla prima iterazione.

---

## 8.4 — Spiegare un bug a Claude senza sapere il bug

### La situazione

Hai un bug. Il sito non funziona, vedi un errore, non sai cosa significhi. Apri Claude e... cosa scrivi?

❌ Pessimo:
> "non funziona"

❌ Medio:
> "il login dà errore"

✅ Bene:
> "[contesto stack] + [errore esatto] + [quando succede] + [cosa hai già provato]"

### I 4 ingredienti del bug report perfetto

**1. Contesto stack**

Cosa stai usando:
- Framework e versione (Next.js 14 / 15 / 16)
- Database (Supabase / Neon / Postgres locale)
- Auth (NextAuth / Supabase Auth / Clerk)
- Hosting (Vercel / VPS / Railway)
- Dominio (production / dev / localhost)

**2. Errore esatto**

NON: *"errore di rete"*.
SÌ: l'errore copiato pari pari.

```
Network: POST https://miosito.it/api/auth 500 (Internal Server Error)
Console: TypeError: Cannot read property 'session' of undefined
  at handleLogin (login.tsx:42:18)
Server log: Error: NEXTAUTH_SECRET is not defined
```

Tre log diversi (browser console, network, server) che dicono **la stessa cosa** in modi diversi. Claude legge tutti e tre e capisce.

**3. Quando succede**

- Sempre? Solo a volte?
- In locale? In produzione? Su mobile?
- Per tutti gli utenti o solo per alcuni?
- Dopo un'azione specifica?

> "Succede solo in produzione, in locale funziona. Solo dopo che l'utente clicca submit. Su tutti i browser."

**4. Cosa hai già provato**

Per non far ripetere a Claude soluzioni inutili:

> "Ho già controllato che la variabile NEXTAUTH_SECRET sia settata in Vercel (sì lo è). Ho riavviato il deploy. Ho fatto pulizia dei cookie."

### Esempio completo: bug report perfetto

> **Stack**: Next.js 14, NextAuth v5 con provider Credentials, Supabase per il DB. Deployato su Vercel, dominio `miosito.it` con SSL.
>
> **Errore**:
> - Browser console: nessun errore
> - Network tab: `POST /api/auth/callback/credentials → 200 OK`, ma redirect a `/dashboard` poi torna a `/login`
> - Server log Vercel: `[next-auth][warn][NO_SESSION_FOUND]`
>
> **Quando**: solo in produzione (`miosito.it`). In locale (`localhost:3000`) funziona perfettamente. Tutti i browser. Sempre dopo il submit del login.
>
> **Già provato**:
> - Variabile NEXTAUTH_SECRET settata in Vercel ✓
> - Variabile NEXTAUTH_URL settata su `https://miosito.it` ✓
> - Cookie clear, riprovato ✓
> - Verificato che Supabase response sia corretta (utente autenticato, sessione creata) ✓
>
> **Sospetto**: cookie httpOnly+Secure non viene impostato correttamente sul dominio production, oppure il middleware NextAuth non lo legge. Ma non sono sicuro.

Con questo prompt, Claude in 1 iterazione ti porta alla causa probabile (config NextAuth `useSecureCookies: true` e `cookies.sessionToken.options.domain` mal configurato).

### Cosa ti porti via

1. Mai *"non funziona"*. Sempre **i 4 ingredienti**: stack, errore esatto, quando, cosa già provato.
2. **Copia gli errori pari pari** dalla console, dal network, dai log. Non riassumere.
3. **Distingui** sempre tra *in locale funziona* e *in produzione no* — è la prima domanda diagnostica.
4. **Già provato** è importante quanto il bug stesso. Risparmia 5 risposte di Claude inutili.

---

## 8.5 — Il ciclo debug del vibecoder serio

### Algoritmo di debug

Quando hai un bug, segui questo flusso. **Non saltare passi**.

**Step 1 — Riproduci il bug**

Riesci a farlo succedere a comando? Sì → bene, hai il riproducibile.
No → prima cosa: capire le condizioni esatte. Senza riproducibile non si debugga.

**Step 2 — Localizza il bug**

Il bug è:
- **Frontend**? Apri DevTools, errori in console.
- **Backend**? Apri i log del server.
- **Database**? Verifica le query nel pannello Supabase / log DB.
- **Network**? Apri il network tab, status code delle richieste.

In 9 casi su 10 puoi localizzare il bug **in 30 secondi** con DevTools. È il tuo strumento principale.

**Step 3 — Isola la variabile**

Prima di chiedere a Claude, isola **esattamente quale parte** del sistema ha problemi. Tre tecniche:

- *In locale funziona, in produzione no*: ambiente.
- *Funzionava ieri, oggi no*: cosa è cambiato? Git log.
- *Funziona per X, non per Y*: dato. Confronta i due casi.

**Step 4 — Formula l'ipotesi**

Prima di chiedere a Claude, scriviti la tua ipotesi:

> *Penso che sia X perché Y. Per verificarlo dovrei controllare Z.*

Spesso, scrivendo l'ipotesi, ti accorgi della soluzione da solo. Sennò, la dai a Claude come spunto.

**Step 5 — Chiedi a Claude**

Con i 4 ingredienti del bug report (8.4) + la tua ipotesi.

**Step 6 — Verifica**

Applica la soluzione di Claude. Verifica che il bug è davvero risolto (non solo nascosto). Se è risolto, ✓. Se no, riformula con più info.

### 3 esempi reali di applicazione

**Esempio 1 — Errore CORS in produzione**

- *Riproduzione*: ✓ ogni volta in production, mai in locale.
- *Localizzazione*: console browser → "blocked by CORS policy"
- *Variabile isolata*: dominio diverso tra frontend (Vercel) e backend (Aruba VPS)
- *Ipotesi*: backend non ha CORS configurato per accettare il dominio Vercel
- *A Claude*: stack + errore esatto + ipotesi → fix in 1 iterazione

**Esempio 2 — 401 Unauthorized in produzione**

- *Riproduzione*: ✓ solo in production, dopo qualche minuto di sessione
- *Localizzazione*: network tab → `/api/profile` ritorna 401
- *Variabile isolata*: il cookie session esiste in DevTools ma non viene mandato
- *Ipotesi*: cookie `Secure` su HTTPS production, ma il flag non è settato giusto
- *A Claude*: il prompt completo → soluzione `cookies.sessionToken.options` di NextAuth

**Esempio 3 — Query DB lenta**

- *Riproduzione*: ✓ ogni caricamento della dashboard
- *Localizzazione*: server log → "Query took 4523ms"
- *Variabile isolata*: query specifica con JOIN su tre tabelle senza indici
- *Ipotesi*: manca un indice sulla foreign key `orders.user_id`
- *A Claude*: con la query EXPLAIN analyze → fix con migration di indice

### La differenza tra vibecoder ingenuo e serio

| Vibecoder ingenuo | Vibecoder serio |
|-------------------|-----------------|
| "non funziona" → Claude → 8 tentativi a caso | DevTools → log → ipotesi → Claude → fix |
| 2 ore di debug confuso | 15 minuti di debug strutturato |
| Bugs che tornano | Bugs risolti alla radice |
| "non capisco perché" | "è successo X perché Y" |

Il libro ti ha portato a essere il secondo. Adesso è esercizio: fallo per le prossime 10 issue che ti capitano. Diventerà naturale.

### Cosa ti porti via

1. **Algoritmo di debug**: Riproduci → Localizza → Isola → Ipotizza → Chiedi → Verifica.
2. **DevTools** è il tuo strumento principale. Console, Network, Application tabs.
3. Prima di chiedere a Claude, **scrivi la tua ipotesi**. Spesso ti accorgi della soluzione.
4. Bug in produzione vs locale = **prima domanda**. Quasi sempre la causa è ambiente.

---

## Chiusura del Modulo 8 (e del libro)

Hai finito il libro.

Ti ricordi com'eri all'inizio? Forse non sapevi cosa è un cookie. Sentivi parlare di CORS e ti scappava l'emoji 🤯. Davanti a un errore 500 chiudevi gli occhi.

Adesso:
- Sai mappare un'app web (browser, server, DB)
- Sai distinguere client da server e che linguaggi vivono dove
- Sai descrivere componenti UI con i nomi giusti
- Sai cosa è un'API REST, un cookie, un certificato SSL
- Sai cosa fare quando la produzione si rompe
- Sai parlare a Claude in modo che generi codice sensato alla prima iterazione

Non sei diventato un programmatore senior. Ma sei diventato un **vibecoder serio**: uno che capisce cosa sta costruendo, sa diagnosticare quando si rompe, e parla con cognizione di causa con sviluppatori veri.

Il libro finisce, il lavoro vero inizia. Continua a costruire. Ogni progetto è un'occasione di rinforzare quello che hai imparato.

Una cosa importante prima di andare:

> **Ogni volta che fai una correzione a un bug, scriviti cosa hai imparato.**

Tieni un file `IMPARATO.md` nei tuoi progetti. Ogni volta che risolvi un bug serio, una riga: *"Bug X causato da Y, risolto con Z. Lezione: ..."*. In 6 mesi avrai un libretto personale che vale più di 10 corsi.

Buon vibecoding. Sul serio.

---

## 🎯 Mini-quiz finale di tutto il libro

**1. Sai dirmi in 3 frasi cosa fa un server in un sistema web?**

**2. Cosa rende un prompt "informato" diverso da uno "vago"?**

**3. Quando vedi un errore 500, dove guardi prima?**

**4. Differenza tra modal e drawer in una frase.**

**5. La regola d'oro della divisione client/server, in una frase.**

---

### Risposte

1. *Il server riceve richieste HTTP dai client (browser, app), esegue codice (verifica auth, query al DB, chiama API esterne), e ritorna una risposta. Vive su una macchina dietro a un firewall, ha accesso a segreti, e fa da filtro sicuro tra il browser dell'utente e i dati.*

2. *Il prompt **informato** specifica stack, contesto esistente, layout preciso (con lessico UI corretto), comportamento esatto (con stati e edge case), e cosa NON fare. Il prompt **vago** lascia 20 decisioni a Claude da prendere indovinando, e produce 5× più iterazioni.*

3. *Nei **log del server**, non nel browser. Il 500 è un errore lato server (codice esploso, eccezione non gestita). Il browser non sa cosa è successo, sa solo che qualcosa è andato storto. Per capire, serve il log server (Vercel Functions log, PM2 logs, ecc.).*

4. ***Modal** è una finestra centrale con overlay che blocca il resto della pagina (per conferme critiche). **Drawer** è un pannello che entra da un bordo, tipicamente non bloccante (per menu mobile, filtri).*

5. ***Tutto ciò che richiede un segreto o controlla autorizzazioni deve passare dal server.** Sempre.*

---

Se hai sbagliato anche solo una di queste 5, hai imparato qualcosa di valore. Se non hai sbagliato niente: bravo.

---

*Modulo 8 redatto: 2026-04-25 · Versione 1.0 · ~16 pagine · ~4500 parole*

---

> **Fine del libro.**
> Glossari e appendici nelle pagine successive.
> Buon vibecoding.
