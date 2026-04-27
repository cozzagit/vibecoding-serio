# Modulo 3 — L'anatomia di una pagina web

> 5 capitoli · 22 pagine · 1 ora 30 minuti
> Pre-requisiti: Moduli 0, 1, 2 letti. Sai cosa è un client, cosa è un server.

---

## Mettiti comodo (prendi anche carta e penna)

Questo è il **modulo bandiera** del libro. Quello che, se applichi sul serio, cambia il modo in cui parli a Claude da domani mattina.

Il problema che risolve è semplice: oggi quando descrivi un'interfaccia a Claude, usi parole **vaghe**. *"Fai un menu che esce"*. *"Aggiungi un blocco con le icone"*. *"Mettici un popup di conferma"*. Claude interpreta come può. A volte indovina, a volte no. Tu provi 3-4 modifiche, ti arrabbi, peggio.

La soluzione è **conoscere i nomi giusti** dei pezzi che compongono una pagina web. Quando tu dici *"un drawer mobile sticky in basso con shortcut alle azioni primarie, dismissibile col gesto swipe down"*, Claude sa esattamente cosa generare. Una iterazione, non sette.

Questo modulo è in cinque parti. Ogni parte è un **insieme di componenti** raggruppati per funzione. Per ognuno: nome italiano + inglese, dove si usa, e la frase **"come dirlo a Claude"** — cioè il prompt-pattern già pronto da usare.

1. I 5 macro-blocchi della pagina (header, nav, main, sidebar, footer)
2. Componenti di navigazione (navbar, breadcrumb, tab, stepper, pagination, hamburger)
3. Componenti di contenuto (hero, card, banner, list, grid, carousel, accordion, table)
4. Componenti di interazione (modal, drawer, toast, tooltip, dropdown, form, button)
5. Stati e feedback visivi (empty state, loading, error, skeleton, spinner, hover, focus)

Alla fine avrai un **lessico** di circa 50 termini che ti accompagna per tutto il resto della tua carriera con AI. Ti consiglio di **stamparti** la pagina del glossario alla fine, e tenerla accanto al PC quando lavori.

Andiamo.

---

## 3.1 — I 5 macro-blocchi di ogni pagina

> *🎨 Infografica 10: Anatomia di una pagina (FONDAMENTALE — la spina dorsale visiva del libro).*

### La struttura che ogni pagina condivide

Apri un sito qualsiasi. Amazon, BBC, Wikipedia, il blog del tuo idraulico. Tutti hanno una struttura sotto che — anche se diversa nei dettagli — segue **lo stesso schema** di base.

Cinque blocchi, sempre quelli:

```
┌─────────────────────────────────────────────────┐
│  HEADER  (in cima)                              │
├─────────────────────────────────────────────────┤
│  NAVIGATION  (può essere nel header o separata) │
├─────────────────────────────────────────────────┤
│         │                                       │
│ SIDEBAR │   MAIN CONTENT (il cuore della pag.) │
│ (opz.)  │                                       │
│         │                                       │
├─────────────────────────────────────────────────┤
│  FOOTER  (in fondo)                             │
└─────────────────────────────────────────────────┘
```

Vediamoli uno per uno.

### Header — *la cima della pagina*

L'**header** è la fascia in alto. È quello che vedi prima di tutto. Tipicamente contiene:

- **Logo** (a sinistra)
- **Navigazione principale** (centro o destra)
- **CTA d'accesso** (login, registrati, carrello)
- A volte una **search bar**

L'header è quasi sempre **sticky**, cioè rimane visibile mentre l'utente scrolla. È la zona di "mai persi" della pagina.

> ✏️ **Prompt-ready**: *"Header sticky con logo a sinistra, navbar centrale con i 4 link principali, e bottone CTA primario a destra. Su mobile collassa in hamburger menu."*

### Navigation (nav) — *come ci si muove nel sito*

La **navigation** può essere:
- **Dentro l'header** (è il caso più comune oggi)
- Una **sidebar laterale** (più frequente nelle dashboard / app)
- Una **bottom navigation bar** (tipica delle app mobile)

L'elemento HTML semantico è proprio `<nav>`. Le voci dentro sono i link principali del sito.

> ✏️ **Prompt-ready**: *"Sidebar nav fissa a sinistra con icone + label, sezioni raggruppate, sezione attiva evidenziata."*

### Main content — *il cuore della pagina*

Il **main content** è il contenuto vero della pagina. L'articolo, la dashboard, il form di checkout. Tutto quello che cambia tra una pagina e l'altra.

L'elemento HTML è `<main>`. Per convenzione, ce n'è uno solo per pagina.

> ✏️ **Prompt-ready**: *"Main content centrato max-width 1200px, padding generoso, gerarchia chiara con h1 in cima."*

### Sidebar — *la colonna laterale (opzionale)*

La **sidebar** è una colonna laterale (di solito a destra o sinistra). Contiene:
- **Filtri** (tipico negli e-commerce)
- **Indice del contenuto** (tipico nei blog tecnici)
- **Box pubblicitari** (siti vecchi)
- **Profilo utente / link rapidi** (dashboard)

Su mobile la sidebar **scompare** (o si trasforma in drawer). Concetto chiave: una sidebar non è mai obbligatoria, è un complemento.

> ✏️ **Prompt-ready**: *"Sidebar destra 280px sticky, con filtri categoria e prezzo. Su mobile diventa drawer apribile dal bottone filtri."*

### Footer — *la fine della pagina*

Il **footer** è la fascia in fondo. Tipicamente contiene:
- **Link legali** (privacy, termini, cookie)
- **Contatti** e indirizzo
- **Social links**
- **Newsletter signup**
- **Copyright**

> ✏️ **Prompt-ready**: *"Footer con 3 colonne: contatti, link rapidi, newsletter. Riga sotto con copyright e link ai social."*

### Esempio reale: Amazon

Per fissare i concetti, smontiamo Amazon:

- **Header**: logo Amazon, search bar centrale, bandierina lingua, account, ordini, carrello → tutto sticky
- **Nav**: barra orizzontale sotto l'header con "Tutte le categorie", "Vendere", "Customer Service"
- **Sidebar** (in pagine prodotto): filtri (marca, prezzo, valutazione)
- **Main**: lista prodotti, scheda prodotto, recensioni
- **Footer**: link rapidi (Lavora con noi, Aiuto, Termini, Privacy) + paese/lingua

Ogni e-commerce, ogni dashboard, ogni blog: stessa struttura, dettagli diversi.

### Cosa ti porti via

1. Ogni pagina web ha **5 macro-blocchi**: header, navigation, main, sidebar (opzionale), footer.
2. Sono presenti **quasi sempre**, anche se l'aspetto cambia.
3. Quando descrivi una pagina a Claude, parti da questi 5: dichiari ciascuno e specifichi cosa contiene.
4. **Suggerimento da stampa**: l'infografica 10 vale da sola lo sforzo. La trovi a fine modulo formato poster.

---

## 3.2 — Componenti di navigazione

> *🎨 Infografica 11: Componenti di navigazione.*

Adesso scendiamo nei dettagli. Sette componenti per la navigazione. Vediamoli.

### Navbar — *la barra orizzontale in alto*

La **navbar** è la barra di navigazione che vedi nell'header. Lista di link orizzontali. Su mobile collassa in un hamburger.

> ✏️ **"Navbar orizzontale con 5 link, dropdown 'Servizi' a tendina, CTA 'Prova gratis' come bottone primario all'estrema destra."*

### Sidebar nav — *barra laterale verticale*

Una **sidebar di navigazione** è verticale. Tipica delle dashboard. Si trova nelle app come Notion, Slack, Linear, Vercel.

Caratteristiche:
- Icone + label per ogni voce
- Sezioni raggruppate (es. "Lavoro" / "Personale")
- Voce attiva evidenziata
- Spesso **collassabile** (bottone per stringere e mostrare solo le icone)

> ✏️ **"Sidebar nav 240px collassabile, sezioni raggruppate, icona + label per voce, voce attiva con sfondo accentato."*

### Breadcrumb — *la traccia "sei qui"*

Il **breadcrumb** è quella riga che vedi tipo: *"Home > Categoria > Sottocategoria > Pagina attuale"*. Aiuta l'utente a capire dove si trova nella gerarchia del sito, e a tornare indietro velocemente.

L'origine del nome: *"breadcrumb"* in inglese sono le briciole di pane, come Hansel e Gretel.

> ✏️ **"Breadcrumb in cima al main content, separatore '>' tra livelli, ultimo livello non cliccabile."*

### Tab — *linguette per cambiare contenuto*

I **tab** sono linguette che ti permettono di cambiare contenuto senza ricaricare la pagina. Ne vedi sempre nelle pagine prodotto (Descrizione / Caratteristiche / Recensioni).

> ✏️ **"Tabs orizzontali con 3 sezioni — Info, Foto, Recensioni — bordo sottostante per il tab attivo."*

### Stepper — *indicatore di avanzamento*

Lo **stepper** mostra a che punto sei in un processo multi-step. Tipico dei checkout (carrello → spedizione → pagamento → conferma) o di onboarding lunghi.

> ✏️ **"Stepper a 4 step orizzontale, step completati con check verde, step attivo con sfondo accentato, step futuri grigi."*

### Pagination — *navigazione pagine*

La **pagination** è la classica `« 1 2 3 ... 10 »` che vedi sotto le liste lunghe. Permette di sfogliare risultati a blocchi.

> ✏️ **"Pagination sotto la lista prodotti, 12 per pagina, frecce avanti/indietro + numeri, pagina attiva con sfondo nero."*

### Hamburger menu — *l'icona delle 3 linee mobile*

L'**hamburger** è l'icona ☰ (tre linee orizzontali) che si vede nelle pagine mobile. Cliccandola, si apre un menu (di solito un **drawer** che entra dal lato).

Si chiama "hamburger" perché ricorda un panino visto di lato (le 3 linee = pane / hamburger / pane).

> ✏️ **"Hamburger menu icon a destra, al click apre un drawer dal lato sinistro con i link di navigazione."*

### Cosa ti porti via

1. Sette componenti di navigazione: **navbar, sidebar nav, breadcrumb, tab, stepper, pagination, hamburger menu**.
2. Ognuno ha un suo **uso tipico**. Non sono intercambiabili.
3. Conoscerli ti permette di **descriverli con precisione** invece di "una cosa che permette di…".

---

## 3.3 — Componenti di contenuto

> *🎨 Infografica 12: Componenti di contenuto.*

I **componenti di contenuto** sono i "blocchi" che riempiono il main content. Sono i mattoni della pagina.

### Hero — *la prima impressione*

L'**hero** è il blocco grande in alto, sopra la "fold" (la prima schermata visibile senza scrollare). Tipicamente contiene:

- Un **titolo grosso** (h1)
- Un **sottotitolo** descrittivo
- Una o due **CTA** (call to action — bottoni)
- Un'**immagine di sfondo** o illustrazione

L'hero è la **prima impressione** del sito. Investirci tempo è giustificato.

> ✏️ **"Hero a piena larghezza con titolo h1 di 4 righe, sottotitolo, due CTA (primaria + secondaria), immagine illustrativa a destra."*

### Card — *riquadro autocontenuto*

Una **card** è un riquadro con dentro un'unità di contenuto: un prodotto, un articolo, un profilo. Tipicamente ha:

- Un'**immagine** o icona in alto
- Un **titolo**
- Una **descrizione breve**
- Una **CTA** (bottone, link, prezzo)

> ✏️ **"Card prodotto: immagine 4:3, titolo 1-2 righe, prezzo grosso, badge promo se in offerta, bottone 'Aggiungi al carrello'."*

### Banner — *barra di avviso*

Il **banner** è una barra orizzontale stretta che notifica qualcosa: una promozione, un avviso cookie, un messaggio importante. Si vede tipicamente in cima alla pagina o sopra un blocco.

> ✏️ **"Banner di avviso giallo in cima alla pagina, dismissibile con X, testo 'Spedizione gratuita per ordini sopra 50€'."*

### List — *lista verticale di elementi*

Una **list** è la classica lista uno sotto l'altro. Email in Gmail, conversazioni in WhatsApp, todo in un to-do app.

> ✏️ **"Lista email con avatar mittente, oggetto in bold, anteprima testo, timestamp a destra. Riga selezionata sfondo accentato."*

### Grid — *griglia di card*

Un **grid** è una griglia di elementi (di solito card). 2 colonne, 3, 4 — dipende dallo spazio. Su mobile collassa in single column.

> ✏️ **"Grid prodotti: 4 colonne desktop, 2 tablet, 1 mobile. Gap di 24px tra le card."*

### Carousel — *slider di immagini scorrevoli*

Il **carousel** (o slider) è un blocco che mostra immagini/elementi scorrevoli con frecce o gesto swipe. Tipico delle homepage con "promozioni" o "best seller".

> 💡 Attenzione: i carousel sono **odiati dagli UX designer** (gli utenti vedono solo la prima slide). Se Claude te ne propone uno, valuta se non sia meglio una grid statica.

> ✏️ **"Carousel con 5 slide, autoplay 4 secondi, frecce di navigazione + dot indicator, pause on hover."*

### Accordion — *sezione espandibile*

L'**accordion** è una sezione che si espande/chiude al click. Tipico delle pagine FAQ. Si chiama così perché ricorda la fisarmonica.

> ✏️ **"Accordion FAQ con 6 domande. Click espande la risposta, chiude le altre. Icona + che ruota a × quando aperto."*

### Table — *tabella di dati*

La **table** è la classica tabella con righe e colonne. Tipica delle dashboard, pagine dati, prezziari.

> ✏️ **"Tabella ordini: colonne Data, Cliente, Importo, Stato, Azioni. Header sticky in scroll, righe alternate (zebra), filtro per colonna."*

### Cosa ti porti via

1. Otto componenti di contenuto: **hero, card, banner, list, grid, carousel, accordion, table**.
2. Sono i **mattoni** che riempiono il main content.
3. Sapere quale usare quando ti permette di chiedere a Claude la cosa giusta. *"Una grid di card prodotto"* è infinite volte meglio di *"un blocco con dentro le cose"*.

---

## 3.4 — Componenti di interazione

> *🎨 Infografica 13: Componenti di interazione.*

I **componenti di interazione** sono quelli con cui l'utente fa qualcosa. Cliccare, digitare, confermare, aprire e chiudere.

### Modal — *finestra popup centrale*

Un **modal** (o "dialog") è una finestra che appare **sopra** la pagina, con uno sfondo scuro semitrasparente dietro (l'**overlay**). Bloccante: l'utente deve interagirci prima di tornare alla pagina.

Tipici: conferma di una cancellazione, login form, fotografia ingrandita.

> ✏️ **"Modal di conferma per eliminare un cliente: testo 'Sei sicuro? Questa azione è irreversibile', bottoni Annulla (ghost) e Elimina (rosso)."*

### Drawer — *pannello che esce dal lato*

Un **drawer** è un pannello che entra **dal bordo** dello schermo (sinistra, destra, alto, basso). Tipico:
- Menu mobile (entra da sinistra)
- Filtri sidebar mobile (entra da destra)
- Carrello rapido (entra da destra)
- Action sheet iOS (entra dal basso)

> ✏️ **"Drawer mobile dal basso con scorciatoie alle azioni primarie, dismissibile col swipe down."*

### Toast / Snackbar — *notifica temporanea*

Un **toast** (o snackbar — termine Material Design) è una **notifica piccola e temporanea** che appare in un angolo dello schermo, e sparisce dopo qualche secondo.

Tipico: feedback dopo un'azione ("Salvato!", "Errore di connessione", "Profilo aggiornato").

> ✏️ **"Toast in basso a destra dopo il submit. Verde con icona check per success, rosso per error. Auto-dismiss dopo 4 secondi, hover pause."*

### Tooltip — *bubble che appare al hover*

Il **tooltip** è quel piccolo box di testo che appare quando passi il mouse sopra un elemento. Tipicamente spiega cosa fa un bottone con icona, o dà context aggiuntivo.

> ✏️ **"Tooltip sull'icona info-circle nel form. Al hover mostra 'I dati personali sono usati solo per la fatturazione, non vengono condivisi'."*

### Dropdown — *menu a tendina*

Il **dropdown** è il menu che si apre **al click** su un elemento. Diverso dal tooltip (che è solo lettura) — il dropdown ha **opzioni cliccabili**.

Tipico: select del paese, menu utente in alto a destra, "Azioni" su una riga di tabella.

> ✏️ **"Dropdown 'Account' nell'header. Al click mostra Profilo, Impostazioni, divisore, Logout (rosso)."*

### Form / Input / Checkbox / Radio / Select / Slider / Toggle / Datepicker

I **form** sono il modo principale con cui l'utente inserisce dati. Otto tipi di input principali:

- **Input text**: testo libero (nome, email, password)
- **Textarea**: testo multilinea (commento, descrizione lunga)
- **Checkbox**: opzioni multiple selezionabili (es. "Voglio ricevere offerte")
- **Radio**: opzioni mutuamente esclusive (es. "Spedizione: standard / express")
- **Select** (dropdown): scelta da una lista (es. "Paese: Italia, Germania...")
- **Slider**: valore in un range (es. "Prezzo: 0€ — 200€")
- **Toggle** (o switch): on/off (es. "Notifiche: attive")
- **Datepicker**: scelta data dal calendario

> ✏️ **"Form registrazione: input email, input password con toggle show/hide, checkbox 'Accetto i termini' (obbligatorio), bottone primary 'Crea account'."*

### Button — *il bottone, cuore dell'interazione*

I **button** non sono tutti uguali. Esistono varianti:

- **Primary**: l'azione principale (es. "Acquista"). Sfondo pieno, colore brand.
- **Secondary**: azione secondaria (es. "Annulla"). Sfondo neutro o trasparente con bordo.
- **Ghost**: solo testo, niente bordo (per azioni terziarie)
- **Icon-only**: bottone con solo icona (es. ❤️ "aggiungi ai preferiti")
- **Destructive**: azione distruttiva (es. "Elimina"). Sfondo o testo rosso.

> ✏️ **"Bottone primario 'Conferma ordine' con icona freccia destra. Bottone ghost 'Modifica' a fianco."*

### Badge / Chip / Tag — *etichette colorate*

**Badge**, **chip** e **tag** sono piccoli elementi colorati che marcano qualcosa:
- **Badge**: numero piccolo (es. "3" sull'icona del carrello)
- **Chip**: etichetta interattiva, spesso con X per rimuoverla (es. tag selezionati nei filtri)
- **Tag**: etichetta di categoria (es. "Lavoro", "Famiglia" sui contatti)

> ✏️ **"Chip per ogni filtro selezionato (es. 'Marca: Nike'), con X per rimuoverlo. Click su 'Cancella tutti' azzera la lista."*

### Cosa ti porti via

1. Tre famiglie di componenti interattivi: **finestre overlay** (modal, drawer, tooltip, dropdown), **input form** (8 tipi), **azioni** (button, badge/chip/tag).
2. Ognuno ha **un nome preciso** che, usato nel prompt, dice a Claude esattamente cosa generare.
3. La differenza tra "modal" e "drawer" sembra sottile ma cambia tutto: modal è centrale e blocca tutta la pagina, drawer entra dal bordo. Confonderli porta Claude a generare la cosa sbagliata.

---

## 3.5 — Stati e feedback visivi

> *🎨 Infografica 14: Stati di un componente.*

L'ultimo capitolo del modulo, e uno dei più sottovalutati. **Ogni componente non è una cosa sola**: ha **più stati** in cui si può trovare. Un bottone non è "il bottone" — è 8 cose diverse a seconda di cosa sta succedendo.

Capire questo punto separa interfacce **mediocri** (dove ogni stato è gestito a caso) da interfacce **professionali** (dove ogni stato è curato).

### Stati di un bottone (8 stati)

Lo stesso bottone può essere in:

1. **Idle / Default** — neutro, nessuna interazione
2. **Hover** — il mouse ci passa sopra
3. **Focus** — è selezionato da tastiera (TAB) o cliccato senza ancora rilasciare
4. **Active** — è premuto in questo istante
5. **Disabled** — grigiato, non cliccabile (es. "Submit" disattivato finché il form non è valido)
6. **Loading** — sta facendo qualcosa (compare uno spinner dentro)
7. **Success** — l'azione è andata a buon fine (icona ✓ verde)
8. **Error** — l'azione è fallita (icona ✕ rossa)

Otto stati. Otto resa visiva diversa. Quando chiedi a Claude "fai un bottone", senza specificare gli stati, lui ne fa uno o due e lascia il resto al caso.

> ✏️ **"Bottone 'Salva': stato disabled finché il form non è valido. Stato loading durante l'invio (spinner + testo 'Salvataggio...'). Stato success con check verde 2 secondi. Stato error con bordo rosso e toast errore."*

### Stati di un input form

Un input testo ha anche lui i suoi stati:

- **Idle**: vuoto, in attesa
- **Focus**: il cursore è dentro
- **Filled**: ha del testo dentro
- **Error**: bordo rosso + messaggio sotto ("Email non valida")
- **Disabled**: grigiato
- **Read-only**: leggibile ma non modificabile

> ✏️ **"Input email: bordo grigio idle, blu in focus, rosso in error con messaggio sotto, sfondo grigio in disabled."*

### Stati a livello di contenuto (page-level)

Spostiamoci da componenti singoli a **interi blocchi di contenuto**. Una lista può trovarsi in molti stati:

#### Empty state — *lista vuota*

Quando la lista non ha elementi (es. nessun prodotto, nessun ordine), **non lasciare uno spazio vuoto**. Mostra un **empty state**: un messaggio chiaro + CTA per fare qualcosa.

Esempio: "Non hai ancora ordini. **Inizia a comprare** →"

> ✏️ **"Empty state della lista cantieri quando l'utente non ha ancora cantieri: illustrazione, frase 'Crea il tuo primo cantiere', bottone primario 'Nuovo cantiere'."*

#### Loading state — *durante il caricamento*

Quando la pagina sta caricando dati, **non lasciare lo schermo bianco**. Mostra qualcosa che dice "sto lavorando".

Due opzioni principali:
- **Spinner**: un'icona rotante (semplice, comune)
- **Skeleton loader**: dei rettangoli grigi che simulano la forma del contenuto in arrivo (più moderno, più rassicurante)

Lo skeleton loader oggi è preferito: dà all'utente l'impressione che il contenuto stia "comparendo", non "caricando da zero".

> ✏️ **"Skeleton loader per la lista prodotti durante il fetch: 6 rettangoli grigi con la forma di una card, animazione di pulsazione."*

#### Error state — *qualcosa è andato storto*

Quando una richiesta fallisce, **non lasciare l'utente al buio**. Mostra un **error state** con:
- Cosa è successo (in linguaggio chiaro, non "ERROR_500")
- Cosa può fare (riprova, contatta supporto, ecc.)

> ✏️ **"Error state quando fallisce il fetch: icona warning, frase 'Non sono riuscito a caricare i prodotti', bottone 'Riprova'."*

### Disabled / hover / focus a livello pagina

Anche il **layout** può avere stati. Quando un modal è aperto, lo sfondo dietro è "disabled" (overlay scuro, non cliccabile). Quando un elemento ha focus tastiera, c'è un anello visibile attorno (importante per accessibilità).

> ✏️ **"Outline ring blu su tutti gli elementi focusabili (button, input, link). 2px solid, offset 2px, non rimuovere mai per estetica."*

### Cosa ti porti via

1. **Ogni componente ha più stati**. Un bottone è 8 cose diverse.
2. Gli stati a livello di pagina più importanti: **empty state, loading state, error state**. Mai lasciare lo schermo bianco o senza feedback.
3. Lo **skeleton loader** è preferibile allo spinner per loading lunghi (>1 secondo).
4. Quando chiedi a Claude un componente, **descrivi anche i suoi stati**. Da "fai un form" a "fai un form con input idle, focus, error, e bottone con stati disabled e loading".

---

## Chiusura del Modulo 3

Adesso hai un **lessico** di circa 50 termini per parlare di interfacce con precisione. Sono i mattoni che ogni vibecoder deve conoscere.

Dalla prossima volta che apri Claude:

- Non scrivere *"un menu che esce"*. Scrivi **"un drawer mobile dal basso con i link principali"**.
- Non scrivere *"una scritta di conferma"*. Scrivi **"un toast verde in basso a destra con testo 'Salvato' che sparisce dopo 4 secondi"**.
- Non scrivere *"un blocco con la roba"*. Scrivi **"una grid di card 3 colonne desktop, 1 colonna mobile, ogni card con immagine 4:3, titolo, prezzo, bottone aggiungi al carrello"**.

Ogni precisione che aggiungi al prompt riduce le iterazioni. È matematica.

Nel **Modulo 4** scendiamo nel tecnico del frontend: HTML, CSS, JavaScript, React, Server Components vs Client Components in Next.js. Ma se questo modulo l'hai assorbito, il resto del libro va in discesa.

---

## 🎯 Mini-quiz di autovalutazione

**1. Differenza in una frase tra modal e drawer.**

**2. Hai una pagina con la lista prodotti che inizialmente è vuota perché l'utente è nuovo. Cosa metti al posto della lista vuota?**

**3. Lo "skeleton loader" è preferito allo "spinner" perché…**

**4. Vuoi che l'utente, prima di confermare un'azione distruttiva (eliminare un cantiere), debba dare conferma. Quale componente usi?**

**5. Vero o falso: il termine corretto per la barra orizzontale in alto con logo e link è "navbar".**

---

### Risposte

1. Il **modal** è una finestra che appare al **centro** della pagina con overlay scuro dietro, e blocca l'interazione col resto. Il **drawer** è un pannello che entra **dal bordo** (lato/alto/basso) della pagina, e tipicamente non blocca tutto.

2. Un **empty state**: illustrazione + frase chiara ("Non hai ancora prodotti") + CTA per agire ("Crea il tuo primo prodotto").

3. …è **più moderno e rassicurante**: simula la forma del contenuto che sta arrivando, dando l'impressione di "completamento" piuttosto che "attesa". Ottimo per loading >1 secondo.

4. Un **modal di conferma**: testo chiaro ("Sei sicuro?"), bottone Annulla (ghost) e bottone Elimina (destructive, rosso).

5. **Vero**. La barra orizzontale in alto si chiama **navbar** (o navigation bar). Tecnicamente l'header è il blocco contenitore, la navbar è la barra di link dentro.

---

> Se sei arrivato fin qui hai assorbito il **lessico operativo** del web. Da qui in poi tutto è applicazione. **Stampa l'infografica 10** e tienila accanto al PC quando lavori — è il riferimento che useai più di tutti.

---

*Modulo 3 redatto: 2026-04-25 · Versione 1.0 · ~22 pagine · ~5400 parole*
