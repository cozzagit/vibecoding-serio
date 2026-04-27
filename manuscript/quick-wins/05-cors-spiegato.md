# CORS: l'errore più odiato spiegato in modo che tu possa fixarlo da solo

> **Quick Win 5 di 5** · Tempo di lettura: 10 minuti · Modulo collegato: 7
> *Capitolo standalone pubblicabile come articolo blog.*

---

## Il momento "questa cosa di nuovo"

Apri la console del browser durante il debug. Vedi questa scritta in rosso:

```
Access to fetch at 'https://api.miosito.it/users' from origin 'https://miosito.it'
has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header
is present on the requested resource.
```

Senti il sangue salire alla testa. Apri Claude. *"Errore CORS, aiuto."*. Claude propone 5 fix. Ne provi 3, peggiora. Ne provi un quarto, un altro errore. Finisci a copiare configurazioni a caso.

Stop. Adesso CORS lo capisci, e in 10 minuti sai fixarlo da solo.

---

## Cosa pensa il vibecoder

> *"CORS è una protezione del server che blocca le mie richieste. Devo disattivarla."*

Errore. CORS non è una protezione del **server**. È una protezione del **browser**. E non si "disattiva" — si configura correttamente.

---

## Cosa succede davvero

### Il problema che CORS risolve

Immagina questo scenario, senza CORS. Tu, mentre sei loggato sul tuo home banking, apri un sito qualunque. Il sito ha JavaScript nascosto che fa:

```javascript
fetch('https://homebanking.com/transfer?amount=10000&to=hacker', { credentials: 'include' });
```

Il browser, vedendo che sei loggato su homebanking (cookie già presente), **manderebbe la richiesta con i tuoi cookie**. Il server bancario vedrebbe una richiesta autenticata e... farebbe il bonifico.

Catastrofe.

CORS è la regola del browser che dice: **un sito (origin) non può fare richieste JavaScript verso un altro origin a meno che il secondo non lo autorizzi esplicitamente.**

### Cosa è "origin"

Un **origin** è la combinazione di **protocollo + dominio + porta**.

Esempi di origin diversi:
- `https://miosito.it` ≠ `http://miosito.it` (protocollo diverso)
- `https://miosito.it` ≠ `https://api.miosito.it` (sottodominio diverso)
- `http://localhost:3000` ≠ `http://localhost:8080` (porta diversa)

Stesso origin = no CORS. Origin diversi = CORS attivo.

### Quando CORS NON è un problema

Se frontend e backend sono **stesso origin**, niente CORS:

- `https://miosito.it/index.html` chiama `https://miosito.it/api/users` → **OK**

In Next.js full-stack, frontend e backend stanno nello stesso progetto sullo stesso dominio. **Niente CORS, mai**. È una delle ragioni per cui Next.js è popolare.

### Quando CORS È un problema

Frontend e backend su domini diversi:

- `https://miosito.it` (frontend Vercel) chiama `https://api.miosito.it` (backend Aruba)
- `http://localhost:3000` (frontend Vite) chiama `http://localhost:8080` (backend Express in dev)
- Qualunque chiamata a un'API esterna **dal browser** (lato client)

In questi casi, prima della richiesta vera, il browser fa una richiesta speciale chiamata **preflight**:

```
OPTIONS /api/users HTTP/1.1
Origin: https://miosito.it
```

E aspetta che il server risponda con header CORS:

```
Access-Control-Allow-Origin: https://miosito.it
Access-Control-Allow-Methods: GET, POST, PATCH, DELETE
Access-Control-Allow-Headers: Authorization, Content-Type
Access-Control-Allow-Credentials: true
```

Tradotto: *"Sì, autorizzo `miosito.it` a chiamarmi con questi metodi e questi header"*.

Se il server **non risponde con CORS giusto**, il browser **blocca la richiesta vera**. Vedi l'errore in console.

---

## Come si fixa

### Il fix è SUL BACKEND

Punto importante. CORS non si fixa sul frontend. Sul frontend non c'è niente da fare. È il **backend** che deve mandare gli header giusti.

### Express (Node.js)

```javascript
import cors from 'cors';
app.use(cors({
  origin: ['https://miosito.it', 'http://localhost:3000'],
  credentials: true,
}));
```

3 righe. `origin` è un array che include sia produzione che dev.

### Next.js API routes

In `next.config.js`:

```javascript
module.exports = {
  async headers() {
    return [{
      source: '/api/:path*',
      headers: [
        { key: 'Access-Control-Allow-Origin', value: 'https://miosito.it' },
        { key: 'Access-Control-Allow-Methods', value: 'GET,POST,PATCH,DELETE' },
        { key: 'Access-Control-Allow-Headers', value: 'Content-Type, Authorization' },
        { key: 'Access-Control-Allow-Credentials', value: 'true' },
      ],
    }];
  },
};
```

### Laravel (PHP)

`config/cors.php`:

```php
'allowed_origins' => ['https://miosito.it', 'http://localhost:3000'],
'allowed_methods' => ['*'],
'supports_credentials' => true,
```

### Django (Python)

`pip install django-cors-headers`, poi in `settings.py`:

```python
CORS_ALLOWED_ORIGINS = [
    'https://miosito.it',
    'http://localhost:3000',
]
CORS_ALLOW_CREDENTIALS = True
```

### Nginx (se usi reverse proxy)

```nginx
add_header Access-Control-Allow-Origin "https://miosito.it" always;
add_header Access-Control-Allow-Methods "GET, POST, PATCH, DELETE" always;
add_header Access-Control-Allow-Headers "Authorization, Content-Type" always;
add_header Access-Control-Allow-Credentials "true" always;
```

### MAI usare `*` con autenticazione

Tentazione del vibecoder disperato:

```javascript
// MALE
app.use(cors({ origin: '*' }));
```

Tradotto: *"Autorizza chiunque al mondo a chiamarmi"*. Buco di sicurezza enorme se hai autenticazione. **Sempre dominio specifico.**

---

## Diagnostica in 60 secondi

Quando hai un errore CORS:

1. **Apri DevTools** → Network tab → cerca la richiesta in rosso
2. Click sulla richiesta → tab **Headers**
3. Guarda **Request Headers** — c'è un `Origin: https://miosito.it`?
4. Guarda **Response Headers** — c'è un `Access-Control-Allow-Origin`?

Se Response **non ha** `Access-Control-Allow-Origin`, il backend non sta rispondendo CORS. Vai a fixare il backend.

Se l'header c'è ma il valore non corrisponde all'`Origin` (es. `Allow-Origin: http://localhost:3000` ma tu sei su `https://miosito.it`), correggi la lista.

---

## Come parlarne a Claude per ottenerlo bene

### Prompt da NON usare

> *"errore CORS aiuto"*

Inutile, troppo poco.

### Prompt da usare

> *"Errore CORS in produzione. Il mio frontend è Next.js su Vercel (`https://app.miosito.it`). Il backend è Express + Postgres su Aruba VPS (`https://api.miosito.it`).
>
> Errore in console: `Access to fetch at 'https://api.miosito.it/users' from origin 'https://app.miosito.it' has been blocked by CORS policy`.
>
> Il backend non ha il middleware `cors` configurato. Aggiungilo per accettare:
> - `https://app.miosito.it` (produzione)
> - `http://localhost:3000` (dev)
>
> Includi `credentials: true` per i cookie httpOnly. Includi handling del preflight (OPTIONS)."*

Risultato: fix in 1 iterazione. Production-ready.

---

## La regola che ti porti a casa

> CORS non si "disattiva". CORS si **configura** sul backend. Specifica i domini esatti del frontend, mai `*`. Includi `credentials: true` se usi cookie.

E:

> Il browser è il vigile. Il backend è chi deve esibire i documenti giusti. Se ti dicono "blocked by CORS", è il backend che non ha mostrato i documenti.

---

> Quick Win 5 di 5. Hai finito i quick win — i 5 capitoli "killer" del libro **Vibecoding Serio**.
> Per il resto del lessico operativo (anatomia pagina, glossario tecnico, debug avanzato): preordina il libro completo a giugno 2026.

*Capitolo redatto: 2026-04-25 · Versione 1.0*
