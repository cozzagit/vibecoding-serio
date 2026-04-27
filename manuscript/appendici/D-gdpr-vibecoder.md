# Appendice D — GDPR per Vibecoder Italiani

> 2 pagine · Le cose pratiche da fare PRIMA di andare online con un sito che raccoglie dati
> ⚠️ Non è consulenza legale. È checklist operativa per progetti piccoli. Per progetti grossi, consulta un avvocato.

---

## Cosa è GDPR (in 30 secondi)

**GDPR** (General Data Protection Regulation) è il regolamento europeo sulla privacy in vigore dal 2018. Vale per **chiunque tratta dati personali di cittadini UE**, inclusi vibecoder italiani con app web, anche piccole.

Non è un'opzione. Le multe partono da 20.000€ per piccole violazioni e arrivano a milioni di euro per quelle gravi.

Buona notizia: per piccoli SaaS / siti / app indie, **rispettarlo costa zero** — basta fare le cose giuste fin dall'inizio.

---

## Le 5 cose da fare assolutamente

### 1. Privacy Policy

Una pagina sul tuo sito che dichiara:
- **Chi tratta i dati** (tu, nome cognome, email contatto)
- **Quali dati raccogli** (es. email, nome, IP, dati pagamento)
- **Perché** (es. "per gestire l'account utente", "per inviare la newsletter")
- **Per quanto tempo** li tieni (es. "fino alla cancellazione dell'account")
- **Con chi li condividi** (es. "Stripe per i pagamenti, Postmark per email")
- **I diritti dell'utente** (accesso, rettifica, cancellazione, portabilità)
- **Come contattarti** per esercitare i diritti

Generatore gratis online: [iubenda.com](https://www.iubenda.com) (free per progetti semplici), oppure [termly.io](https://termly.io). Costa zero.

### 2. Cookie Banner (se usi cookie non strettamente necessari)

Se usi:
- **Google Analytics** o equivalente
- **Cookie di marketing** (Facebook Pixel, ads)
- **Profilazione** utenti

→ devi mostrare un **banner cookie** che chiede consenso **prima** di settare i cookie.

**Cookie necessari** (di sessione, login) **non richiedono consenso**. Ma devi comunque dichiararli.

Strumenti gratis: [Cookiebot free](https://cookiebot.com), [Iubenda free](https://iubenda.com). 30 minuti di setup.

### 3. Dove vivono i dati

Importante per GDPR: i dati personali devono stare in **server EU** quando possibile. Se li metti su server US, devi avere base legale (es. Standard Contractual Clauses) e dichiararlo nella privacy.

**Servizi EU-friendly**:
- **Supabase**: scegli regione EU (Frankfurt, Dublin) durante la creazione del progetto. Importante.
- **Neon**: regione EU (Frankfurt) disponibile.
- **Aruba**: server in Italia, perfetto.
- **Vercel**: il piano free serve via CDN globale ma il database può essere EU.

**Servizi che richiedono attenzione**:
- **Firebase** (US): tecnicamente conforme ma richiede dichiarazioni extra.
- **Auth0** (US): idem.
- **Stripe**: ha entità EU, ok.
- **OpenAI** (US): nel disclaimer dichiara che i dati possono essere processati negli USA.

### 4. Email transazionali e marketing

Se mandi email all'utente:

**Email transazionali** (conferma registrazione, password reset, fattura): non richiedono consenso. Sono "necessarie".

**Email marketing** (newsletter, promo): richiedono **opt-in esplicito**. Niente "iscritto di default". Sempre **link di unsubscribe** funzionante in ogni email.

Strumenti email-marketing GDPR-friendly: **Resend, Postmark, Brevo (ex Sendinblue)**.

### 5. Diritto all'oblio (delete account)

L'utente deve poter **cancellare il proprio account** con i suoi dati. Implementa:

- Pulsante "Elimina account" nel profilo
- Conferma con password (per sicurezza)
- Cancellazione immediata o entro 30 giorni di tutti i dati personali (con eccezioni per obblighi fiscali — es. fatture devono essere tenute 10 anni)
- Email di conferma cancellazione

Implementare ora costa 1 ora. Implementare dopo (perché un utente lo richiede legalmente) costa una settimana di panico.

---

## Casi specifici per il vibecoder italiano

### Sito vetrina senza login

Se hai solo un sito vetrina (no account, no form, no analytics aggressive):

- Privacy policy obbligatoria (anche se semplice)
- Cookie banner non obbligatorio se non usi cookie non-essenziali
- Server EU consigliato

10 minuti di lavoro.

### SaaS con utenti EU

Se hai utenti che pagano:

- Privacy policy completa
- Cookie banner se usi analytics
- Dati su server EU (preferito)
- Diritto all'oblio implementato
- Backup conservati con retention dichiarata

1 ora di lavoro.

### App con AI che processa contenuti utenti

Se la tua app manda contenuti utente a OpenAI/Anthropic:

- **Dichiara** che i dati passano per server US (questi provider)
- Se possibile, anonimizza i dati prima di inviare
- Per dati molto sensibili, valuta provider EU (Mistral) o on-premise

---

## Checklist finale

Prima del primo utente reale:

- [ ] Privacy Policy generata e linkata in footer
- [ ] Cookie Banner attivo (se applicabile)
- [ ] Server in regione EU configurati
- [ ] Email transazionali con unsubscribe
- [ ] "Elimina account" funzionante
- [ ] Hai dichiarato chi processa cosa nella privacy

Tutto fatto in **mezza giornata**. Vita più tranquilla per anni.

---

## Link utili

- [Garante Privacy italiano](https://www.garanteprivacy.it) — testo della legge
- [iubenda.com](https://iubenda.com) — generatore privacy/cookie
- [GDPR Made Easy (in italiano)](https://www.gdpr.eu/it/) — guida pratica

---

> **Disclaimer**: questa appendice è una guida operativa per piccoli progetti. Non sostituisce la consulenza di un avvocato. Per progetti con dati sensibili (sanitari, finanziari, minori), parla con un esperto. Costano 100€/ora ma ti risparmiano problemi da 100.000€.

---

*Appendice D redatta: 2026-04-25 · Versione 1.0*
