# Appendice B — Checklist Pre-Deploy in 15 punti

> 2 pagine · Da spuntare prima di andare live con un sito serio
> Stampabile come check-list cartacea

---

## Sicurezza & autenticazione

- [ ] **1. Variabili d'ambiente settate in produzione**
  Tutte le variabili in `.env.example` esistono nel pannello del provider (Vercel, Railway, Aruba). Specialmente: API keys, secret tokens, DATABASE_URL.

- [ ] **2. Secret tokens generati con valori forti**
  `NEXTAUTH_SECRET`, `JWT_SECRET`, ecc. devono essere stringhe casuali di 32+ caratteri. Mai valori default tipo "secret" o "changeme".

- [ ] **3. HTTPS attivo, certificato valido**
  Verifica `https://miosito.it` mostra il lucchetto verde. Su VPS: certbot ha generato il certificato. Il certificato non scade nei prossimi 30 giorni.

- [ ] **4. CORS configurato con domini specifici (no `*`)**
  Sul backend, `Access-Control-Allow-Origin` accetta solo i domini frontend reali. Mai `*` con autenticazione.

- [ ] **5. Cookie con flag corrette**
  Sessione/auth: `HttpOnly: true`, `Secure: true` in produzione, `SameSite: Lax` o `Strict`. Verifica in DevTools → Application → Cookies.

## Database & dati

- [ ] **6. Migration applicate in produzione**
  Lo schema del DB di produzione è allineato col codice. Niente "column does not exist".

- [ ] **7. Backup automatici attivi e testati**
  Almeno 1 backup giornaliero con retention ≥ 7 giorni. Hai fatto **almeno un test di restore** in un ambiente di test.

- [ ] **8. Dati di test rimossi dalla produzione**
  Nessun "Lorem ipsum", nessun utente "test@test.it" admin con password "password".

## Performance & UX

- [ ] **9. Errori console puliti**
  Apri il sito in produzione. F12 → Console. **Zero errori rossi**. Eventuali warning gialli valutati.

- [ ] **10. Lighthouse score accettabile**
  `npx lighthouse https://miosito.it --view` o devtools → Lighthouse. Target: Performance ≥ 70, Accessibility ≥ 90, Best Practices ≥ 90.

- [ ] **11. Loading e error states gestiti**
  Per ogni fetch importante: hai un loading state (skeleton/spinner) e un error state (messaggio + retry). Niente schermi bianchi.

- [ ] **12. Mobile responsive verificato su device reale**
  Apri il sito su iPhone reale, non solo Chrome DevTools. Tap target ≥ 48px. Niente zoom orizzontale.

## SEO & analytics

- [ ] **13. `robots.txt` e `sitemap.xml` presenti e corretti**
  `https://miosito.it/robots.txt` esiste e non blocca tutto per errore. Sitemap aggiornata. Per Next.js: `app/robots.ts` e `app/sitemap.ts`.

- [ ] **14. Meta tag base presenti**
  Title, description, OG tags (per condivisioni social), favicon. Verifica con `view-source:` o estensione browser.

- [ ] **15. Monitoring degli errori attivo**
  Sentry, Logflare, o simili: gli errori in produzione ti arrivano via email/Slack. Senza, non sai mai quando si rompe.

---

## ⚠️ Bonus: stop-the-press

Prima del primo deploy con utenti veri:

- [ ] **Hai una pagina contatto / supporto** funzionante?
- [ ] **Hai una privacy policy** anche minima (vedi Appendice D)?
- [ ] **Hai un cookie banner** se usi cookie (analytics, marketing)?
- [ ] **Hai testato il flusso principale** (registrazione, login, acquisto, ecc.) end-to-end con un utente diverso da te?
- [ ] **Hai un piano di rollback** se il deploy va male? (Vercel ha rollback con un click; su VPS: `git revert` + redeploy)

---

*Appendice B redatta: 2026-04-25 · Versione 1.0*
