# Appendice C — I 10 Prompt da Salvare

> 3 pagine · Prompt copiabili Claude-ready
> Adatta i placeholder `[in parentesi]` al tuo contesto.

---

## 1. Setup nuovo progetto Next.js full-stack

```
Inizializza un nuovo progetto Next.js 14 con:
- TypeScript
- Tailwind CSS v4
- App Router (non Pages)
- Drizzle ORM + Postgres su [Supabase / Neon]
- NextAuth v5 con provider Credentials
- ESLint + Prettier configurati

Setup in `cd [nome-progetto]`. Includi un file `.env.example` con tutte le variabili necessarie. Crea uno schema base con tabella `users` (id, email, password_hash, created_at) e una migration iniziale.
```

---

## 2. Aggiungere autenticazione email/password

```
Aggiungi autenticazione email + password al progetto Next.js esistente.

- Form di login `/login` e registrazione `/register` come Client Components
- Validation Zod (email valida, password min 12 char)
- Endpoint API `/api/auth/register` e `/api/auth/login`
- Password hashing con bcrypt cost 12
- Sessione via NextAuth v5 JWT, cookie httpOnly + Secure
- Middleware che protegge `/dashboard/*`
- Errori inline sotto i campi, toast per success/error globale

Stack: [versione Next.js], NextAuth v5, Drizzle ORM, Postgres.
```

---

## 3. Debug API che ritorna 401 in produzione

```
Stack: [framework e versione]. Deployato su [Vercel/Aruba/altro].

Sintomo: POST a `/api/[endpoint]` ritorna 401 in produzione (`https://miosito.it`). In locale (`localhost:3000`) funziona.

Browser console: [paste errore]
Network tab: [paste request/response headers se rilevanti]
Server log: [paste]

Sospetto: [tua ipotesi: variabile env mancante, cookie non inviato, ecc.]

Già verificato:
- Variabile env settata in pannello provider [sì/no]
- Cookie presente in DevTools → Application [sì/no]
- API key valida (test con curl) [sì/no]

Aiutami a localizzare la causa e fornire un fix specifico.
```

---

## 4. Configurare CORS correttamente

```
Backend: [Express / Next.js API routes / Laravel / Django] su [URL backend].
Frontend: [Next.js / Vite] su [URL frontend].

Configura CORS sul backend per:
- Accettare richieste da `[URL frontend produzione]` e `http://localhost:3000` (dev)
- Permettere metodi GET, POST, PATCH, DELETE
- Permettere header Content-Type, Authorization
- credentials: true per i cookie httpOnly

Dammi il codice completo da aggiungere e dove va inserito.
```

---

## 5. Aggiungere upload di file

```
Aggiungi upload di immagini al progetto.

- Frontend: input `<input type="file" accept="image/*">` con preview
- Validazione client: max 5MB, solo image/*
- Storage: [Supabase Storage / Cloudflare R2 / AWS S3]
- Endpoint API che riceve il file, lo carica sul storage, ritorna URL pubblico
- Salvare URL nella tabella [nome] colonna [colonna]
- Gestione errori: file troppo grande (413), tipo sbagliato (415), upload fallito (500)
- Loading state durante upload con progress bar

Stack: Next.js 14 + [storage scelto].
```

---

## 6. Query filtrata e paginata

```
Crea endpoint API GET `/api/[risorsa]` che ritorna lista filtrata e paginata.

Filtri (query params):
- `?search=` (ricerca su [colonne])
- `?status=` (uno tra [valori])
- `?from=` `?to=` (range data)

Paginazione:
- `?page=1` `?limit=20` (default)
- Risposta: `{ data: [...], total: number, page: number, totalPages: number }`

Performance:
- Indici su colonne filtrate
- Limit max 100 (no abuse)
- Count query separata per `total`

Stack: Drizzle ORM + Postgres.
```

---

## 7. Migration database con dati esistenti

```
Voglio modificare la tabella `[nome]` aggiungendo:
- Colonna `[nome_colonna]` di tipo `[tipo]`, nullable: [sì/no]
- Default value: `[valore]`
- Eventuale index

Considera che ci sono già [N] righe in produzione.

Crea:
1. La migration Drizzle/Prisma con `ALTER TABLE`
2. Eventuale script di backfill per popolare la nuova colonna sui dati esistenti
3. Comando per applicare in produzione safely

Mostrami anche come fare rollback se qualcosa va storto.
```

---

## 8. Test end-to-end del flusso login

```
Aggiungi test E2E con [Playwright / Cypress] per il flusso di login completo.

Test casi:
- Login con credenziali corrette → redirect a /dashboard, vedo "Benvenuto [nome]"
- Login con email sbagliata → errore inline "Email non riconosciuta"
- Login con password sbagliata → errore "Password errata"
- Form vuoto submitato → errori sui campi
- Persistenza sessione: chiudo browser e riapro, sono ancora loggato
- Logout: redirect a / e session cookie cancellato

Setup: usare un user di test seedato in DB di test, cleanup dopo ogni test.
```

---

## 9. Documentazione automatica per API

```
Genera documentazione OpenAPI per tutte le route in `app/api/*/route.ts`.

Per ogni endpoint:
- Path, method, description
- Request body schema (Zod)
- Response schema (success + errori 400, 401, 422, 500)
- Esempio request/response

Output: file `openapi.yaml` + endpoint `/api/docs` che serve Swagger UI per browse interattivo.

Stack: Next.js 14, Zod schema già definiti.
```

---

## 10. Performance audit e ottimizzazione

```
Il sito `[URL]` è lento. Lighthouse score: Performance [X]/100.

Fai un audit performance e proponi fix concreti:

1. Analizza `next build --turbo` output: bundle size, route che pesano di più
2. Identifica componenti pesanti che dovrebbero essere lazy-loaded
3. Verifica immagini: sono ottimizzate? Usano `next/image`?
4. Server Components vs Client: ci sono Client unnecessary?
5. Database: query N+1 nascoste? Indici mancanti?
6. CDN: file statici sono cachati correttamente?

Ordina i fix per impatto/effort. Mostra il prima/dopo Lighthouse atteso.
```

---

## ✏️ Pattern generale del prompt informato

Per qualsiasi richiesta, usa questo template a 7 punti:

```
1. STACK: [framework, versione, librerie principali]
2. CONTESTO: [cosa esiste già nel progetto, file rilevanti]
3. OBIETTIVO: [cosa voglio in linguaggio funzionale]
4. LAYOUT: [lessico UI preciso — vedi Glossario 2]
5. COMPORTAMENTO: [stati, edge case, validazioni]
6. SICUREZZA: [auth, autorizzazioni, segreti]
7. NON FARE: [vincoli espliciti — niente OAuth, no Bootstrap, ecc.]
```

90 secondi di prompt vs 30 minuti di iterazioni. Vale la pena.

---

*Appendice C redatta: 2026-04-25 · Versione 1.0*
