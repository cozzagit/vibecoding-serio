# Modulo 5 — Il server è il cameriere che nessuno vede

> 5 capitoli · 20 pagine · 1 ora 15 minuti
> Pre-requisiti: Modulo 2 letto. Conosci la divisione client/server.

---

## Mettiti comodo

Il backend è la metà del web che l'utente non vede mai, ma da cui dipende tutto. Quando il tuo sito si "rompe" in un modo che non capisci, il 70% delle volte è qualcosa lato server. Capirlo a livello concettuale ti permette di **diagnosticare**, non più indovinare.

Cinque capitoli:

1. Frontend e backend: perché esistono separati (e quando no)
2. API REST — la metafora del menu del ristorante
3. I verbi HTTP: GET / POST / PUT / PATCH / DELETE
4. I codici di stato: cosa sta gridando il server
5. Headers, body, JSON: il formato di conversazione

---

## 5.1 — Frontend e backend: perché esistono separati

### La domanda legittima

Se il browser sa già fare tante cose, **perché serve un server?** Non potrebbe il browser parlare direttamente al database, mandare email, processare pagamenti?

La risposta è una sola, ed è importante: **sicurezza**.

Il browser è un ambiente **non fidato**. Chiunque può aprire DevTools, vedere il codice, modificarlo, intercettare le richieste. Se il browser potesse parlare direttamente col database, qualunque utente con un po' di malizia potrebbe leggere i dati di tutti.

Il server è un ambiente **fidato**. Gira su una macchina che controlli tu, dietro a un firewall, con accesso solo via SSH/credenziali. Lì puoi tenere i segreti (API key, credenziali DB) e fare i controlli di sicurezza.

### La regola d'oro

> **Tutto ciò che richiede un segreto o controlla autorizzazioni, deve passare dal server.**

Esempi:
- Verificare se un utente è autenticato → server
- Chiamare l'API di OpenAI con la tua API key → server
- Salvare un ordine nel database → server
- Mandare un'email transazionale → server
- Mostrare la lista dei prodotti pubblici → frontend (può farlo direttamente)
- Validare un form prima del submit → frontend (per UX) **e** server (per sicurezza)

### Quando i due si fondono: il full-stack

In Next.js, Remix, e simili, **frontend e backend stanno nello stesso progetto**, nella stessa codebase, magari nello stesso file. Ma anche lì la divisione esiste: ci sono **Server Components / Server Actions** (girano sul server) e **Client Components** (girano nel browser). Lo abbiamo visto nel Modulo 4.

Anche quando "tutto è nello stesso progetto", la regola d'oro vale: i segreti restano lato server. Sempre.

### Cosa ti porti via

1. **Frontend** è ambiente non fidato (browser dell'utente). **Backend** è ambiente fidato (server tuo).
2. Tutto ciò che richiede segreti o controlli autorizzazione **passa dal server**. Sempre.
3. Anche nei progetti full-stack moderni, la divisione esiste — anche se nascosta dietro `'use client'`/`'use server'`.

---

## 5.2 — API REST: la metafora del menu del ristorante

### Il funzionamento di un ristorante

Sei seduto a un ristorante. Hai un **menu** davanti. Decidi cosa vuoi, lo dici al **cameriere**. Il cameriere porta l'ordine in **cucina**. La cucina prepara il piatto. Il cameriere te lo serve.

Tu (cliente) **non vai in cucina**. Non sai chi cucina, come, con quali ingredienti. Sai solo cosa puoi ordinare (il menu) e ricevi quello che hai chiesto.

Questo è esattamente come funziona un'**API REST**.

### Il parallelismo tecnico

| Ristorante | API REST |
|------------|----------|
| Tu, il cliente | Il client (browser, app mobile) |
| Il menu | La documentazione dell'API |
| Il cameriere | La rete (HTTP) |
| L'ordine | La richiesta HTTP |
| La cucina | Il backend / server |
| Il piatto servito | La risposta HTTP |

### Cosa è un'API REST nel concreto

Un'**API REST** è un insieme di **URL** (chiamati *endpoint*) che il tuo backend espone. Ogni endpoint risponde a un certo tipo di richiesta.

Esempio. Hai un sito di gestione cantieri. Il backend espone questi endpoint:

```
GET    /api/cantieri          → ottieni la lista cantieri
GET    /api/cantieri/42       → ottieni il cantiere con id=42
POST   /api/cantieri          → crea un nuovo cantiere
PATCH  /api/cantieri/42       → modifica il cantiere 42
DELETE /api/cantieri/42       → elimina il cantiere 42
```

Il client (frontend) chiama questi endpoint quando ne ha bisogno. Il backend risponde.

### Perché si chiama "REST"

REST sta per **Representational State Transfer**. Non ti serve sapere cosa significa esattamente. Ti basta sapere che è uno **stile di progettazione delle API** dove:

- Ogni "cosa" (utente, ordine, prodotto) è una **risorsa** identificata da un URL
- Le operazioni sulle risorse usano i **verbi HTTP** standard (GET, POST, PUT, PATCH, DELETE)
- Lo stato delle risorse è scambiato in **JSON**

È lo standard più diffuso al mondo. Quando Claude scrive un backend, di default fa REST.

### Alternativa: GraphQL

Esiste un'alternativa moderna chiamata **GraphQL**. Funziona diversamente: invece di tanti endpoint, c'è **un solo endpoint** dove il client manda **query strutturate** specificando esattamente cosa vuole.

```graphql
query {
  cantiere(id: 42) {
    nome
    cliente { nome }
    preventivi { totale }
  }
}
```

Vantaggio: prendi solo i dati che ti servono, non più, non meno. Svantaggio: più complesso da implementare.

Per il vibecoder oggi: **REST è la scelta default**. GraphQL solo se hai un caso d'uso specifico (es. mobile app con bandwidth limitata, o team con tante team frontend diverse).

### Cosa ti porti via

1. Un'**API REST** è un menù di endpoint (URL) che il backend espone.
2. Ogni endpoint risponde a un tipo di richiesta (lista, singolo, crea, modifica, elimina).
3. **REST** è lo standard più diffuso. Claude di default fa REST.
4. **GraphQL** è un'alternativa moderna ma più complessa. Default REST, GraphQL solo per casi specifici.

---

## 5.3 — I verbi HTTP: GET, POST, PUT, PATCH, DELETE

### Cinque verbi, cinque significati

Quando il client manda una richiesta al server, **specifica un verbo**. Il verbo dice "che tipo di operazione voglio fare".

I cinque verbi che userai il 99% delle volte:

| Verbo | Significato | Esempio |
|-------|-------------|---------|
| **GET** | Leggi qualcosa | Dammi il cantiere 42 |
| **POST** | Crea qualcosa | Crea un nuovo cantiere |
| **PUT** | Sostituisci interamente | Sostituisci il cantiere 42 con questo |
| **PATCH** | Modifica parzialmente | Cambia solo il nome del cantiere 42 |
| **DELETE** | Elimina qualcosa | Cancella il cantiere 42 |

### GET vs POST: la differenza più importante

GET e POST sono i due verbi che incontrerai di più. La differenza pratica è:

**GET** = *"non sto cambiando niente, sto solo leggendo"*
- I dati viaggiano nella **URL** (visibili, indicizzabili)
- Può essere **cachato** dal browser
- Si può **ripetere** senza conseguenze (10 GET = stesso risultato)
- Limite di dimensione (~2KB tipici)

**POST** = *"sto creando o cambiando qualcosa"*
- I dati viaggiano nel **body** della richiesta (nascosti)
- **Non viene cachato**
- **Non si ripete** spensieratamente (10 POST = 10 oggetti creati)
- Nessun limite di dimensione pratico

> 💡 **Regola pratica**: se l'utente sta **leggendo**, GET. Se sta **modificando** dati nel sistema, POST/PUT/PATCH/DELETE.

### Idempotenza in 30 secondi

Una parola che senti spesso in ambito API: **idempotente**. Significa: "se ripeto la stessa operazione 10 volte, il risultato è lo stesso che farla 1 volta".

| Verbo | Idempotente? |
|-------|--------------|
| GET | Sì (leggi 10 volte = stesso risultato) |
| POST | **No** (creo 10 oggetti se ripeto 10 volte) |
| PUT | Sì (sostituisci 10 volte = stesso stato finale) |
| PATCH | Dipende |
| DELETE | Sì (elimini 10 volte = comunque eliminato) |

Perché ti importa? Quando Claude scrive un endpoint, deve **rispettare** la semantica del verbo. Un POST che si comporta come GET (idempotente) è un anti-pattern. Lo riconoscerai quando lo vedi.

### PUT vs PATCH: la differenza sottile

Ti rincorrono entrambi a "modificare un oggetto", ma:

- **PUT** = *"ti mando l'oggetto completo, sostituiscilo intero"*
- **PATCH** = *"ti mando solo i campi che cambiano, modifica solo quelli"*

Esempio pratico. Il cantiere 42 ha 10 campi. Vuoi cambiare solo il nome.

PUT richiede di mandare **tutti i 10 campi** (anche quelli invariati). Se ne dimentichi uno, viene cancellato.

PATCH richiede di mandare **solo il nome**. Gli altri 9 restano com'erano.

Per questo PATCH è più moderno e flessibile. Quando Claude scrive un endpoint di modifica, di solito è PATCH.

### Cosa ti porti via

1. Cinque verbi: **GET / POST / PUT / PATCH / DELETE**.
2. **GET** legge, gli altri modificano.
3. **POST** crea, **PATCH** modifica parzialmente, **DELETE** elimina, **PUT** sostituisce completamente (poco usato oggi).
4. **Idempotenza**: GET, PUT, DELETE sono ripetibili senza conseguenze. POST no.

---

## 5.4 — I codici di stato HTTP: cosa sta gridando il server

> *🎨 Infografica 15: Decoder degli status code HTTP.*

### Tre cifre che dicono molto

Ogni risposta HTTP del server include un **codice di stato** (status code) di tre cifre. Il codice ti dice **cosa è successo** alla tua richiesta. Imparare a leggerlo è fondamentale per debuggare.

I codici sono organizzati per **famiglie**:

| Famiglia | Significato | Colore mentale |
|----------|-------------|----------------|
| **2xx** | Successo | 🟢 verde |
| **3xx** | Redirect | 🟡 giallo |
| **4xx** | Errore client (colpa tua) | 🟠 arancione |
| **5xx** | Errore server (colpa loro) | 🔴 rosso |

### I 12 codici che ti servono davvero

**2xx — Successo**

- `200 OK` — Tutto ok. Risposta standard per GET, PATCH, PUT
- `201 Created` — Risorsa creata. Risposta standard per POST
- `204 No Content` — Tutto ok, ma niente da ritornare. Risposta standard per DELETE

**3xx — Redirect**

- `301 Moved Permanently` — Questa risorsa si è trasferita per sempre, vai al nuovo URL
- `302 Found` — Trasferito temporaneamente (raro oggi)
- `304 Not Modified` — Hai già la versione ultima in cache, non te la rispedisco

**4xx — Errore client**

- `400 Bad Request` — Hai mandato una richiesta malformata (JSON sbagliato, parametri mancanti)
- `401 Unauthorized` — Non sei autenticato (manca il token / sessione)
- `403 Forbidden` — Sei autenticato ma non hai i permessi per questa operazione
- `404 Not Found` — La rotta o la risorsa non esiste
- `422 Unprocessable Entity` — Validazione fallita (es. email malformata, campo obbligatorio vuoto)
- `429 Too Many Requests` — Hai superato il rate limit, rallenta

**5xx — Errore server**

- `500 Internal Server Error` — Bug nel codice del server, qualcosa è esploso
- `502 Bad Gateway` — Reverse proxy (nginx) ha problemi a comunicare col backend
- `503 Service Unavailable` — Server giù o sovraccarico
- `504 Gateway Timeout` — Backend troppo lento, il proxy ha desistito

### Diagnosi rapida: il colpevole probabile

| Codice | Tu... | Lui... |
|--------|-------|--------|
| 401 | hai dimenticato di passare token/sessione | risponde "chi sei?" |
| 403 | sei loggato ma non admin | risponde "non puoi" |
| 404 | hai sbagliato URL | risponde "non c'è" |
| 422 | hai mandato dati invalidi | risponde "valori sbagliati" |
| 500 | hai trovato un bug | il server è esploso |
| 502/504 | infrastruttura ha problemi | nginx o backend giù |

### Come parlare a Claude di un errore

Quando hai un errore, **menziona il codice**:

❌ Vago: *"il login non funziona"*
✅ Preciso: *"il POST a /api/login restituisce 401 in produzione. In locale funziona con stesso .env. Possibile problema di cookie httpOnly su HTTPS?"*

Il secondo prompt fa risparmiare a Claude (e a te) 5 iterazioni.

### Cosa ti porti via

1. Codici HTTP organizzati in 4 famiglie: **2xx successo, 3xx redirect, 4xx errore client, 5xx errore server**.
2. Te ne servono **~12 davvero**: 200, 201, 204, 301, 400, 401, 403, 404, 422, 429, 500, 502.
3. Saperli leggere = saperli **diagnosticare** in pochi secondi.
4. **Cita sempre il codice** quando descrivi un errore a Claude.

---

## 5.5 — Headers, body, JSON: il formato di conversazione

### Anatomia di una richiesta HTTP

Quando il client manda una richiesta, il messaggio è composto da tre parti:

```
POST /api/cantieri HTTP/1.1                    ← riga di stato
Host: cantiere.miosito.it                      ← header 1
Content-Type: application/json                 ← header 2
Authorization: Bearer eyJhbGc...               ← header 3
Cookie: session_id=abc123                      ← header 4

{                                              ← body (JSON)
  "nome": "Ristrutturazione Bianchi",
  "cliente_id": 7,
  "budget": 12500
}
```

Tre parti:
1. **Riga di stato**: verbo + URL + versione protocollo
2. **Headers**: metadati della richiesta (chi sei, cosa accetti, autenticazione, cookie)
3. **Body**: i dati veri (in JSON di solito)

### Headers che incontrerai

I più importanti:

- `Content-Type: application/json` — *"il body è in formato JSON"*
- `Authorization: Bearer xxx` — *"sono autenticato, ecco il token"*
- `Cookie: ...` — cookie inviati automaticamente dal browser
- `User-Agent: Chrome/...` — *"sono Chrome su Windows"*
- `Accept: application/json` — *"voglio JSON in risposta"*
- `Accept-Language: it-IT` — *"preferisco contenuti in italiano"*

### Anatomia di una risposta HTTP

Stessa struttura, dall'altra parte:

```
HTTP/1.1 201 Created                            ← stato (codice + messaggio)
Content-Type: application/json                  ← header
Set-Cookie: session_id=xyz789; HttpOnly; Secure ← header
Cache-Control: no-cache                         ← header

{                                               ← body
  "id": 42,
  "nome": "Ristrutturazione Bianchi",
  "createdAt": "2026-04-25T14:32:00Z"
}
```

### JSON: la lingua franca

**JSON** (JavaScript Object Notation) è il formato in cui parlano browser e server. Sintassi:

```json
{
  "stringa": "ciao",
  "numero": 42,
  "booleano": true,
  "nullo": null,
  "lista": [1, 2, 3],
  "oggetto": {
    "annidato": "valore"
  }
}
```

Non hai bisogno di scrivere JSON a mano. Devi solo **leggerlo** quando lo vedi negli errori o nel network tab.

> 💡 **Network tab del browser** (F12 → Network) è il tuo migliore amico per debug. Mostra tutte le richieste HTTP che il browser fa, con headers, body, status code. Imparare a leggerlo = velocità di debug 10×.

### Cosa ti porti via

1. Una richiesta HTTP ha 3 parti: **riga di stato, headers, body**.
2. **Headers** sono metadati (autenticazione, formato, cookie).
3. **Body** sono i dati veri, di solito in **JSON**.
4. **Apri il network tab del browser** (F12) ogni volta che debuggi un'API. È la tua finestra sul traffico HTTP.

---

## Chiusura del Modulo 5

Adesso il backend non è più una scatola nera:

- Sai perché esiste separato dal frontend (sicurezza)
- Sai cos'è un'API REST e i 5 verbi
- Sai diagnosticare un codice di stato in 5 secondi
- Sai cosa contiene una richiesta HTTP

Quando aprirai il network tab del browser e vedrai una riga rossa con `401`, sai esattamente dove guardare e cosa dire a Claude.

Nel **Modulo 6** entriamo nei database. SQL, ORM, migration, backup.

---

## 🎯 Mini-quiz di autovalutazione

**1. Vuoi creare un nuovo prodotto. Quale verbo HTTP usi?**

**2. Il server risponde 401 alla tua richiesta. Cosa è successo?**

**3. Differenza tra PUT e PATCH in una frase.**

**4. Cosa è il `Content-Type: application/json` in un header HTTP?**

**5. Vero o falso: 502 e 504 sono entrambi errori che indicano problemi del client.**

---

### Risposte

1. **POST**. Crea = POST. PUT è "sostituisci completamente un esistente", PATCH è "modifica parzialmente un esistente".

2. Non sei **autenticato**. Manca il token / cookie di sessione, oppure è scaduto. È diverso da 403 (sei loggato ma non hai permessi).

3. **PUT** sostituisce l'oggetto **completamente** (mandi tutti i campi). **PATCH** modifica **solo i campi che mandi** (gli altri restano com'erano). PATCH è più flessibile ed è usato di più oggi.

4. È un **header** che dice al server *"il body della richiesta è in formato JSON"*. Senza di esso, il server potrebbe interpretare il body come testo semplice e non parsare il JSON.

5. **Falso**. 502 e 504 sono **5xx**, errori **server**. Indicano problemi infrastrutturali (proxy nginx non raggiunge il backend, o backend troppo lento). Gli errori client sono i 4xx.

---

*Modulo 5 redatto: 2026-04-25 · Versione 1.0 · ~20 pagine · ~4500 parole*
