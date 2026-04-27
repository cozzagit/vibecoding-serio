# Appendice A — Cheat Sheet del Debug

> 4 pagine · Riferimento rapido stampabile
> Per ogni errore frequente: **cosa significa · dove guardare · cosa dire a Claude**.

---

## Errori di rete / API

### `Failed to fetch` / `NetworkError`
**Cosa significa**: il browser non riesce a raggiungere il server.
**Dove guardare**: Network tab → richiesta fallita → status `(failed)`.
**Cause tipiche**: server giù, rete locale assente, CORS bloccante.
**A Claude**: *"Errore Failed to fetch su POST /api/X dal frontend Next.js a backend Express. Server raggiungibile via curl. Sospetto CORS."*

### `CORS policy: No 'Access-Control-Allow-Origin'`
**Cosa significa**: il backend non autorizza il dominio del frontend.
**Dove guardare**: Network tab → richiesta in rosso → tab Headers → manca `Access-Control-Allow-Origin` in Response.
**Fix**: configurare CORS sul backend con il dominio del frontend.
**A Claude**: *"Errore CORS in produzione tra `app.miosito.it` e `api.miosito.it`. Configura cors middleware Express per accettare entrambi gli origin con credentials true."*

### `401 Unauthorized`
**Cosa significa**: non sei autenticato (manca token / sessione / cookie).
**Dove guardare**: Network → richiesta 401 → tab Headers → c'è `Authorization` o `Cookie`?
**Cause tipiche**: token scaduto, cookie non inviato, NEXTAUTH_SECRET mancante in produzione.

### `403 Forbidden`
**Cosa significa**: sei autenticato ma non hai permessi per questa operazione.
**Dove guardare**: log del server → cerca controlli di autorizzazione.

### `404 Not Found`
**Cosa significa**: la rotta non esiste sul server.
**Dove guardare**: hai sbagliato URL? Il file di route esiste? In Next.js: `app/api/X/route.ts`?

### `500 Internal Server Error`
**Cosa significa**: bug nel codice del server, eccezione non gestita.
**Dove guardare**: **log del server** (Vercel Functions Logs, PM2 logs). NON in console browser.
**A Claude**: *"500 su /api/X. Log server: `[errore copiato]`. Codice attuale: `[snippet]`."*

### `502 Bad Gateway`
**Cosa significa**: nginx non riesce a parlare col backend.
**Dove guardare**: il backend gira? `pm2 status`, `systemctl status myapp`.

### `429 Too Many Requests`
**Cosa significa**: rate limit superato.
**Fix**: backoff esponenziale, caching, code di richieste.

---

## Errori JavaScript browser

### `Cannot read property 'X' of undefined`
**Cosa significa**: stai accedendo a una proprietà di un oggetto che non esiste.
**Causa tipica**: dati non ancora caricati, optional chaining mancante.
**Fix**: usa `?.` (optional chaining) o controlla `if (data)` prima di accedere.

### `X is not a function`
**Cosa significa**: stai chiamando come funzione qualcosa che non lo è.
**Cause**: import sbagliato (default vs named), variabile reassegnata.

### `Hydration failed because...` (Next.js / React)
**Cosa significa**: il server ha renderizzato HTML diverso da quello che il client si aspetta.
**Cause tipiche**: usare `Date.now()`, `Math.random()`, `localStorage` in Server Components.
**Fix**: spostare in Client Component (`'use client'`) o usare `useEffect`.

### `useState is not defined / can only be used in Client Components`
**Cosa significa**: stai usando hook React in un Server Component.
**Fix**: aggiungi `'use client'` in cima al file.

---

## Errori database

### `column "X" does not exist`
**Cosa significa**: il codice cerca una colonna che il DB non ha.
**Causa tipica**: migration applicata in locale ma non in produzione.
**Fix**: applica le migration in produzione (`drizzle-kit push`, `prisma migrate deploy`).

### `relation "X" does not exist`
**Cosa significa**: la tabella non esiste.
**Fix**: applica le migration di creazione iniziale.

### `connection refused` (DB)
**Cosa significa**: non riesce a connettersi al DB.
**Cause**: DATABASE_URL sbagliata, DB giù, firewall che blocca.

### `duplicate key violates unique constraint`
**Cosa significa**: stai inserendo un valore già presente in una colonna unique.
**Fix**: gestisci il caso (es. mostrare "Email già registrata").

---

## Errori build / deploy

### `Module not found: Can't resolve 'X'`
**Cosa significa**: import a un pacchetto non installato.
**Fix**: `pnpm install X`.

### `Type error: Property X does not exist`
**Cosa significa**: errore TypeScript.
**Fix**: aggiusta i tipi, oppure aggiungi i missing field.

### `EADDRINUSE: address already in use :::3000`
**Cosa significa**: la porta 3000 è già occupata da un altro processo.
**Fix**: `lsof -i:3000` per trovarlo, killalo. Oppure usa porta diversa.

### `Build failed` (Vercel/Netlify)
**Dove guardare**: log del provider → errore di build.
**Cause comuni**: variabile env mancante in produzione, type error, dipendenza non installata.

---

## Errori cookie / sessione

### "Login funziona ma l'utente è sloggato dopo 1 ora"
**Causa**: sessione JWT con scadenza default 1h.
**Fix**: configura `maxAge: 30 * 24 * 60 * 60` in NextAuth.

### "Login loop in produzione"
**Causa probabile**: cookie `Secure` non rinviato perché HTTP da qualche parte, oppure dominio cookie sbagliato.
**Dove guardare**: DevTools → Application → Cookies. Verifica flag.

### "In locale funziona, in produzione no" (login)
**Cause possibili**: HTTPS vs HTTP, dominio cookie sbagliato, `Secure: true` non differenziato per ambiente.

---

## Pattern di prompt per ogni famiglia di errore

Per **errori HTTP/API**: *"Stack [framework]. POST/GET a [URL]. Status [codice]. Log server: [paste]. In locale: [funziona/non funziona]. Già provato: [...]."*

Per **errori JavaScript browser**: *"In componente [nome], errore [paste console]. Codice rilevante: [snippet]. Stack: Next.js 14 / React 19."*

Per **errori database**: *"Errore: [paste]. Stack: Drizzle + Postgres su Supabase. Migration applicate: [sì/no]. Schema attuale: [snippet]."*

Per **build/deploy fallito**: *"Build fallita su Vercel. Log: [paste]. Funziona in locale con `pnpm build`. Vars env settate."*

---

*Appendice A redatta: 2026-04-25 · Versione 1.0*
