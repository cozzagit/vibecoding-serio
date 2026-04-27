# Cosa è davvero un'API REST e perché la tua app si pianta a chiamarla

> **Quick Win 2 di 5** · Tempo di lettura: 12 minuti · Modulo collegato: 5
> *Capitolo standalone pubblicabile come articolo blog.*

---

## Il momento "boh"

Hai chiesto a Claude di collegare il tuo sito a OpenAI. Lui ha scritto qualcosa con `fetch()` e una URL strana. Funziona. Sei contento. Poi succede una di queste cose:

- L'utente clicca su "Genera testo" e non succede niente
- Il sito mostra `Error: 401`
- Tutto si blocca dopo qualche utilizzo
- In locale funziona, in produzione no

In ognuno di questi casi, il problema è lo stesso: **stai usando un'API senza capire cosa è un'API**. Risolviamo.

---

## Cosa pensa il vibecoder

> *"Un'API è una cosa magica che mi permette di parlare con un altro sito. Claude scrive il codice, io lo metto, funziona. Non capisco i dettagli."*

Capisci la prima parte (è una "porta" verso un altro sistema). La seconda parte (i dettagli) è dove vivono **tutti** i tuoi problemi.

---

## Cosa succede davvero

Quando il tuo codice fa una "chiamata API" — per esempio a OpenAI — sta facendo una **richiesta HTTP**. Non è magia. È un messaggio strutturato che parte dal tuo server, attraversa Internet, arriva ai server di OpenAI, viene processato, e una risposta torna indietro.

Il messaggio che parte ha **3 parti**:

**1. Il verbo + URL** — *cosa vuoi fare e dove*

```
POST https://api.openai.com/v1/chat/completions
```

Tradotto: *"Voglio creare (POST) una chat completion all'URL X."*

I 5 verbi che incontrerai:
- **GET** = leggi qualcosa (es. lista utenti)
- **POST** = crea qualcosa (es. nuovo ordine)
- **PATCH** = modifica parzialmente
- **PUT** = sostituisci completamente
- **DELETE** = elimina

**2. Gli header** — *metadati della richiesta*

```
Authorization: Bearer sk-proj-abcd1234...
Content-Type: application/json
```

Tradotto: *"La mia API key è sk-proj-... — il body è in formato JSON."*

L'**Authorization** è dove metti la tua API key (la tua "carta d'identità" per quel servizio). Senza, il server risponde **401 Unauthorized**: *"chi sei?"*.

**3. Il body** — *i dati veri*

```json
{
  "model": "gpt-4",
  "messages": [
    { "role": "user", "content": "Ciao!" }
  ]
}
```

In JSON. Il body è quello che mandi al servizio per dirgli cosa vuoi.

### La risposta che torna indietro

Il server di OpenAI processa, e risponde con un altro messaggio HTTP:

```
200 OK
Content-Type: application/json

{
  "choices": [
    { "message": { "role": "assistant", "content": "Ciao! Come posso aiutarti?" } }
  ]
}
```

**Status code 200 = tutto ok**. Il body contiene la risposta. Il tuo codice legge il body e lo mostra all'utente.

### I codici di errore che non sono "errori vaghi"

Ogni risposta ha uno **status code** preciso. Imparare a leggerlo è metà del debug:

- **200 OK** = tutto bene
- **400 Bad Request** = hai mandato qualcosa di malformato (es. JSON sbagliato)
- **401 Unauthorized** = manca o è sbagliata la API key
- **403 Forbidden** = la key è valida ma non hai i permessi
- **429 Too Many Requests** = hai superato il limite (rate limit), rallenta
- **500 Internal Server Error** = bug del server di OpenAI, non colpa tua
- **503 Service Unavailable** = servizio momentaneamente giù

Quando vedi un 401, non è un *"errore generico"*: è il server che ti dice *"chi sei?"*. Andresti a verificare la API key.

### Perché in locale funziona e in produzione no

Il caso più comune: la tua API key è in **`.env.local`** sul tuo PC, ma in produzione (Vercel, Aruba) **non l'hai impostata**. Sintomo: 401 sistematico in produzione, mai in locale.

Fix: pannello Vercel → Environment Variables → aggiungi `OPENAI_API_KEY`. Redeploy. Funziona.

### Il rate limit (429)

OpenAI (e ogni API) ha un **rate limit**: massimo X richieste al minuto. Se superi, riceve **429 Too Many Requests**. Non è un bug — è una protezione. Soluzioni:

- Implementa **backoff exponential**: se 429, aspetta 1s e ritenta. Se ancora 429, aspetta 2s, poi 4s, poi 8s.
- **Cachea** le risposte (non fare la stessa chiamata 10 volte)
- **Coda** le richieste (massimo N concurrent)

Claude può scriverlo — basta dirglielo nel prompt.

---

## Come parlarne a Claude per ottenerlo bene

### Prompt da NON usare

> *"Collega il mio sito a OpenAI."*

Claude dovrà indovinare: dove giri questo codice? Server o client? Quale endpoint? Quale modello? Come gestisci errori? Cosa fai se 429? Streaming o no?

10 decisioni per Claude → 5 iterazioni di chiarimento.

### Prompt da usare

> *"Crea un endpoint API server-side in Next.js 14 (`app/api/generate/route.ts`) che riceve un POST con `{ prompt: string }`, chiama OpenAI Chat Completions con modello `gpt-4o-mini`, e ritorna `{ result: string }`.
>
> La API key OpenAI è in env `OPENAI_API_KEY` (già settata in Vercel).
>
> Gestisci:
> - **400** se il body è malformato o `prompt` mancante
> - **401** se la API key è invalida (loggato, non esposto al client)
> - **429** rate limit con backoff esponenziale (3 retry)
> - **500** generico se altro
>
> Il client (Client Component) chiama `fetch('/api/generate', { method: 'POST', body: JSON.stringify({ prompt }) })` con stato loading sul bottone, errori inline mostrati all'utente."*

Differenza:
- Prima versione: Claude propone qualcosa generico, tu correggi 5 volte
- Seconda versione: Claude scrive **production-ready** alla prima iterazione

### Il pattern

Quando integri un'API, dichiari sempre:
1. **Dove gira** (client/server)
2. **Quale endpoint e modello**
3. **Dov'è la API key** (env variable)
4. **Come gestire ogni status code** (400, 401, 429, 500)
5. **Il flow client** (loading, errori inline)

5 dettagli, 90 secondi di prompt, codice solido alla prima.

---

## La regola che ti porti a casa

> Un'API non è magia. È un messaggio HTTP con un verbo, un URL, header (con la tua key), e un body JSON. Il server risponde con uno status code preciso e un body.

Quando qualcosa non funziona, **apri il network tab del browser** (F12 → Network). Vedi la richiesta che parte, lo status code che torna, il body. Il bug è quasi sempre lì.

---

> Quick Win 2 di 5. I prossimi 3: cookie e sessioni · backup database · CORS spiegato.
> **Vibecoding Serio** — il libro completo a giugno 2026.

*Capitolo redatto: 2026-04-25 · Versione 1.0*
