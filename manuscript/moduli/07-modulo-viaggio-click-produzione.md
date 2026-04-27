# Modulo 7 — Il viaggio del click in produzione

> 6 capitoli · 22 pagine · 1 ora 30 minuti
> Pre-requisiti: Modulo 1 letto. Conosci il flusso del click in 8 passi.

---

## Mettiti comodo

Questo è il **modulo più tecnico** del libro. Ti porta a fondo nei meccanismi che separano "funziona in localhost" da "funziona in produzione". Sei concetti, sei capitoli.

Quando padroneggi questi sei, sei un **vibecoder serio**: puoi mettere online un'app, gestire il dominio, debuggare problemi di rete, capire come funziona la sicurezza dei cookie. Sono le competenze che il 90% dei vibecoder ingenui non ha, e che il cliente ti riconosce a vista.

I sei capitoli:

1. DNS — l'elenco telefonico di Internet (in profondità)
2. HTTPS e certificati SSL — il lucchetto che Aruba ti installa
3. Nginx — il buttafuori del server
4. Variabili d'ambiente — perché la tua API key non va nel codice
5. Cookie e sessioni — come il sito ricorda chi sei
6. CORS — l'errore più odiato spiegato in 3 paragrafi

---

## 7.1 — DNS in profondità

> *🎨 Infografica 16: DNS resolution flow.*

### Ripasso: cosa è il DNS

Lo abbiamo già toccato nel Modulo 0. Il **DNS** (Domain Name System) traduce nomi di dominio (`miosito.it`) in indirizzi IP (`188.213.170.214`). È un **elenco telefonico mondiale distribuito**.

Adesso entriamo in come funziona davvero la traduzione.

### La catena della risoluzione DNS

Quando il browser vuole `miosito.it`, **non chiede direttamente** a un server. Segue una catena.

1. **Browser cache**: l'ho cercato di recente? Sì → uso quell'IP.
2. **OS cache**: anche il sistema operativo tiene una cache.
3. **Resolver locale (ISP)**: di solito il router di casa o il DNS del provider Internet (es. Telecom).
4. **Root server**: se il resolver non lo sa, chiede ai root server del DNS mondiale. Sono 13 cluster sparsi nel mondo.
5. **TLD server**: il root dice *"per .it chiedi al server `.it`"*.
6. **Authoritative server**: il TLD `.it` dice *"per miosito.it chiedi al name server X"*.
7. Il name server X risponde con l'IP.

Tempo totale: tipicamente 20-100ms se non in cache. Se è in cache (browser, OS, o resolver), tempo zero.

### Record DNS che incontrerai

Quando configuri un dominio, scrivi **record DNS**. I 4 più importanti:

**Record A** — *punta un dominio a un IP*

```
miosito.it.    A    188.213.170.214
```

Tradotto: *"Quando qualcuno chiede `miosito.it`, manda all'IP `188.213.170.214`"*. È il record più comune.

**Record CNAME** — *punta un dominio a un altro dominio*

```
www.miosito.it.    CNAME    miosito.it.
```

Tradotto: *"`www.miosito.it` è un alias di `miosito.it`. Cerca quello"*. Comodo per non duplicare la configurazione.

**Record MX** — *dice dove vanno le email per questo dominio*

```
miosito.it.    MX    10 mail.aruba.it.
```

Senza record MX, il dominio non riceve email.

**Record TXT** — *note libere*

```
miosito.it.    TXT    "v=spf1 include:_spf.google.com ~all"
```

Usato per anti-spam (SPF, DKIM, DMARC), per verifica proprietà di servizi (Google, Cloudflare), e altri metadati.

### TTL: time to live

Ogni record DNS ha un **TTL** (Time To Live): per quanto tempo le cache possono memorizzare la risposta. Tipico: 3600 secondi (1 ora) o 86400 (24 ore).

Quando cambi un record DNS, **devi aspettare il TTL** perché il cambiamento si propaghi globalmente. Se hai messo un TTL alto (24h) e cambi il record, alcuni resolver useranno la vecchia versione per 24h.

Pratica: prima di cambiare un record DNS importante, **abbassa il TTL** a 60 secondi una settimana prima. Poi cambia. Poi rialza il TTL.

### Verificare la propagazione

Dopo aver cambiato un record, vuoi sapere se è propagato. Strumenti:

```bash
# Linux/Mac/WSL
dig miosito.it
nslookup miosito.it

# Tool web
# https://dnschecker.org → mostra il record da 30+ posti nel mondo
```

Se il tuo record è propagato globalmente, dnschecker mostra l'IP nuovo da tutti i posti.

### Cosa ti porti via

1. Il DNS è una **catena di server**: browser → OS → resolver → root → TLD → authoritative.
2. I 4 record principali: **A** (dominio→IP), **CNAME** (alias), **MX** (email), **TXT** (note libere).
3. **TTL** decide quanto le cache memorizzano. Abbassa prima di cambi importanti.
4. **dnschecker.org** ti dice se il tuo cambio è propagato globalmente.

---

## 7.2 — HTTPS e certificati SSL

### Perché HTTPS è obbligatorio

Nel 2026, **HTTPS è obbligatorio**. Non è più "consigliato": è il default. Senza HTTPS:
- Il browser mostra il warning "Sito non sicuro" → utenti scappano
- Google penalizza pesantemente nel ranking
- I cookie con flag `Secure` non funzionano (login si rompe)
- Le moderne API web (geolocalizzazione, camera, ecc.) non funzionano

Se vedi un sito senza HTTPS, è un sito **degli anni 2010**.

### Cosa è un certificato SSL/TLS

Per attivare HTTPS, il server deve avere un **certificato SSL/TLS**. Pensa al certificato come a un **passaporto digitale** firmato da un'autorità riconosciuta.

Quando il browser si connette al server, il server gli mostra il certificato. Il browser verifica:
1. Il certificato è **valido** (non scaduto, non revocato)
2. È stato emesso per **questo dominio** (non per uno diverso)
3. È firmato da un'**autorità riconosciuta** (CA, Certificate Authority)

Se tutti i check passano, il browser **fida** il server e crea una connessione cifrata. Lucchetto verde.

### Let's Encrypt: certificati gratis

Una volta i certificati SSL costavano 50-500€/anno. Oggi sono **gratis** grazie a **Let's Encrypt**, una CA non-profit che emette certificati validi 90 giorni con rinnovo automatico.

Il modo standard di usarli è con uno strumento chiamato **Certbot**:

```bash
# Su un server con nginx installato
sudo certbot --nginx -d miosito.it -d www.miosito.it
```

In 60 secondi:
1. Certbot verifica che tu controlli il dominio (con un file temporaneo)
2. Genera il certificato
3. Configura automaticamente nginx per usarlo
4. Imposta il rinnovo automatico ogni 60 giorni

Da quel momento, il sito è **HTTPS forever** (finché paghi il dominio e Certbot fa il suo lavoro).

### Quando NON devi pensare al certificato

Se usi **Vercel, Netlify, Railway, Render**, il certificato è **gestito automaticamente**. Tu non vedi nemmeno il problema. Cloudflare proxy fa lo stesso.

Quando devi pensarci: **VPS Aruba self-hosted** (devi configurare Certbot manualmente, come abbiamo fatto per `vibecodingserio.vibecanyon.com`).

### Errori comuni

**Errore 1**: "Certificato scaduto"
Sintomo: warning sul browser. Causa: Certbot non ha rinnovato. Fix: `sudo certbot renew --force-renewal`.

**Errore 2**: "Certificato per dominio diverso"
Sintomo: warning sul browser. Causa: hai un certificato per `miosito.it` ma l'utente apre `www.miosito.it`. Fix: includi tutti i sottodomini nel certificato (`certbot --nginx -d miosito.it -d www.miosito.it`).

**Errore 3**: "Mixed content"
Sintomo: pagina HTTPS ma con risorse HTTP dentro (immagini, script). Browser blocca tutto. Fix: tutte le risorse devono essere HTTPS o relative (`//cdn.miosito.it/...`).

### Cosa ti porti via

1. **HTTPS è obbligatorio** in produzione. Senza, sito morto.
2. **Let's Encrypt + Certbot** = certificati gratis, rinnovo automatico ogni 60 giorni.
3. Su Vercel/Netlify il certificato è gestito automaticamente. Su VPS lo configuri tu.
4. Errori comuni: certificato scaduto, dominio sbagliato, mixed content.

---

## 7.3 — Nginx: il buttafuori del server

### Cosa fa nginx

Su un VPS Aruba (e simili) c'è quasi sempre **nginx** in mezzo tra il browser dell'utente e la tua app.

Pensa a nginx come a un **buttafuori**: quando un utente arriva al server (porta 80 HTTP o 443 HTTPS), nginx riceve la richiesta, decide a quale app inoltrarla, e gli passa il messaggio.

Perché serve? Perché su un solo server giri **molte app diverse**:

- `cantiere.vibecanyon.com` → app Next.js sulla porta interna 3010
- `safetrack.vibecanyon.com` → app Next.js sulla porta interna 3000
- `vibecodingserio.vibecanyon.com` → file statici nella cartella `/var/www/vibecodingserio/`

Nginx fa il **routing**: in base al dominio richiesto, manda la richiesta all'app giusta.

### Il pattern del reverse proxy

Il caso più comune: hai un'app Next.js che gira sulla porta 3010. Vuoi che gli utenti la raggiungano su `cantiere.vibecanyon.com` (porta 443).

Configurazione nginx tipica:

```nginx
server {
    listen 443 ssl;
    server_name cantiere.vibecanyon.com;

    ssl_certificate /etc/letsencrypt/live/cantiere.vibecanyon.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/cantiere.vibecanyon.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3010;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}
```

Tradotto: *"Ascolta sulla porta 443 con HTTPS. Quando arriva una richiesta per `cantiere.vibecanyon.com`, inoltrala alla mia app sulla porta 3010"*.

Questo si chiama **reverse proxy** (proxy inverso) — nginx è davanti, l'app è dietro.

### Statici vs reverse proxy

Per **siti statici** (HTML/CSS/JS senza backend), nginx serve i file direttamente:

```nginx
server {
    listen 443 ssl;
    server_name vibecodingserio.vibecanyon.com;
    root /var/www/vibecodingserio;
    index index.html;
}
```

Per **app dinamiche** (Next.js, Express, Python), nginx fa reverse proxy a una porta interna.

### Errori nginx più comuni

**502 Bad Gateway**: nginx non riesce a raggiungere il backend.
Cause comuni: l'app sulla porta 3010 è morta (`pm2 status` per verificare), oppure è stata riavviata su porta diversa.

**504 Gateway Timeout**: il backend è troppo lento (>60 secondi default).
Cause: query DB lente, codice bloccante. Il problema è dell'app, non di nginx.

**413 Request Entity Too Large**: hai mandato un file troppo grande (default nginx: 1MB).
Fix: aggiungi `client_max_body_size 50M;` al config nginx.

**Configurazione non si carica**: hai cambiato il config ma il sito è uguale.
Fix: `sudo nginx -t` (valida la sintassi) e poi `sudo systemctl reload nginx`.

### Cosa ti porti via

1. **Nginx** sta davanti alle tue app, fa **routing** per dominio e **reverse proxy** alle porte interne.
2. Su Vercel/Netlify nginx è invisibile. Su VPS Aruba lo configuri tu (file in `/etc/nginx/sites-available/`).
3. **502** = backend giù. **504** = backend lento. **413** = upload troppo grande.
4. Dopo modifiche: `nginx -t` per validare, `systemctl reload nginx` per applicare.

---

## 7.4 — Variabili d'ambiente

### Cosa sono e perché esistono

Le **variabili d'ambiente** (`.env`) sono **valori configurabili** che il tuo codice legge a runtime, ma che non vivono dentro il codice stesso.

Esempi tipici:
- `DATABASE_URL` — la stringa di connessione al database
- `OPENAI_API_KEY` — la tua API key segreta
- `NEXTAUTH_SECRET` — il segreto per firmare i token di sessione
- `STRIPE_SECRET_KEY` — la chiave Stripe per processare pagamenti

**Perché non nel codice?** Tre motivi:
1. **Sicurezza**: se metti `OPENAI_API_KEY = "sk-..."` nel codice e lo committi su GitHub, **il mondo intero la vede**. Bot scansionano GitHub e rubano API key in **pochi minuti**.
2. **Differenze tra ambienti**: in locale vuoi un DB locale, in produzione un DB cloud. Stesso codice, valori diversi.
3. **Non versionata**: le variabili non vivono in git, vivono nel **server** (o nel pannello del provider).

### Anatomia di un file `.env`

Sintassi semplice:

```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/cantiere
OPENAI_API_KEY=sk-proj-abcd1234...
NEXTAUTH_SECRET=randomstring32characterslong...
STRIPE_SECRET_KEY=sk_test_abcd...
```

Una variabile per riga, formato `NOME=valore`. Niente spazi attorno all'`=`. Niente virgolette (di solito).

### `.env.local`, `.env`, `.env.example`

Tre file con tre ruoli:

**`.env.local`** — *i tuoi valori in locale*
- È nel tuo PC. Mai committato in git.
- Contiene i valori veri (`OPENAI_API_KEY=sk-...`).
- `.gitignore` lo esclude.

**`.env`** — *il default condiviso*
- Più raro oggi. A volte usato per valori non sensibili.

**`.env.example`** — *il template*
- Versionato in git.
- Contiene **i nomi** delle variabili necessarie, **senza valori veri**:
  ```env
  DATABASE_URL=postgresql://username:password@localhost:5432/your_db
  OPENAI_API_KEY=your-openai-key-here
  NEXTAUTH_SECRET=generate-random-string
  ```
- Quando un nuovo collaboratore clona il repo, fa `cp .env.example .env.local` e riempie i suoi valori.

### Variabili in produzione

In locale: leggi da `.env.local`. In produzione: dipende dal provider.

- **Vercel / Netlify**: pannello → "Environment Variables" → aggiungi le coppie nome=valore.
- **Aruba VPS**: crea il file `.env.production` o `.env.local` direttamente sul server (via SSH). Esegui `pm2 restart` per fargli ricaricare.
- **Docker**: passi le variabili al container all'avvio (`docker run -e VAR=value ...`).

### Il bug classico: variabile mancante in produzione

Storia tipica: *"Il sito funziona in locale, in produzione il login dà 500 senza spiegazioni."*

Causa probabile: hai aggiunto una variabile (`NEXTAUTH_SECRET`) in `.env.local` ma hai dimenticato di settarla nel pannello Vercel.

Diagnosi:
1. Apri i log del server (Vercel → Functions → Logs)
2. Cerca un messaggio tipo `NEXTAUTH_SECRET is not defined`
3. Aggiungi la variabile nel pannello
4. Redeploy

### Variabili `NEXT_PUBLIC_*` in Next.js

Una nota importante. In Next.js, le variabili che iniziano con `NEXT_PUBLIC_` vengono **bundlate nel JavaScript del browser**. Sono **visibili** a chiunque ispezioni la pagina.

```env
NEXT_PUBLIC_API_URL=https://api.miosito.it    # OK, è un URL pubblico
NEXT_PUBLIC_OPENAI_KEY=sk-...                 # ⚠️ DISASTRO, key esposta!
```

**Regola**: se è una **chiave segreta**, NON metterla in `NEXT_PUBLIC_*`. Tienila come variabile normale (server-only).

### Cosa ti porti via

1. **Variabili d'ambiente** = valori che il codice legge ma non sono dentro il codice.
2. Tre file: `.env.local` (tuo, mai committato), `.env.example` (template versionato), produzione gestita dal provider.
3. **Bug classico**: variabile in locale ma non in produzione. Crash silenzioso.
4. In Next.js, **`NEXT_PUBLIC_*`** è visibile al browser. Mai metterci segreti.

---

## 7.5 — Cookie e sessioni: come il sito ricorda chi sei

### Il problema fondamentale

HTTP è **stateless**: ogni richiesta è indipendente. Il server non ricorda automaticamente chi sei tra una richiesta e l'altra.

Ma allora come fa il sito a sapere che hai fatto login? Come fa a non chiederti la password ad ogni click?

Risposta: usa **cookie** (lato browser) e **sessioni** (lato server) per simulare uno stato.

### Cookie: il foglietto che il browser tiene per te

Un **cookie** è un piccolo testo che il server invia al browser. Il browser lo **salva** e lo **rispedisce automaticamente** ad ogni richiesta successiva verso lo stesso dominio.

Esempio. Server al login:

```http
HTTP/1.1 200 OK
Set-Cookie: session_id=abc123xyz; HttpOnly; Secure; SameSite=Strict; Max-Age=604800
```

Tradotto: *"Browser, salva un cookie con nome `session_id` e valore `abc123xyz`. È valido 7 giorni."*

Da quel momento, ad ogni richiesta successiva il browser aggiunge automaticamente:

```http
GET /api/profile HTTP/1.1
Cookie: session_id=abc123xyz
```

Il server vede il cookie, riconosce la sessione, sa chi sei.

### Le flag che salvano la vita

I cookie hanno **flag** importantissime:

**`HttpOnly`** — *il cookie non è leggibile da JavaScript*
- Senza HttpOnly, qualunque script malevolo (es. XSS injection) può rubare il cookie.
- **SEMPRE settare HttpOnly** sui cookie di sessione.

**`Secure`** — *il cookie viaggia solo su HTTPS*
- Senza Secure, il cookie viaggia anche su HTTP, intercettabile.
- **SEMPRE settare Secure** in produzione.

**`SameSite`** — *quando il cookie è inviato a richieste cross-site*
- `Strict`: solo richieste dallo stesso sito (più sicuro)
- `Lax`: anche da link esterni (default ragionevole)
- `None`: sempre (rischioso, richiede `Secure`)

**`Max-Age`** o **`Expires`** — *quando il cookie scade*
- Senza, il cookie sparisce alla chiusura del browser (cookie "di sessione").
- Con, dura un tempo definito (es. 7 giorni).

### Sessione lato server

Il cookie da solo non basta. Il valore `abc123xyz` deve corrispondere a **qualcosa** sul server.

Tipicamente, il server tiene una **sessione** in memoria o nel database:

```
sessions:
session_id  | user_id | expires_at
abc123xyz   | 7       | 2026-05-02 14:00:00
```

Quando il browser manda il cookie `session_id=abc123xyz`, il server cerca nella tabella, trova `user_id=7`, sa chi è l'utente.

### JWT: l'alternativa moderna

**JWT** (JSON Web Token) è una tecnica diversa: invece di tenere la sessione sul server, il server crea un token **firmato** che contiene direttamente le info utente.

```
Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo3LCJleHAiOjE3...
```

Quando il client manda il token, il server **verifica la firma** (con un segreto). Se valido, sa che è autentico e legge `user_id=7` dal token stesso. Niente lookup nel database.

**Pro**: scalabile (no DB lookup ad ogni richiesta), stateless.
**Contro**: revoca difficile (un JWT valido è valido finché scade), token più grandi.

Supabase e NextAuth usano JWT di default oggi.

### Il bug classico: login si comporta diverso in locale e produzione

Storia tipica: *"In locale il login funziona. In produzione l'utente fa login ma viene rimandato al login dopo il redirect alla dashboard."*

Cause possibili:
1. **Cookie `Secure` su HTTP**: in locale usi HTTP `localhost:3000`, ma il cookie ha flag `Secure` → il browser non lo invia. Soluzione: in dev usa `Secure: false`, in prod `Secure: true`.
2. **Dominio del cookie**: il cookie è impostato per `app.miosito.it` ma il redirect va a `miosito.it`. Browser lo blocca.
3. **`SameSite: Strict` con redirect cross-site**: usi un OAuth provider che ti rimanda al sito → cookie non inviato.

Diagnosi: apri DevTools → Application → Cookies. Vedi se i cookie ci sono, hanno le flag giuste.

### Cosa ti porti via

1. HTTP è **stateless**: cookie + sessioni servono per simulare uno stato.
2. **Flag fondamentali**: `HttpOnly` (no JS), `Secure` (solo HTTPS), `SameSite`, `Max-Age`.
3. **Sessione lato server** (DB lookup) o **JWT** (token autocontenuto firmato).
4. **Bug classico**: cookie con `Secure` non funziona in HTTP. In locale usa HTTPS o disattiva `Secure` in dev.

---

## 7.6 — CORS in 3 paragrafi (l'errore più odiato spiegato)

### Cosa è CORS

**CORS** sta per **Cross-Origin Resource Sharing**. È un meccanismo di sicurezza del browser.

Regola: un sito su `miosito.it` non può fare richieste JavaScript verso `api.altrosito.it` **a meno che il secondo non lo autorizzi esplicitamente**.

Perché esiste? Senza CORS, qualunque sito malevolo che apri potrebbe fare richieste JavaScript verso il tuo home banking, sfruttando i cookie già loggati. Catastrofe. CORS impedisce questo.

### Quando CORS NON è un problema

Se frontend e backend sono **sullo stesso dominio**, CORS non si pone:

- `miosito.it/index.html` chiama `miosito.it/api/users` → **same-origin**, nessun problema.

In **Next.js full-stack**, frontend e backend sono nello stesso progetto e quindi lo stesso dominio. Niente CORS.

### Quando CORS È un problema

Frontend e backend su **domini diversi**:

- `miosito.it` chiama `api.miosito.it` → **different-origin**, CORS attivo.
- `miosito.it` chiama `api.openai.com` → **different-origin**.
- `localhost:3000` chiama `localhost:8080` → **different-origin** (porta diversa = origin diverso!).

In questi casi, il browser fa una richiesta speciale chiamata **preflight** (`OPTIONS`) prima della richiesta vera. Chiede al server: *"autorizzi `miosito.it` a chiamarmi?"*. Se il server risponde con i giusti header, il browser fa la richiesta vera. Se no, blocca tutto.

### Configurare CORS lato server

Il server deve rispondere con questi header:

```
Access-Control-Allow-Origin: https://miosito.it
Access-Control-Allow-Methods: GET, POST, PATCH, DELETE
Access-Control-Allow-Headers: Authorization, Content-Type
Access-Control-Allow-Credentials: true
```

In Express (Node.js):

```javascript
import cors from 'cors';
app.use(cors({
  origin: 'https://miosito.it',
  credentials: true,
}));
```

In Laravel: `config/cors.php`. In Django: `django-cors-headers`. Ogni framework ha il suo modo.

### Errori CORS che vedrai

```
Access to fetch at 'https://api.miosito.it' from origin 'https://miosito.it'
has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header...
```

Quando lo vedi, **è sempre lo stesso problema**: il server non sta rispondendo con `Access-Control-Allow-Origin` corretto.

> ⚠️ **Mai usare `Access-Control-Allow-Origin: *`** in produzione con autenticazione. Significa "autorizza chiunque". Buco di sicurezza enorme. Specifica sempre i domini esatti.

### Il bug classico in produzione

Storia tipica: *"In locale tutto funziona. In produzione: errore CORS."*

Causa: in locale entrambi su `localhost`, in produzione frontend su `miosito.it` e backend su `api.miosito.it`.

Fix:
1. Identifica il backend
2. Configuralo per accettare il dominio del frontend in produzione
3. Aggiungi `https://miosito.it` (e magari `http://localhost:3000` per dev) all'allow list

> ✏️ **Prompt-ready**: *"Configura CORS sul backend Express per accettare richieste da `https://miosito.it` (produzione) e `http://localhost:3000` (dev). Includi credentials per i cookie."*

### Cosa ti porti via

1. **CORS** = il browser blocca chiamate cross-origin a meno che il server destinatario non autorizzi esplicitamente.
2. **Same-origin** (Next.js full-stack) = niente CORS. **Cross-origin** = CORS attivo.
3. Per sbloccare: il **server** deve mandare `Access-Control-Allow-Origin: <dominio frontend>`.
4. **Mai `*`** in produzione con autenticazione. Sempre dominio specifico.

---

## Chiusura del Modulo 7

Questo era il modulo tecnicamente più denso del libro. Adesso conosci a fondo i meccanismi che separano "funziona in locale" da "funziona in produzione":

- DNS — come il dominio si traduce in IP
- HTTPS — perché serve, come si configura
- Nginx — il routing davanti alle tue app
- Variabili d'ambiente — perché esistono e i loro tre file
- Cookie e sessioni — come il sito ricorda chi sei
- CORS — l'errore più odiato e come fixarlo

Quando vedrai un problema in produzione, sai dove guardare. È esattamente il **livello 2** di cui parlavamo nel Modulo 1.

Nel **Modulo 8** mettiamo tutto insieme: come usare questa conoscenza per parlare a Claude in modo che lui generi codice migliore alla prima iterazione.

---

## 🎯 Mini-quiz di autovalutazione

**1. Hai cambiato un record DNS un'ora fa. Il tuo amico vede ancora il vecchio sito. Perché?**

**2. Vero o falso: HTTPS è ancora opzionale per siti piccoli o personali.**

**3. Il tuo sito Next.js gira sulla porta 3000. L'utente arriva su `miosito.com` (porta 443 HTTPS). Cosa fa nginx?**

**4. Hai messo `OPENAI_API_KEY=sk-...` in una variabile `NEXT_PUBLIC_OPENAI_KEY` in Next.js. Cosa è successo di disastroso?**

**5. Vedi in console: `blocked by CORS policy`. Dove devi mettere mano?**

---

### Risposte

1. **Cache DNS**: il TTL del record precedente non è ancora scaduto. Il resolver del tuo amico (o del suo OS, o del browser) ha memorizzato la vecchia risposta. Si risolve da solo quando il TTL scade. Per cambi importanti, abbassa il TTL prima.

2. **Falso**. HTTPS è obbligatorio per qualsiasi sito moderno. Senza, browser warning, Google penalty, cookie `Secure` non funzionano. Let's Encrypt rende HTTPS gratis. Niente scuse.

3. **Reverse proxy**: nginx riceve la richiesta su 443 (HTTPS), la inoltra al Next.js sulla porta 3000 internamente. Aggiunge gli header (Host, X-Forwarded-For), riceve la risposta, la rimanda al browser HTTPS. L'utente non sa nemmeno che esiste la porta 3000.

4. La tua **API key Stripe/OpenAI** è ora **visibile a chiunque ispezioni il sito**. È nel JavaScript del browser. Bot la rubano in pochi minuti. Devi: (1) cambiare immediatamente la API key, (2) togliere il `NEXT_PUBLIC_`, (3) usarla solo in Server Components o API routes.

5. **Sul backend**, non sul frontend. È il backend che deve mandare l'header `Access-Control-Allow-Origin` con il dominio del frontend. Sul frontend non c'è niente da fare: è il browser che blocca, e accetta solo se il server autorizza.

---

*Modulo 7 redatto: 2026-04-25 · Versione 1.0 · ~22 pagine · ~5500 parole*
