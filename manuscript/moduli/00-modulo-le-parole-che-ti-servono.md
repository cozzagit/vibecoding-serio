# Modulo 0 — Le parole che ti servono per partire

> 4 capitoli · 14 pagine · 50 minuti di lettura
> Pre-requisiti: nessuno. Hai aperto un browser almeno una volta.

---

## Mettiti comodo

Prima di entrare nel dettaglio di come funziona un sito web, di come parlano un browser e un server, e di tutte quelle cose tecniche che ti spaventano — facciamo una cosa diversa.

Ti insegno **dieci parole**.

Dieci parole che probabilmente hai già sentito. Forse Claude le ha usate ieri in una sua risposta. Forse il tuo amico che si dice "developer" le ha buttate lì in chat. Tu hai annuito, perché annuire è gratis. Ma in realtà non sapevi cosa significassero davvero.

Le dieci parole sono queste:

> deploy · ambiente · localhost · produzione · server · hosting · dominio · DNS · API · framework

Il resto del libro le useremo come fossero ovvie. Quindi sistemiamole adesso, in modo soft, senza fretta. Niente codice. Niente terminale. Solo le parole, le metafore giuste per ricordartele, e qualche esempio della vita di tutti i giorni.

Quando finisci questo modulo, non sarai diventato uno sviluppatore. Ma quando aprirai Claude e gli scriverai il tuo prossimo prompt, avrai cinque parole in più nel cassetto. E ogni parola in più è una iterazione in meno persa a chiarire.

Iniziamo dalla più importante: **dove vive il tuo sito**, e perché questa domanda ha più di una risposta.

---

## 0.1 — Cosa significa "deploy", "produzione", "ambiente"

> *🎨 Infografica 1: I 3 ambienti — localhost, staging, produzione (a fianco di questo capitolo).*

### Il momento "magia"

Hai costruito qualcosa con Bolt o Lovable o Cursor. Sul tuo PC, il sito si apre digitando un indirizzo strano nel browser, qualcosa tipo `http://localhost:3000`. Funziona. Lo vedi tu.

Poi clicchi un bottone — di solito si chiama "Deploy" o "Publish" — e dopo un minuto il sito è raggiungibile da un altro indirizzo. Adesso lo possono aprire i tuoi amici, tua madre, un cliente in Australia, chiunque conosca il link.

Quel "qualcosa è successo" che separa i due momenti ha un nome preciso: **deploy**.

### Tre indirizzi, tre mondi

Il tuo sito può vivere in tre posti diversi nello stesso momento. Sembra strano, ma è normale. Si chiamano **ambienti**.

**Ambiente 1 — Localhost** *(il tuo computer)*

L'indirizzo è `localhost:3000` o `127.0.0.1:3000`. La parola "localhost" significa letteralmente *"questo computer qui"*. Lo vedi solo tu, perché il sito sta girando sulla tua macchina. Se spegni il PC, il sito sparisce. Se chiudi il programma che lo fa girare, il sito sparisce.

È il tuo **laboratorio**. Qui puoi rompere quello che vuoi, sperimentare, cancellare il database per sbaglio, scrivere codice orribile. Nessuno lo vedrà mai. Quando hai finito di sperimentare, premi "deploy" e mandi solo la versione buona "fuori".

**Ambiente 2 — Sviluppo (dev) o staging** *(server "di prova")*

Un indirizzo tipo `dev.miosito.com` o `staging-miosito.vercel.app`. È un server pubblico — quindi raggiungibile da chiunque conosca l'URL — ma di solito non è linkato da nessuna parte. È invisibile per Google, per il pubblico, per il tuo cliente. Lo usi per fare test "veri" prima di pubblicare la nuova versione.

Pensa al teatro: la prova generale. Tutto è in piedi (luci, scene, attori), ma il pubblico non c'è ancora.

Non tutti i progetti hanno questo ambiente. È utile quando lavori in team o quando il sito è critico (un e-commerce in saldi non vuole rischiare di esplodere durante il Black Friday).

**Ambiente 3 — Produzione (prod)** *(il sito vero, live)*

L'indirizzo è quello che dai al cliente. `miosito.it`. È quello che vedono **tutti**. Se si rompe, ricevi messaggi WhatsApp dei clienti alle 22:47.

Il termine "produzione" è preso in prestito dal mondo industriale. Una volta che il prodotto è "in produzione", non è più un prototipo: viene usato dai clienti veri.

### "Deploy", spiegato in una riga

> **Deploy** = l'azione di spostare il codice da un ambiente al suo successivo.
>
> Tipicamente: dal tuo PC (localhost) → al server di sviluppo → al server di produzione.

Quando Vercel o Netlify ti dicono "deploy successful", stanno dicendo: *"abbiamo preso il tuo codice, l'abbiamo messo sul server live, adesso il mondo lo vede"*.

### Una tabella per non confonderti più

| | Localhost | Dev / Staging | Produzione |
|---|---|---|---|
| **URL tipico** | `localhost:3000` | `dev.miosito.com` | `miosito.com` |
| **Chi lo vede** | Solo tu | Tu + team | Tutti |
| **Cosa contiene** | Codice + dati di test | Copia recente + dati finti | Sistema vero + dati clienti |
| **Si rompe? Costa…** | 30 minuti di tempo | Imbarazzo interno | Email arrabbiate, soldi |
| **Quanto puoi sperimentare** | Tutto | Quasi tutto | Niente |

### Cosa ti porti via da questo capitolo

1. Il tuo sito può vivere in **tre ambienti**: localhost (PC tuo), dev/staging (server di prova), produzione (sito vero).
2. **Localhost mente**: funzionare lì non significa funzionare in produzione. Sono mondi diversi.
3. **Deploy** = spostare il codice da un ambiente all'altro. Il momento in cui il codice "esce di casa".
4. Quando qualcuno ti dice *"in produzione non funziona"*, ti sta dicendo: *"in localhost forse sì, ma sul sito vero c'è qualcosa che si comporta diverso"*. È una **distinzione importantissima**, e il Modulo 7 ci tornerà a fondo.

---

## 0.2 — Server, hosting, dominio, DNS: quattro cose diverse spesso confuse

> *🎨 Infografica 2: Anatomia di un sito online — quattro entità connesse.*

### "Ho il server da Aruba"

Frase tipica del freelancer che vende siti. Suona competente. In realtà sta dicendo **quattro cose insieme** senza distinguerle. E quando una delle quattro va in crisi (e succede), non sa nemmeno dove guardare.

Smontiamole. Una alla volta.

### Server — *la macchina*

Un **server** è un computer. Punto. Non è magia, non è "il cloud", non è una nuvola.

È un computer come il tuo, ma:
- Sta acceso 24/7
- Sta in una stanza enorme con altri mille computer (il "data center")
- Non ha schermo, tastiera o mouse — ci si accede solo via rete
- Esegue **il tuo codice** invece che un browser o Word

Quando il tuo sito è "su Aruba", significa che il codice del tuo sito sta girando su uno di quei computer di Aruba.

> 💡 **Server fisico vs virtuale**: oggi quasi mai un server è una macchina fisica dedicata a te. Di solito è una macchina virtuale (VM) — un "computer simulato" che condivide la stessa macchina fisica con altri inquilini. Per te è uguale: lo controlli come fosse tutto tuo.

### Hosting — *il fornitore*

L'**hosting** è chi ti **vende** quel server. Aruba, Vercel, Netlify, AWS, DigitalOcean, Hetzner. Sono tutti hosting provider.

Pensa alla differenza tra una **casa** e l'**agenzia immobiliare** che te l'affitta. La casa è il server. L'agenzia è l'hosting.

Diversi tipi di hosting per diversi bisogni:
- **Hosting condiviso** (Aruba "Hosting Linux", SiteGround): paghi 30€/anno, condividi la macchina con altri 200 siti, comodo per WordPress.
- **VPS — Virtual Private Server** (Aruba VPS, Hetzner): paghi 5-30€/mese, hai una macchina virtuale tutta per te. Più potente, più libertà, ma devi configurarla da solo.
- **PaaS — Platform as a Service** (Vercel, Netlify, Railway): paghi quanto consumi, non vedi mai il server, fai solo `git push` e tutto succede magicamente. Più caro per progetti grossi, comodissimo per cominciare.
- **IaaS — Infrastructure as a Service** (AWS, Google Cloud, Azure): roba enterprise, potentissima, complicata.

> 🇮🇹 **Per progetti italiani piccoli/medi**: Aruba VPS o Vercel coprono il 90% dei casi. Aruba se vuoi controllo totale e database/file pesanti. Vercel se vuoi zero pensieri e il sito è "front-end + qualche API".

### Dominio — *il nome*

Il **dominio** è il nome che digiti nel browser. `miosito.it`, `vibecodingserio.vibecanyon.com`, `google.com`.

Si compra **separatamente** dall'hosting. Spesso da fornitori diversi:
- Lo compri da un **registrar** (Namecheap, Aruba domini, GoDaddy, Cloudflare Registrar)
- Lo paghi annualmente (5-50€/anno per i `.it` `.com` `.net` "normali")
- Quando smetti di pagare, qualcun altro può prenderlo

Il dominio è solo un **nome**. Non contiene il sito. È come il nome sul citofono di casa: dice "qui abita Mario Rossi", ma Mario Rossi non è il citofono — è una persona che vive dentro l'appartamento.

> 💡 **Sottodominio**: quando vedi `dev.miosito.it` o `blog.miosito.it`, quei "dev" e "blog" sono **sottodomini**. Li configuri tu, gratis, una volta che hai il dominio principale. Non li paghi separatamente.

### DNS — *l'elenco telefonico*

Qui arriviamo alla parte che a tutti i vibecoder sembra magia nera. In realtà è semplice.

Quando un utente digita `miosito.it` nel browser, il browser **non sa dove trovare il sito**. Il sito vive in un computer (server) da qualche parte nel mondo, identificato da un numero (l'**indirizzo IP**, tipo `188.213.170.214`). Ma l'utente ha digitato un nome, non un numero.

Come fa il browser a tradurre il nome in numero?

C'è un sistema mondiale che si chiama **DNS** (Domain Name System) che funziona come un **enorme elenco telefonico distribuito**. Tu chiedi "dov'è miosito.it?", il DNS risponde "all'indirizzo 188.213.170.214".

Configurare il DNS significa **scrivere nell'elenco telefonico**:
- "Quando qualcuno chiede `miosito.it`, mandalo a 188.213.170.214"
- "Quando qualcuno chiede `dev.miosito.it`, mandalo a 188.213.170.215"
- E così via.

Si fa nel pannello del registrar (Namecheap, Aruba, Cloudflare). Si chiamano "**record DNS**". I più comuni:

| Record | Cosa fa | Esempio |
|--------|---------|---------|
| **A** | Punta un dominio a un indirizzo IP | `miosito.it → 188.213.170.214` |
| **CNAME** | Punta un dominio a un altro dominio | `www.miosito.it → miosito.it` |
| **MX** | Dice "le email per questo dominio vanno qui" | `miosito.it → mail.aruba.it` |
| **TXT** | Note libere (per verifica proprietà, anti-spam) | `v=spf1 include:_spf.google.com` |

> 💡 **Quando fai un cambio DNS**, ci vogliono da 5 minuti a 24 ore perché il cambiamento si propaghi in tutto il mondo. È il motivo per cui *"ho cambiato il dominio ma il vecchio sito si vede ancora"*.

### Mettiamo tutto insieme con un esempio reale

Vuoi mettere online un sito chiamato `miobellosito.it`. Ecco cosa succede in pratica:

1. **Compri il dominio** `miobellosito.it` su Namecheap → 12€/anno
2. **Compri un VPS** su Aruba → 5€/mese, ti danno l'IP `188.213.170.214`
3. **Carichi il codice** del sito sul VPS (vedi capitolo 0.4)
4. **Configuri il DNS** su Namecheap: aggiungi un record A che dice `miobellosito.it → 188.213.170.214`
5. **Aspetti 30 minuti** per la propagazione DNS
6. Apri `https://miobellosito.it` e il sito è online

Hai usato **quattro entità diverse**: un dominio (Namecheap), un hosting+server (Aruba), e il DNS (configurato su Namecheap, ma è un sistema mondiale). Ognuna fa una cosa diversa.

### Cosa ti porti via

1. **Server** = la macchina che esegue il tuo codice.
2. **Hosting** = il fornitore che ti vende il server.
3. **Dominio** = il nome (`miosito.it`). Si compra separatamente.
4. **DNS** = l'elenco telefonico mondiale che traduce il nome nel numero IP del server.
5. Spesso compri queste cose da fornitori **diversi** e devi farle parlare tra loro.
6. Quando un sito "non si vede", quasi sempre il problema è in **uno di questi quattro pezzi** — non nel codice.

---

## 0.3 — Cos'è un'API, una libreria, un framework, un pacchetto, un SDK

> *🎨 Infografica 3: Le scatole di Lego del codice — API, libreria, framework, pacchetto, SDK*

### Le parole che Claude usa cento volte al giorno

Apri Claude. Gli chiedi di farti un sito. Lui ti risponde con un piano:

> *"Userò il framework Next.js, con la libreria Tailwind per lo stile, il pacchetto next-auth per l'autenticazione, e chiamerò l'API di Stripe tramite il loro SDK ufficiale."*

Tu copi, incolli, premi invio. Funziona. Non hai capito niente di quello che ha detto.

Sistemiamo le cinque parole. È più facile di quello che sembra.

### Una metafora: la cucina

Pensa a quando cucini.

- **Una ricetta** è un foglio con istruzioni: *"Per fare la pasta al pomodoro, fai bollire l'acqua, aggiungi sale, butta la pasta..."*. Tu la usi, segui i passi, ottieni il piatto.

- Una **cucina già attrezzata** è un ambiente intero: hai i fornelli, le pentole, gli utensili, e una struttura imposta (devi muoverti tra fornello-piano-lavandino-frigo). Non parti da zero, parti da uno spazio che ha già delle regole.

- Una **bottiglia di salsa già fatta** è un prodotto pronto: la apri, la usi, non ti chiedi come l'hanno fatta. Risparmi tempo.

- Il **menu di un ristorante** è una lista di cose che puoi chiedere e ottenere senza cucinarle tu. Ordini, paghi, ricevi il piatto.

- Un **kit per fare i sushi** è una scatola che contiene tutto il necessario (riso, alga, salsa di soia, bacchette, tappetino) + istruzioni mirate per farti partire subito con un task specifico.

Ognuna di queste cinque cose esiste anche nel mondo del codice. Hanno nomi precisi.

### Libreria — *la ricetta*

Una **libreria** è un pezzo di codice riusabile che fa **una cosa specifica**. Tu la usi per non scrivere quel codice da zero.

Esempi:
- `axios` → libreria per fare chiamate HTTP (parla con altri server)
- `dayjs` → libreria per gestire date e orari
- `lodash` → libreria con tante funzioni utility (raggruppare, ordinare, filtrare)
- `react-icons` → libreria con migliaia di icone già pronte

In codice, una libreria si "importa" e si "usa":

```javascript
import axios from 'axios';
const response = await axios.get('https://api.example.com');
```

Tu importi `axios`. Lui ti dà la funzione `get` già scritta. Tu la usi. Risparmi 200 righe di codice di rete che avresti dovuto scrivere a mano.

### Framework — *la cucina già attrezzata*

Un **framework** è più grosso di una libreria. Non ti dà una funzione, ti dà **un ambiente intero con regole**.

Esempi:
- **Next.js** → framework per costruire siti e app web in React (ti impone struttura cartelle, routing, server-side rendering)
- **Laravel** → framework PHP per app web
- **Django** → framework Python per app web
- **Rails** → framework Ruby per app web

La differenza con la libreria è importante: con una **libreria** sei tu che scrivi il programma e chiami la libreria quando ti serve. Con un **framework** è il framework che esegue il programma e chiama il tuo codice quando gli serve.

In gergo si dice *"un framework ti dice come deve essere fatta la tua app"*. Una libreria invece te la metti in tasca e la tiri fuori al momento giusto.

> 💡 **Regola pratica**: se la cosa che usi ti dice "metti i tuoi file in `pages/` e scrivi le tue pagine come componenti React", è un framework. Se ti dice "chiama questa funzione quando vuoi fare X", è una libreria.

### Pacchetto (package) — *la bottiglia di salsa*

Un **pacchetto** è il **file zippato** in cui viene distribuita una libreria o un framework.

Quando dici "ho installato il pacchetto axios", stai dicendo: "ho scaricato il file zippato che contiene la libreria axios e l'ho messo nel mio progetto".

I pacchetti si scaricano da **registri di pacchetti**:
- **npm** (Node Package Manager) per JavaScript / TypeScript → migliaia di pacchetti
- **pip** per Python
- **composer** per PHP
- **gem** per Ruby
- **cargo** per Rust

Il comando tipico è `npm install nome-pacchetto` (o `pnpm`, o `yarn` — sono varianti dello stesso strumento).

> 💡 **Distinzione fine ma utile**: `axios` è la **libreria** (il codice). `axios-1.6.0.tgz` su npm è il **pacchetto** (il file). Nella pratica si usano come sinonimi: "ho aggiunto il pacchetto axios" = "ho aggiunto la libreria axios".

### API — *il menu del ristorante*

Una **API** (Application Programming Interface) è una **lista di cose che puoi chiedere a un servizio**, e che il servizio è disposto a farti.

Esempi:
- L'**API di OpenAI**: puoi chiedere "rispondi a questa domanda", "genera questa immagine", "trascrivi questo audio"
- L'**API di Stripe**: puoi chiedere "addebita 29€ a questo cliente", "crea un abbonamento", "manda una fattura"
- L'**API di Google Maps**: puoi chiedere "dammi le coordinate di Via Manzoni 14, Como"

Per usare un'API:
1. Ti registri al servizio
2. Ottieni una **API key** (una password segreta)
3. Mandi richieste HTTP a un certo indirizzo (`https://api.openai.com/v1/...`)
4. Il servizio risponde con il risultato

L'API non è codice che gira sul tuo server. È un **contratto** tra te e qualcun altro: tu mandi una richiesta in un certo formato, loro rispondono in un certo formato. Tu non sai cosa succede in mezzo (e non ti interessa).

> 💡 **Anche tu puoi creare API**. Quando il tuo backend espone delle "rotte" (`/api/users`, `/api/login`), stai creando un'API. Il tuo frontend la chiama. Lo vedremo nel Modulo 5.

### SDK — *il kit per fare i sushi*

Un **SDK** (Software Development Kit) è un **pacchetto che ti dà tutti gli strumenti per usare facilmente un'API specifica**.

Esempio: l'API di Stripe è complessa. Per usarla "a mano" devi scrivere richieste HTTP, gestire autenticazione, parsare risposte JSON. Stripe ha pubblicato un **SDK ufficiale** che ti dà funzioni già pronte:

```javascript
import Stripe from 'stripe';
const stripe = new Stripe('sk_test_...');
const charge = await stripe.charges.create({ amount: 2900, currency: 'eur' });
```

Tre righe. Tu chiami `stripe.charges.create(...)` e dietro le quinte l'SDK fa tutto il lavoro: chiama l'API di Stripe, gestisce errori, ritorna l'oggetto.

Praticamente, un **SDK è una libreria specializzata** per usare un servizio specifico. Stripe SDK, Supabase SDK, OpenAI SDK, AWS SDK.

### Tabella riassuntiva

| Termine | Cos'è | Esempio | Lo "usi" così |
|---------|-------|---------|---------------|
| **Pacchetto** | Il file zippato che si scarica | `axios-1.6.0.tgz` | `npm install axios` |
| **Libreria** | Codice riusabile per UNA cosa | `axios`, `dayjs` | `import axios from 'axios'` |
| **Framework** | Codice + struttura imposta | Next.js, Laravel | Costruisci tutto il progetto dentro |
| **API** | Lista di cose chiedibili a un servizio | API OpenAI, API Stripe | Mandi richieste HTTP |
| **SDK** | Libreria specializzata per usare un'API | Stripe SDK, Supabase SDK | Importi e chiami funzioni pronte |

### Cosa ti porti via

1. Quando Claude scrive *"installa il pacchetto react-icons"*, sta dicendo "scarica questa libreria di icone".
2. Quando dice *"useremo il framework Next.js"*, sta dicendo "tutto il progetto sarà costruito secondo le regole di Next.js".
3. Quando dice *"chiamiamo l'API di OpenAI"*, sta dicendo "mandiamo una richiesta al loro server e aspettiamo una risposta".
4. Quando dice *"usiamo l'SDK di Supabase"*, sta dicendo "usiamo le funzioni pronte di Supabase per non scrivere chiamate HTTP a mano".
5. Adesso queste parole non ti spaventano più.

---

## 0.4 — FTP, SSH, Git: i tre modi per spostare codice

> *🎨 Infografica 4: Da localhost al server in 3 modi*

### Una domanda che nessuno ti ha mai spiegato

Hai scritto codice sul tuo PC. Funziona in localhost. Vuoi metterlo "sul server", così che il mondo lo veda. **Come ci arriva, fisicamente, da qui a là?**

Ci sono tre modi storici. Si sono susseguiti nel tempo, e oggi convivono. Ognuno è adatto a situazioni diverse.

### FTP — *il modo "vecchia scuola"*

**FTP** sta per **File Transfer Protocol**. È nato negli anni '70 e si usa ancora oggi, soprattutto con hosting condivisi (Aruba "Hosting Linux", SiteGround).

Funziona così:

1. Apri un programma chiamato "client FTP" — il più popolare gratis è **FileZilla**
2. Inserisci tre cose: indirizzo del server (es. `ftp.miosito.it`), username, password
3. Vedi due pannelli affiancati: a sinistra i tuoi file locali, a destra i file sul server
4. **Trascini i file** da sinistra a destra. Vengono copiati sul server.

È il modo più "fisico" di mettere file online. Sembra di trascinare cartelle in Esplora Risorse.

**Pro**:
- Visivo, intuitivo per chi viene da Windows/Mac
- Funziona con qualsiasi hosting
- Gratis (FileZilla)

**Contro**:
- **Lento** se devi caricare un sito intero (centinaia di file = ore)
- **Insicuro** nella versione classica: la password viaggia in chiaro. Usa sempre **SFTP** (la versione cifrata) se disponibile
- Rischio errori umani: dimenticarti un file, sovrascrivere quello sbagliato
- Niente versioning: se rompi qualcosa, non puoi tornare indietro

**Quando lo userai (raramente)**: WordPress su Aruba Hosting Linux. Caricamento di immagini massicce. Sito legacy in PHP che gira su hosting condiviso.

### SSH — *il modo "serio"*

**SSH** sta per **Secure Shell**. È un modo per **aprire un terminale remoto** sul server.

Cioè: tu apri un terminale sul tuo PC, scrivi un comando, e quel comando viene eseguito **sul server**, non sul tuo PC. Come se fossi seduto fisicamente davanti al server.

Esempio reale di una sessione SSH:

```bash
$ ssh root@188.213.170.214        # mi connetto al server
$ cd /var/www/miosito              # entro nella cartella del sito
$ git pull                         # scarico la versione aggiornata
$ pnpm build                       # ricostruisco il sito
$ pm2 restart miosito              # riavvio l'applicazione
$ exit                             # esco dal server
```

Cinque comandi. Dieci secondi. Il sito è aggiornato.

**Pro**:
- **Velocissimo** una volta che ci hai preso la mano
- **Sicuro** (tutto cifrato, autenticazione con chiave invece di password)
- Puoi fare **qualsiasi cosa**: spostare file, modificare configurazioni, riavviare servizi, vedere i log
- Fondamentale per chi gestisce un VPS

**Contro**:
- **Solo riga di comando**: se hai paura del terminale, devi superarla
- Devi **configurare la chiave SSH** la prima volta (10 minuti di setup)
- Su un click sbagliato puoi rompere tutto (con grande potere viene grande responsabilità)

**Quando lo userai (spesso, se hai un VPS)**: ogni volta che devi fare manutenzione, deploy manuale, troubleshooting di un sito su VPS Aruba, Hetzner, DigitalOcean.

### Git push + deploy automatico — *il modo "moderno"*

Questo è il modo più **comodo** per chi non vuole pensare al server.

Funziona così:

1. Il tuo codice è in un **repository Git** (su GitHub, GitLab, Bitbucket)
2. Il tuo hosting (Vercel, Netlify, Railway, Render) è **collegato al repository**
3. Tu scrivi codice in locale, fai `git commit` e poi `git push`
4. Il servizio di hosting **si accorge automaticamente** del nuovo codice
5. Lo scarica, lo compila, lo mette online — tutto da solo
6. In 30 secondi il sito è aggiornato

Tu non tocchi mai il server. Non sai nemmeno dov'è. Lo gestisce il provider per te.

**Pro**:
- **Zero touch** dopo setup iniziale
- **Versioning gratis**: se rompi qualcosa, torni alla versione precedente con un click
- **Storia di tutto**: ogni modifica registrata, vedi chi ha cambiato cosa e quando
- **Anteprime gratis**: alcuni servizi (Vercel) ti danno un URL di prova per ogni branch del repo
- **Funziona da qualsiasi PC**: niente da configurare in locale a parte Git

**Contro**:
- Il **costo cresce** con l'uso (Vercel ti fa pagare per banda, build, ecc.)
- Sei **legato al provider**: se Vercel cambia prezzi o regole, ti adegui
- **Meno controllo**: se vuoi installare un programma custom sul server, non puoi
- Dietro le quinte ci sono ancora server, FTP, SSH — ma sono nascosti

**Quando lo userai (probabilmente sempre)**: Next.js / Astro / SvelteKit su Vercel o Netlify. Progetti front-end. App piccole/medie. Tutto quello che fai con AI generative oggi.

### Tabella decisionale: quale usare?

| Situazione | Modo consigliato |
|------------|------------------|
| Hai un sito Next.js / React / Astro statico | **Git push + Vercel/Netlify** |
| Gestisci un VPS Aruba con più siti, database, custom config | **SSH** |
| Hai WordPress su Aruba Hosting Linux | **SFTP** |
| Devi caricare un PDF in una cartella di un sito esistente | **SFTP** o **SSH**, dipende dall'host |
| Lavori in team su un progetto serio | **Git push + CI/CD** |
| Stai imparando, vuoi capire cosa succede | **SSH**, almeno una volta |

### Una nota sulla parola "Git"

Quando ho detto "Git push", ti ho usato un termine che merita un secondo.

**Git** è un sistema per **tracciare le modifiche al codice** nel tempo. Non è un modo per spostare file: è un modo per **versionare** il tuo progetto.

Ogni volta che fai un cambiamento e dici "questa è una modifica importante", Git la registra come un **commit**. Puoi tornare indietro a qualsiasi commit, vedere chi ha cambiato cosa, lavorare in parallelo con altre persone senza pestarsi i piedi.

**GitHub** (o GitLab, Bitbucket) è un **sito** che ospita repository Git online, in modo che tu possa condividerli con altri o usare i tuoi PC diversi.

Il "Git push" del modo moderno significa: *"manda tutti i miei commit recenti al repository online"*. Da lì, il provider di hosting li raccoglie e fa il deploy.

> 💡 Approfondimento Git lo facciamo nel **Modulo 8**, quando parleremo di parlare a Claude. Per adesso ti basta sapere che `git push` = "manda il mio codice nel cloud, che poi ci pensa qualcun altro".

### Cosa ti porti via

1. **FTP**: trascini file, vecchia scuola, lento. Si usa ancora con hosting condivisi.
2. **SSH**: terminale remoto sul server. Potente, veloce, richiede di non avere paura della riga di comando.
3. **Git push + deploy automatico**: il modo moderno. Tu fai `git push`, il provider fa il resto.
4. Probabilmente userai sempre il **terzo** modo, e ogni tanto il **secondo**.
5. Il primo modo è una conoscenza utile per non sentirti perso quando un cliente ti dice "ho un sito su Aruba con FTP".

---

## Chiusura del Modulo 0

Hai letto il primo modulo. Adesso le **dieci parole** dell'inizio dovrebbero suonarti diverse:

> deploy · ambiente · localhost · produzione · server · hosting · dominio · DNS · API · framework

Non sei diventato uno sviluppatore. Sei diventato **uno che le parole le riconosce**. È un grosso primo passo: ogni libro tecnico, ogni risposta di Claude, ogni domanda che farai a uno sviluppatore vero adesso parte da una base condivisa.

Nei prossimi moduli costruiamo sopra:

- **Modulo 1** → cosa succede tecnicamente quando premi "deploy"
- **Modulo 2** → la grande divisione tra **client e server**, con tutti i linguaggi che vivono da una parte e dall'altra
- **Modulo 3** → l'**anatomia visuale** di una pagina web (quello che ti aiuta di più a parlare con Claude)

Prima di andare avanti, fai un piccolo test con te stesso.

---

## 🎯 Mini-quiz di autovalutazione

Rispondi a queste 5 domande. Se ne sbagli più di 2, rileggi il capitolo corrispondente prima di proseguire.

**1. Tuo amico ti dice: *"il sito non funziona in produzione, in localhost sì"*. Cosa significa?**

> *La risposta è alla fine.*

**2. Hai comprato un dominio su Namecheap. Hai un VPS su Aruba. Ti manca un solo passaggio per far funzionare il dominio. Quale?**

**3. Differenza in una frase tra *libreria* e *framework*.**

**4. Quando Claude scrive *"useremo il pacchetto stripe"*, cosa intende?**

**5. Hai un sito Next.js da deployare su Vercel. Quale dei tre modi userai (FTP, SSH, Git push)?**

---

### Risposte

1. *Significa che il sito è online ma c'è qualcosa che si comporta diversamente rispetto al suo PC. Quasi sempre è una variabile d'ambiente, un problema di CORS, o un database remoto diverso da quello locale. Lo vedremo a fondo nel Quick Win 1.*

2. *Configurare il **DNS**: aggiungere un record A su Namecheap che dice "manda chi cerca il mio dominio all'indirizzo IP del server Aruba".*

3. *Una **libreria** è codice che chiami quando ti serve (axios, dayjs). Un **framework** è codice che ti impone una struttura e che chiama il tuo codice (Next.js, Laravel).*

4. *"Scarica e installa la libreria di Stripe nel tuo progetto", facendo `npm install stripe`. Da lì potrai importarla nel tuo codice e chiamare le sue funzioni per parlare con l'API di Stripe.*

5. ***Git push***. Vercel è collegato al tuo repo GitHub: tu fai push, lui fa tutto il resto.

---

> Se sei arrivato fin qui senza saltare paragrafi, hai investito 50 minuti che ti faranno risparmiare ore di iterazioni con Claude nei prossimi mesi. Adesso prendi un caffè e poi vai al Modulo 1.

---

*Modulo 0 redatto: 2026-04-25 · Versione 1.0 · ~14 pagine · ~3500 parole*
