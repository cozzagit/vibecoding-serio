# Perché il tuo login non ricorda l'utente (e cosa sono i cookie)

> **Quick Win 3 di 5** · Tempo di lettura: 11 minuti · Modulo collegato: 7
> *Capitolo standalone pubblicabile come articolo blog.*

---

## Il momento "ma come"

Hai costruito un sito con login. Funziona: l'utente inserisce email e password, viene rimandato alla dashboard. Tutto bene. Però:

- **Sintomo 1**: l'utente fa login, ma dopo qualche minuto è disconnesso. Senza ragione.
- **Sintomo 2**: l'utente fa login in produzione, viene rimandato alla dashboard, e poi **subito al login**. Loop infinito.
- **Sintomo 3**: in locale tutto perfetto. Online no.

In tutti e tre i casi, il problema è **cookie** e **sessioni**. Risolviamo.

---

## Cosa pensa il vibecoder

> *"Login = utente loggato. Punto. Non capisco perché se ne dimentica."*

Il fraintendimento è qui: pensare che "loggato" sia uno stato che il server **ricorda automaticamente**. Non è così. HTTP è **stateless**: ogni richiesta è indipendente, il server non ricorda niente da una richiesta all'altra.

Per dare l'illusione di "rimanere loggati", servono **cookie** e **sessioni**. Sono il trucco che fa funzionare il web come lo conosci.

---

## Cosa succede davvero

### Il problema fondamentale: HTTP è smemorato

Tu fai login. Il server ti riconosce. Ottimo. **Ma alla richiesta successiva**, il server non ha la minima idea di chi sei. Le richieste HTTP sono indipendenti.

Per simulare uno stato, si usa un **cookie**: un piccolo testo che il server invia al browser. Il browser lo salva e lo **rispedisce automaticamente** ad ogni richiesta successiva verso lo stesso dominio.

```
1. Login: server → browser
   Set-Cookie: session_id=abc123xyz; HttpOnly; Secure

2. Richiesta successiva: browser → server (automatico)
   Cookie: session_id=abc123xyz

3. Server riconosce abc123xyz → "ah, è Marco"
```

### Le 4 flag che cambiano tutto

I cookie hanno **flag** importantissime. Ognuna ha un perché.

**`HttpOnly`** — il cookie non è leggibile da JavaScript

Senza HttpOnly, qualunque script malevolo nella pagina (es. da una libreria compromessa) può leggere il cookie e rubare la sessione. **Sempre HttpOnly** per i cookie di sessione.

**`Secure`** — il cookie viaggia solo su HTTPS

Senza Secure, il cookie passa in chiaro su HTTP, intercettabile. **Sempre Secure** in produzione (HTTPS).

**`SameSite`** — quando il cookie è inviato cross-site

- `Strict`: solo per richieste dallo stesso sito (più sicuro, ma ti rompe gli OAuth)
- `Lax`: anche da link esterni, default ragionevole
- `None`: sempre, richiede `Secure` (rischioso, solo se sai cosa fai)

**`Max-Age`** o **`Expires`** — quando il cookie scade

Senza, il cookie sparisce alla chiusura del browser. Con, dura un tempo definito (es. 7 giorni → `Max-Age=604800`).

### I 3 sintomi spiegati

**Sintomo 1: utente sloggato dopo qualche minuto**

Il cookie ha **scadenza breve** (default di NextAuth: 1 ora) e non c'è refresh automatico. L'utente "scade" senza accorgersene.

Fix: configura `maxAge: 30 * 24 * 60 * 60` (30 giorni) e abilita refresh token.

**Sintomo 2: login loop in produzione**

In produzione il dominio è HTTPS. Il cookie dovrebbe avere flag `Secure: true`. Ma se la config dice `Secure: false` (per dev) e non distingui ambiente, il cookie viene impostato come HTTP-only. Browser non lo rinvia su HTTPS → server non ti riconosce → redirect al login.

Fix: in NextAuth/Express, `useSecureCookies: process.env.NODE_ENV === 'production'`.

**Sintomo 3: in locale sì, in produzione no**

Causa più frequente: il **dominio del cookie** è sbagliato. Il cookie è impostato per `app.miosito.it` ma il redirect manda a `miosito.it`. Domini diversi = cookie non inviato.

Fix: configura `cookie.domain = 'miosito.it'` (con il punto davanti `.miosito.it` se vuoi che valga su tutti i sottodomini).

### Sessione lato server vs JWT

Il valore del cookie (`abc123xyz`) deve corrispondere a **qualcosa** lato server. Due tecniche:

**Sessione classica**: il server tiene una tabella `sessions` con `session_id`, `user_id`, `expires_at`. Ad ogni richiesta, lookup nella tabella. Più richieste DB, più scalabile su sistemi piccoli.

**JWT (JSON Web Token)**: il "session_id" è un token **firmato** che contiene direttamente le info utente. Il server verifica la firma (con un segreto in env) e legge `user_id` direttamente dal token. Stateless, scalabile, ma revoca difficile.

NextAuth, Supabase Auth, Clerk usano **JWT di default** oggi. Tu come vibecoder devi sapere che:

- Il token JWT vive nel cookie (httpOnly, Secure)
- Ha una scadenza incorporata (es. 30 giorni)
- È firmato con un segreto chiamato spesso `NEXTAUTH_SECRET` o `JWT_SECRET`
- Se cambi il segreto, **tutti gli utenti vengono sloggati**

### Diagnosi in 30 secondi

Apri DevTools → **Application** tab → **Cookies** → seleziona il tuo dominio.

Vedi:
- I cookie esistono?
- Hanno le flag giuste? (HttpOnly ✓, Secure ✓ in produzione)
- Il dominio è corretto?
- La scadenza è ragionevole?

Quasi tutti i bug login si vedono qui.

---

## Come parlarne a Claude per ottenerlo bene

### Prompt da NON usare

> *"il login non funziona dopo un giorno"*

Troppo vago. Claude propone 8 cause possibili.

### Prompt da usare

> *"Sto usando NextAuth v5 con provider Credentials su Next.js 14, deployato su Vercel con dominio custom HTTPS `miosito.com`.
>
> Sintomo: l'utente fa login (vedo `200 OK` su `/api/auth/callback/credentials`), redirect a `/dashboard`, ma `/dashboard` lo rimanda subito a `/login`. Loop infinito.
>
> In `localhost:3000` funziona perfettamente.
>
> Sospetto problema di cookie httpOnly + Secure + dominio. Come configuro NextAuth `cookies` options per il dominio production HTTPS, mantenendo localhost funzionante?"*

Differenza: il primo prompt produce 8 ipotesi e iterazioni. Il secondo va dritto al punto e Claude ti dà la config esatta in una iterazione.

---

## La regola che ti porti a casa

> Un cookie senza `HttpOnly` è un buco di sicurezza. Un cookie senza `Secure` è un altro buco di sicurezza. Un cookie con `Secure` su HTTP è invisibile. Un cookie con dominio sbagliato è invisibile.

Quando il login non ricorda, è quasi sempre **una di queste 4 cose** sbagliate. Vai in DevTools → Application → Cookies, le verifichi in 30 secondi.

---

> Quick Win 3 di 5. I prossimi 2: backup database · CORS spiegato.
> **Vibecoding Serio** — il libro completo a giugno 2026.

*Capitolo redatto: 2026-04-25 · Versione 1.0*
