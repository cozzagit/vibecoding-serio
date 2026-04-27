# Modulo 6 — Il database non è un foglio Excel (quasi)

> 5 capitoli · 18 pagine · 1 ora 10 minuti
> Pre-requisiti: Modulo 2 letto. Sai che il database è il "terzo vertice" e parla solo col server.

---

## Mettiti comodo

I database fanno paura. Si sente parlare di "schema", "migration", "JOIN", "indici", "ACID", e sembra roba da specialisti. In realtà i concetti che ti servono come vibecoder sono **molto pochi**, e li puoi capire in un'ora.

L'obiettivo di questo modulo non è renderti un database admin. È darti il vocabolario e i concetti per:
- Capire cosa Claude scrive quando crea il database del tuo progetto
- Riconoscere errori comuni (es. dati persi, query sbagliate)
- Sapere come fare backup senza piangere

Cinque capitoli:

1. Tabelle, righe, colonne — il foglio Excel che non puoi rompere
2. Chiavi primarie e relazioni — perché l'utente si lega all'ordine
3. SQL in 10 minuti — le 4 query che Claude scrive sempre
4. SQL vs NoSQL — Supabase, Firebase, Neon
5. Migration e backup — non perdere mai i dati

---

## 6.1 — Tabelle, righe, colonne

### La metafora del foglio Excel

Il modo più semplice per pensare a un database **relazionale** (Postgres, MySQL, SQLite, Supabase) è come a un **foglio Excel rigoroso**.

Ogni database ha al suo interno **tabelle**. Ogni tabella ha **colonne** (campi) e **righe** (record).

Esempio: una tabella `users`:

| id | first_name | last_name | email | city |
|----|------------|-----------|-------|------|
| 1 | Marco | Bianchi | marco@email.it | Como |
| 2 | Francesca | Colombo | fra@email.it | Lecco |
| 3 | Giuseppe | Riva | gpe@email.it | Cantù |

Stessa cosa in Excel: foglio `users`, colonne `id`, `first_name`, `last_name`, `email`, `city`, e tre righe.

### Cosa cambia rispetto a Excel

Tre differenze importanti:

**1. Schema rigido (i tipi di colonna)**

Ogni colonna in un database **ha un tipo**. La colonna `id` è un numero intero. `email` è una stringa. `created_at` è una data.

Se provi a inserire un valore del tipo sbagliato (es. la stringa "ciao" nella colonna `id` numerica), il database **rifiuta** l'operazione. In Excel puoi mettere quello che vuoi dove vuoi.

**2. Vincoli (constraints)**

Puoi dire al database regole come:
- *"`email` non può essere vuoto"* → NOT NULL
- *"`email` deve essere unico"* → UNIQUE
- *"`age` deve essere ≥ 0"* → CHECK
- *"questo `user_id` deve esistere nella tabella `users`"* → FOREIGN KEY

Excel non ha queste sicurezze. Un database sì.

**3. Performance**

Un database con **1 milione di righe** può cercare un singolo record in **millisecondi**, perché usa **indici** (strutture interne ottimizzate per ricerca veloce). Excel a 1 milione di righe piange.

### Esempi di tipi di colonna

I più usati:

| Tipo | A cosa serve | Esempio |
|------|--------------|---------|
| `INTEGER` | numero intero | id, età, quantità |
| `TEXT` / `VARCHAR(n)` | testo | nome, email, indirizzo |
| `BOOLEAN` | vero/falso | is_active, is_admin |
| `TIMESTAMP` | data + ora | created_at, deleted_at |
| `DECIMAL(10,2)` | numero decimale | prezzo, quantità float |
| `JSON` / `JSONB` | dati strutturati flessibili | metadati, configurazioni |
| `UUID` | identificatore unico globale | id moderni (es. `xyz-abc-123-...`) |

Non ti serve impararli a memoria. Quando Claude crea uno schema, vede questi nomi → ora sai cosa significano.

### Cosa ti porti via

1. Database = foglio Excel **rigoroso**.
2. Le **tabelle** hanno colonne (con tipo) e righe.
3. Tre cose che Excel non ha: **schema rigido, vincoli, performance**.
4. I **tipi di colonna** che incontri di più: integer, text, boolean, timestamp, decimal, json, uuid.

---

## 6.2 — Chiavi primarie e relazioni

### La chiave primaria: l'identificatore univoco

Ogni tabella ha (deve avere) una colonna che identifica univocamente ogni riga: la **chiave primaria** (primary key, PK).

Tipicamente si chiama `id` ed è un numero o un UUID.

```
users:
  id (PK) | first_name | email
  1       | Marco      | marco@...
  2       | Francesca  | fra@...
```

Se chiedo "dammi l'utente 1", il database lo trova **istantaneamente** perché la PK è indicizzata. Se chiedessi "dammi l'utente di nome Marco", dovrebbe scorrere tutti gli utenti (a meno che non ci sia un altro indice).

### Le relazioni: come le tabelle si parlano

Il vero potere dei database **relazionali** è proprio questo: **le tabelle si possono collegare tra loro**.

Esempio. Hai un'app di e-commerce. Hai due tabelle:

`users`:
| id | name |
|----|------|
| 1 | Marco |
| 2 | Francesca |

`orders`:
| id | user_id | total |
|----|---------|-------|
| 100 | 1 | 50.00 |
| 101 | 2 | 120.00 |
| 102 | 1 | 30.00 |

La colonna `user_id` in `orders` **punta** alla colonna `id` di `users`. Questo si chiama **foreign key** (chiave esterna, FK).

Adesso puoi fare domande del tipo: *"dammi tutti gli ordini di Marco"* → il database segue il riferimento e ti dà gli ordini con `user_id = 1`.

### I tre tipi di relazione

**1. Uno a molti (1:N)**

Un utente ha molti ordini. Ogni ordine ha un solo utente. Il caso più comune. Si implementa con una **foreign key** sulla parte "molti" (in `orders`).

**2. Molti a molti (N:N)**

Un utente può avere molti ruoli. Un ruolo può essere assegnato a molti utenti. Si implementa con una **tabella intermedia**:

```
users_roles:
  user_id | role_id
  1       | 1
  1       | 3
  2       | 2
```

**3. Uno a uno (1:1)**

Un utente ha un solo profilo. Un profilo appartiene a un solo utente. Raro, di solito si fonde tutto in una tabella sola.

### Cancellazione con CASCADE: una scelta importante

Quando elimini un utente, cosa succede ai suoi ordini? Tre opzioni:

- **CASCADE**: elimina anche gli ordini → "se sparisce Marco, spariscono i suoi ordini"
- **SET NULL**: imposta `user_id = NULL` → "gli ordini restano, ma ora 'orfani'"
- **RESTRICT**: vieta la cancellazione finché ci sono ordini → "non puoi cancellare Marco perché ha ordini"

Quando Claude crea uno schema, sceglie una di queste. Per la cancellazione di un utente, di solito ha senso CASCADE per le **tabelle dipendenti** (come `sessions`, `tokens`) e RESTRICT o soft-delete per i **dati di business** (come `orders`, che vorresti tenere per la fattura).

### Cosa ti porti via

1. Ogni tabella ha una **chiave primaria** (PK), tipicamente `id`.
2. Le tabelle si collegano via **foreign key** (FK). È l'essenza dei database "relazionali".
3. Tre tipi di relazione: **1:N** (più comune), **N:N** (con tabella intermedia), **1:1** (raro).
4. Quando si elimina, attenzione a **CASCADE / SET NULL / RESTRICT**.

---

## 6.3 — SQL in 10 minuti

### Le 4 query che Claude scrive sempre

**SQL** (Structured Query Language) è il linguaggio per parlare ai database relazionali. Ha tante funzioni avanzate, ma il 95% del codice che leggi userà solo **4 verbi**:

```sql
SELECT  -- leggi
INSERT  -- crea
UPDATE  -- modifica
DELETE  -- elimina
```

### SELECT — leggere

```sql
SELECT * FROM users WHERE city = 'Como';
```

Tradotto: *"Dammi tutte le colonne (`*`) dalla tabella `users` dove `city = 'Como'`".*

Varianti utili:
```sql
-- Solo certe colonne
SELECT first_name, email FROM users WHERE city = 'Como';

-- Ordinamento
SELECT * FROM users ORDER BY last_name ASC;

-- Limit
SELECT * FROM users LIMIT 10;

-- Conteggio
SELECT COUNT(*) FROM users;
```

### INSERT — creare

```sql
INSERT INTO users (first_name, email, city)
VALUES ('Marco', 'marco@email.it', 'Como');
```

Tradotto: *"Crea una nuova riga in `users` con questi valori"*. La PK (`id`) viene generata automaticamente.

### UPDATE — modificare

```sql
UPDATE users SET city = 'Milano' WHERE id = 1;
```

Tradotto: *"Cambia la città a 'Milano' per l'utente con id=1"*.

> ⚠️ **Attenzione**: UPDATE senza WHERE modifica **tutte le righe** della tabella. Se Claude scrive `UPDATE users SET city = 'Milano'` senza WHERE, sta dicendo "cambia la città di TUTTI gli utenti a Milano". Errore catastrofico.

### DELETE — eliminare

```sql
DELETE FROM users WHERE id = 1;
```

Stesso warning: DELETE senza WHERE = elimina tutto. Pericolo.

### JOIN: collegare due tabelle

Il 5% più "avanzato" sono i JOIN, che ti permettono di interrogare più tabelle insieme:

```sql
SELECT users.first_name, orders.total
FROM users
JOIN orders ON orders.user_id = users.id
WHERE users.city = 'Como';
```

Tradotto: *"Dammi nome utente e totale ordine, prendendo gli utenti di Como e i loro ordini"*. Sotto il cofano sta seguendo le foreign key.

### SQL injection: il pericolo che NON devi mai vedere

Una nota di sicurezza importante. Mai concatenare input utente in una query SQL così:

```javascript
// MALE
const query = `SELECT * FROM users WHERE email = '${userInput}'`;
```

Se l'utente inserisce `marco@x.it' OR '1'='1`, la query diventa `SELECT * FROM users WHERE email = 'marco@x.it' OR '1'='1'` → ritorna tutti gli utenti. È **SQL injection**.

Il modo corretto è **parametrizzare**:

```javascript
// BENE
const query = 'SELECT * FROM users WHERE email = $1';
const result = await db.query(query, [userInput]);
```

Con un ORM (vedi 6.4) questo lo fai senza pensarci. Ma sappi che esiste.

### Cosa ti porti via

1. Le **4 query base** in SQL: SELECT (leggi), INSERT (crea), UPDATE (modifica), DELETE (elimina).
2. **WHERE** filtra le righe. Senza WHERE, UPDATE/DELETE colpiscono tutto. Pericolo.
3. **JOIN** unisce due tabelle attraverso le foreign key.
4. **SQL injection**: mai concatenare input utente. Sempre parametri. Gli ORM moderni lo fanno per te.

---

## 6.4 — SQL vs NoSQL: Supabase, Firebase, Neon

### Le due famiglie

I database si dividono in due grandi famiglie. Te le ho accennate nel Modulo 2, qui le approfondiamo.

**SQL / Relazionali**:
- Schema rigido, tabelle, righe, colonne
- Linguaggio: SQL
- Esempi: **PostgreSQL** (Postgres), **MySQL**, **SQLite**, **MariaDB**
- Hosting moderno: **Supabase** (Postgres come servizio), **Neon** (Postgres serverless), **PlanetScale** (MySQL serverless)

**NoSQL / Documentali**:
- Schema flessibile, "documenti" tipo JSON, niente tabelle rigide
- Linguaggio: variabile (query API specifica)
- Esempi: **MongoDB**, **Firestore** (Google), **DynamoDB** (AWS)
- Hosting: **MongoDB Atlas**, **Firebase** (include Firestore)

### Quando usare SQL

**Default per il 90% dei casi**. SQL vince quando:
- I dati hanno **struttura chiara** (utenti, ordini, prodotti)
- Hai **relazioni** (un utente, molti ordini)
- Vuoi **transazioni** (es. pagamento + decremento stock contemporanei)
- Vuoi **query complesse** con aggregazioni

Per un'app web standard moderna: **Postgres su Supabase o Neon**. È la scelta default. Affidabile, scalabile, ben supportato dagli ORM.

### Quando usare NoSQL

NoSQL ha senso in casi specifici:
- Dati molto **eterogenei** (ogni documento ha campi diversi)
- **Scaling massiccio** in sola scrittura (milioni di record/sec)
- App **mobile real-time** dove Firestore brilla per le sue subscriptions

Esempi: app real-time di chat, dati IoT, analytics ad alto volume. Per il vibecoder che parte oggi: probabilmente **non è il tuo caso**. Postgres ti basta e ti avanza.

### Supabase: la scelta moderna del vibecoder

Una nota su **Supabase**. È un servizio che ti dà:
- Un **Postgres** ospitato (database)
- Un'**API REST** generata automaticamente sopra le tue tabelle
- **Autenticazione** pronta (login, OAuth)
- **Storage file** (immagini, documenti)
- **Real-time** subscriptions

In pratica: con Supabase puoi avere il backend di un'app web in **15 minuti** senza scrivere codice server. Per questo è la scelta default di Bolt, Lovable, e Claude quando genera app moderne.

### ORM: il traduttore tra codice e SQL

Lo abbiamo accennato nel Modulo 2: scrivere SQL a mano è scomodo. Si usa un **ORM** (Object-Relational Mapper) che traduce il tuo codice in SQL.

```typescript
// Tu scrivi questo (Drizzle, l'ORM moderno per TypeScript):
const usersInComo = await db.select()
  .from(users)
  .where(eq(users.city, 'Como'));

// Drizzle traduce in:
// SELECT * FROM users WHERE city = 'Como';
```

ORM popolari:
- **Drizzle** (TypeScript, moderno) — il preferito oggi
- **Prisma** (TypeScript, enterprise) — più magico ma più pesante
- **Eloquent** (Laravel) — il "default" PHP
- **SQLAlchemy** (Python)
- **ActiveRecord** (Rails)

Quando Claude scrive un backend, **quasi sempre** usa un ORM. Tu non vedi più il SQL diretto, vedi il codice ORM.

### Cosa ti porti via

1. Due famiglie: **SQL** (Postgres, MySQL, SQLite) e **NoSQL** (MongoDB, Firestore).
2. **Default**: SQL, in particolare **Postgres su Supabase o Neon**.
3. **Supabase** è il "Firebase di Postgres" — ti dà DB + auth + storage + real-time.
4. Gli **ORM** (Drizzle, Prisma) traducono il tuo codice in SQL. Più sicuri (no SQL injection automatica), più leggibili.

---

## 6.5 — Migration e backup: non perdere mai i dati

### Migration: cambiare lo schema senza piangere

Hai creato la tabella `users` con 3 colonne. Domani vuoi aggiungere `phone_number`. **Come fai?**

Non puoi semplicemente cambiare lo schema con `ALTER TABLE` a mano in produzione: rischi di rompere tutto, non hai versionamento.

La soluzione si chiama **migration**: file SQL (o codice) versionati in git, applicati in ordine, che descrivono ogni modifica allo schema nel tempo.

Esempio Drizzle/Prisma genera un file tipo:

```sql
-- migrations/001_add_phone_number.sql
ALTER TABLE users ADD COLUMN phone_number TEXT;
```

Quando deployi in produzione, esegui questo script (`pnpm drizzle-kit push` o `prisma migrate deploy`). Il database aggiunge la colonna. Lo schema in locale e in produzione sono allineati.

### Il bug classico del vibecoder: schema disallineato

Il caso tipico:
1. In locale aggiungi una colonna direttamente con un click su Supabase Studio
2. Modifichi il codice per usarla
3. Deployi in produzione
4. Crash → `ERROR: column "phone_number" does not exist`

**Causa**: hai cambiato lo schema solo in locale, non in produzione. La migration esiste apposta per evitare questo errore.

> ✏️ **Prompt-ready**: *"Aggiungi una colonna `phone_number` alla tabella `users`. Crea una migration con Drizzle. Dimmi anche come applicarla in produzione."*

### Backup: la vita che ti salva

Storia vera (anonimizzata): un freelancer ha lavorato 6 mesi a un sito SaaS per un cliente. Decide di "ottimizzare" il database. Esegue uno script di pulizia. Cancella **tutto**. Niente backup. Sei mesi di lavoro andati. Cliente perso. Reputazione devastata.

Il **backup** è la differenza tra "errore recuperabile" e "carriera finita".

### Strategie di backup per i 3 casi più comuni

**Caso 1: Supabase**

Supabase fa backup automatici **giornalieri** sul piano free, e on-demand sul piano Pro. Buono ma:
- Free: backup conservati per 7 giorni
- Pro (25$/mese): backup conservati per 30 giorni + Point-in-Time Recovery

**Configurazione minima**: passa al piano Pro **prima di andare live con clienti veri**. 25$ vale l'assicurazione.

**Caso 2: Postgres su VPS Aruba (o altro VPS)**

Devi configurare i backup tu. Setup in 10 minuti:

```bash
# Crea uno script di backup
#!/bin/bash
DATE=$(date +%Y-%m-%d)
pg_dump cantiere | gzip > /backups/cantiere-$DATE.sql.gz
# Tieni solo gli ultimi 30 giorni
find /backups -name "*.sql.gz" -mtime +30 -delete
```

Aggiungi al crontab per girare ogni notte. Copia i backup su un server esterno (es. Backblaze B2 a 6$/TB/mese).

**Caso 3: SQLite (es. progetti hobby)**

Il database SQLite è un file. Per fare backup, **copialo**. Una riga:

```bash
cp app.db /backups/app-$(date +%Y-%m-%d).db
```

Setup in 30 secondi. È un caso d'uso comune per progetti piccoli (es. blog personale, tool interno).

### La regola d'oro del backup

> **Un backup non testato non è un backup. È una speranza.**

Una volta al mese (almeno):
1. Scarica un backup recente
2. Restoralo in un ambiente di test
3. Verifica che funzioni

Senza il test, non sai se i tuoi backup sono validi. Lo scopri solo nel momento sbagliato.

### Cosa ti porti via

1. **Migration** = file versionati che descrivono cambiamenti allo schema. Mai modificare lo schema in produzione a mano.
2. Il **bug classico**: schema cambiato in locale ma non in produzione → crash.
3. **Backup automatico** sempre. Su Supabase: piano Pro. Su VPS: cron + script.
4. **Testa i backup**: una volta al mese, restoralo per davvero. Senza test, non sono backup.

---

## Chiusura del Modulo 6

Adesso il database non è più magia nera:

- Sai cosa sono tabelle, colonne, chiavi, relazioni
- Sai leggere SELECT/INSERT/UPDATE/DELETE quando Claude le scrive
- Sai distinguere SQL e NoSQL e perché di default vai su Postgres
- Sai perché esistono migrations e come funzionano
- Sai come fare backup e perché è non-negoziabile

Nel **Modulo 7** torniamo all'infrastruttura: DNS in profondità, HTTPS, nginx, variabili d'ambiente, cookie, CORS. Tutto quello che separa "funziona in locale" da "funziona in produzione".

---

## 🎯 Mini-quiz di autovalutazione

**1. Vero o falso: in un database Postgres puoi mettere una stringa "ciao" in una colonna numerica.**

**2. Cos'è una "foreign key"?**

**3. Hai un comando `UPDATE users SET email = 'x@y.it'` senza WHERE. Cosa succede?**

**4. Per un'app web moderna che parte oggi, quale database conviene di default?**

**5. Hai aggiunto una colonna alla tabella `users` solo in locale. Deployi in produzione. Cosa succede?**

---

### Risposte

1. **Falso**. Lo schema rigido di Postgres rifiuta l'inserimento se il tipo non corrisponde. È una protezione contro bug e data corruption.

2. Una colonna che **punta** alla chiave primaria di un'altra tabella. Es. `orders.user_id` punta a `users.id`. Permette di mettere in relazione le tabelle.

3. **Aggiorna l'email di TUTTI gli utenti** a `'x@y.it'`. Errore catastrofico. WHERE è obbligatorio (mentale, non sintattico).

4. **Postgres**, ospitato su **Supabase** o **Neon**. Default moderno per il 90% dei casi. NoSQL solo per casi specifici (real-time massivo, dati eterogenei).

5. **Crash in produzione**: il codice cerca la colonna nuova ma il DB di produzione non ce l'ha. Soluzione: usare le migration → modifiche allo schema versionate ed eseguite anche in produzione.

---

*Modulo 6 redatto: 2026-04-25 · Versione 1.0 · ~18 pagine · ~4400 parole*
