# Il tuo database ha perso i dati. Perché e come non succede più

> **Quick Win 4 di 5** · Tempo di lettura: 10 minuti · Modulo collegato: 6
> *Capitolo standalone pubblicabile come articolo blog.*

---

## Il momento "no, no, no, no"

Sei un freelancer. Hai costruito un'app per un cliente. Funziona, è online da 4 mesi, ha 200 utenti reali con i loro dati. Una mattina apri il pannello admin per fare manutenzione e:

- I dati sono **vuoti**
- Oppure: corrotti
- Oppure: il database non parte più
- Oppure: hai cancellato la tabella sbagliata col tuo script di pulizia

Il telefono squilla. È il cliente. Non sai cosa rispondergli.

Questo capitolo ti racconta i 4 modi in cui un database "perde i dati", e — soprattutto — come non finire mai in questa situazione.

---

## Cosa pensa il vibecoder

> *"Il database è il database, sta lì, ricorda i dati. Cosa vuoi che gli succeda?"*

Tante cose. La maggior parte non sono attacchi hacker. Sono **errori normali** che succedono. La differenza tra freelancer professionista e freelancer disastrato è **l'avere un piano** quando succede.

---

## Cosa succede davvero: i 4 modi di perdere dati

### 1. Cancellazione accidentale

Caso più comune. Esempi reali:

- Esegui una query `DELETE FROM users WHERE active = false` ma scrivi `DELETE FROM users` per errore
- Lanci uno script di "pulizia" che cancella troppo
- L'utente clicca su "Elimina account" senza conferma e perdi i suoi dati legati
- Modifichi una migration di Drizzle/Prisma e rinomini una colonna → i dati vecchi vanno persi

Il bug è semplice: **un comando di troppo, una WHERE dimenticata**, e secondi dopo migliaia di righe sono sparite.

### 2. Schema disallineato (migration sbagliata)

Caso classico:
1. Aggiungi una colonna in locale a mano (Supabase Studio, pgAdmin)
2. Modifichi il codice per usarla
3. Deployi in produzione
4. Crash → `ERROR: column "phone_number" does not exist`

In sé non hai "perso dati" — ma la app è ferma. Per molti clienti è equivalente.

Variante peggiore: tu **sì** hai applicato una migration in produzione, ma scritta male, e ha **rinominato** una colonna esistente perdendo il legame con i dati.

### 3. Backup mai testati = backup non esistenti

Vai sereno perché *"Supabase fa il backup automatico"*. Un giorno il database si corrompe, vai a ripristinare, e scopri che:

- Il backup è corrotto anche lui
- Il backup non include una tabella critica
- Il piano free conserva backup solo per 7 giorni
- Il backup è in un formato che non sai restorare

Hai imparato sulla pelle viva che **backup non testato = backup inesistente**.

### 4. Hosting che muore o cambia regole

Storia vera: provider di database "free tier" che decide di chiudere il servizio in 30 giorni. O alza i prezzi del 1000%. O ti blocca per "violation of terms" senza spiegazione, e il tuo DB è loro ostaggio.

Probabilità bassa? No. Negli ultimi 5 anni questo è successo a Heroku Postgres free, Planetscale free, AWS Free Tier varie volte, Firebase free reset. **Sempre**.

---

## Come non succede più: 4 strategie

### Strategia 1 — Backup automatici (sempre)

Per ognuno dei tre casi più comuni:

**Caso A: Supabase**

- Free tier: backup automatico **giornaliero**, conservato 7 giorni. **Insufficiente** per produzione vera.
- Pro tier ($25/mese): backup giornalieri 30 giorni + Point-in-Time Recovery.

**Regola**: appena il sito ha clienti veri, **passa a Pro**. 25$ vale come assicurazione.

**Caso B: Postgres su VPS Aruba (o altro VPS self-hosted)**

I backup li configuri tu. Setup completo:

```bash
# /usr/local/bin/backup-db.sh
#!/bin/bash
DATE=$(date +%Y-%m-%d)
BACKUP_DIR=/backups
DB=cantiere

mkdir -p $BACKUP_DIR
pg_dump $DB | gzip > $BACKUP_DIR/$DB-$DATE.sql.gz

# Tieni solo gli ultimi 30 giorni
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete

# Copia su storage esterno (es. Backblaze B2 a 6$/TB/mese)
rclone copy $BACKUP_DIR b2:miei-backup/cantiere/ --include "$DB-$DATE.sql.gz"
```

Aggiungi al crontab per girare ogni notte alle 3:

```cron
0 3 * * * /usr/local/bin/backup-db.sh
```

5 minuti di setup. 6$/mese di storage esterno. Vita salvata.

**Caso C: SQLite**

Database file. Per backup, **copialo**:

```bash
sqlite3 app.db ".backup /backups/app-$(date +%Y-%m-%d).db"
```

Cron giornaliero. Banale.

### Strategia 2 — Testa i backup (mensile)

Una volta al mese, **restora un backup in un ambiente di test**. Verifica che funziona.

Senza questo passo, non hai backup. Hai una **speranza**.

```bash
# Esempio Postgres
gunzip < cantiere-2026-04-25.sql.gz | psql cantiere_test
# Verifica: numero righe nelle tabelle critiche, query di esempio
```

15 minuti al mese. Ti salva la carriera.

### Strategia 3 — Migration disciplinate

**Mai modificare lo schema in produzione a mano.** Mai. Usa sempre migration versionate.

Con Drizzle:

```bash
# Genera migration dalla diff schema
pnpm drizzle-kit generate

# Applica in produzione
pnpm drizzle-kit migrate
```

Il file di migration è in git, versionato, riproducibile. Se qualcosa va storto, sai esattamente cosa è cambiato.

Per **modifiche distruttive** (rinomina colonna, drop tabella): **mai direttamente**. Usa il pattern in 3 step:

1. **Aggiungi** la nuova colonna senza toccare la vecchia
2. **Migra i dati** dal vecchio al nuovo (script)
3. **Rimuovi** la vecchia colonna (in una migration successiva, dopo aver verificato)

Lento? Sì. Reversibile in qualunque momento? Sì. Vita salvata? Sì.

### Strategia 4 — Esci sempre dalla dipendenza vendor

Non legarti a un singolo provider in modo che, se chiude o cambia regole, sei morto. Strategia minima:

- **Backup esterni**: anche se usi Supabase, fai dump settimanali su Backblaze o S3 personale
- **Postgres standard**: scegli database "portabili" (Postgres standard) invece di vendor-specifici (es. Firebase Firestore non si esporta facilmente)
- **Schema documentato**: il file delle migration in git è il tuo schema, riproducibile ovunque

In caso di emergenza con il provider, in 2 ore hai un nuovo Postgres altrove con i dati restorati.

---

## Come parlarne a Claude per ottenerlo bene

### Prompt da NON usare

> *"Fai backup del database."*

### Prompt da usare

> *"Sto deployando un'app Next.js + Postgres su VPS Aruba. Il DB si chiama `cantiere`, user `postgres`. Configura uno script di backup con queste caratteristiche:
>
> 1. Backup giornaliero alle 3am via cron
> 2. `pg_dump` con compressione gzip
> 3. Salva in `/var/backups/cantiere/`
> 4. Conserva 30 giorni, elimina i più vecchi
> 5. Copia ogni backup anche su Backblaze B2 (rclone configurato come `b2:`)
> 6. Notifica via email su `luca@miosito.it` se il backup fallisce
>
> Dammi anche uno script di test restore che prende l'ultimo backup e lo restora in un DB di test `cantiere_test`."*

Risultato: setup completo in 1 iterazione. Production-ready.

---

## La regola che ti porti a casa

> **Un backup non testato è una speranza, non un piano.**

E:

> **Lo schema in produzione si modifica solo via migration versionate. Mai a mano.**

Se rispetti queste due regole, il 99% dei disastri di "ho perso i dati" non ti succedono. Mai.

---

> Quick Win 4 di 5. Prossimo: CORS spiegato.
> **Vibecoding Serio** — il libro completo a giugno 2026.

*Capitolo redatto: 2026-04-25 · Versione 1.0*
