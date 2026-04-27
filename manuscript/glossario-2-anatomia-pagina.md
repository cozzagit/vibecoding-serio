# Glossario 2 — Anatomia di una pagina web

> ~50 termini · 14 pagine · Riferimento rapido per UI/UX
>
> Per ogni voce: nome italiano + inglese · come si disegna · uno-due esempi · prompt-ready per Claude (quando applicabile).
> Organizzato per zona della pagina. Da stampare e tenere accanto al PC.

---

## A. Layout (5 termini)

**Header** *(intestazione)*
La fascia in cima alla pagina. Contiene logo, nav, CTA. Spesso sticky.
↳ *"Header sticky con logo a sinistra, nav centrale, CTA primary a destra."*

**Footer** *(piè di pagina)*
La fascia in fondo. Link legali, social, copyright, eventuali contatti.
↳ *"Footer 3 colonne: contatti, link rapidi, newsletter."*

**Main** *(contenuto principale)*
Il cuore della pagina, l'area che cambia tra una pagina e l'altra. Tag HTML `<main>`.

**Sidebar** *(barra laterale)*
Colonna laterale (destra o sinistra). Tipica nelle dashboard. Su mobile spesso sparisce o diventa drawer.
↳ *"Sidebar 280px sticky a sinistra, collassabile su mobile in hamburger drawer."*

**Navigation (nav)** *(navigazione)*
Insieme dei link principali del sito. Può essere dentro l'header o separata.

---

## B. Navigazione (8 termini)

**Navbar** *(barra di navigazione)*
Barra orizzontale con logo + link + CTA. Tipica posizione: dentro l'header.
↳ *"Navbar con 4 link orizzontali, dropdown 'Servizi' a tendina, hamburger su mobile."*

**Sidebar nav** *(navigazione laterale)*
Barra verticale con icone + label. Tipica delle dashboard SaaS.
↳ *"Sidebar nav 240px collassabile, sezioni raggruppate, icona + label."*

**Breadcrumb** *(briciole di pane)*
Traccia "sei qui": `Home > Categoria > Sotto > Pagina`.
↳ *"Breadcrumb in cima al main, separatore '>', ultimo livello non cliccabile."*

**Tab** *(linguette)*
Linguette che cambiano contenuto senza ricaricare la pagina. Tipico delle pagine prodotto.
↳ *"Tabs orizzontali con 3 sezioni — Info, Foto, Recensioni — bordo sotto la tab attiva."*

**Stepper** *(indicatore di avanzamento)*
Mostra a che punto sei in un processo multi-step (checkout, onboarding).
↳ *"Stepper orizzontale a 4 step: completati con check, attivo con sfondo accent, futuri grigi."*

**Pagination** *(paginazione)*
Navigazione tra pagine: `« 1 2 3 ... 10 »`. Sotto liste lunghe.
↳ *"Pagination con frecce + numeri + ellisse per pagine intermedie. 10 risultati per pagina."*

**Hamburger menu** *(menu a panino)*
Icona ☰ (3 linee orizzontali) tipica mobile. Al click apre un drawer di nav.
↳ *"Hamburger su mobile, click apre drawer dal lato sinistro."*

**Anchor link** *(link interno)*
Link che porta a una sezione della stessa pagina (`#sezione`).
↳ *"Anchor link 'Vai ai prezzi' che porta alla sezione `#pricing` con scroll smooth."*

---

## C. Contenuto (12 termini)

**Hero** *(sezione di apertura)*
Banda alta sopra la fold. Titolo, sottotitolo, CTA, immagine. La prima impressione.
↳ *"Hero a piena larghezza con h1 grosso, sottotitolo, due CTA (primary + secondary), illustrazione a destra."*

**Card** *(carta, riquadro)*
Riquadro autocontenuto: immagine + titolo + descrizione + CTA. Mattone delle pagine moderne.
↳ *"Card prodotto: immagine 4:3, titolo, prezzo grande, badge promo, bottone 'Aggiungi'."*

**Banner** *(insegna, avviso)*
Barra orizzontale stretta con avviso o promozione. Spesso dismissibile.
↳ *"Banner giallo in cima 'Spedizione gratuita sopra 50€', dismissibile con X."*

**List** *(elenco)*
Lista verticale di elementi simili. Email, conversazioni, todo.

**Grid** *(griglia)*
Griglia 2D di elementi (di solito card). 4 colonne desktop → 1 mobile.
↳ *"Grid prodotti 4 col desktop, 2 tablet, 1 mobile, gap 24px."*

**Carousel / Slider** *(carosello)*
Elementi scorrevoli con frecce o swipe. Dot indicator sotto.
↳ *"Carousel hero con 5 slide, autoplay 4s, frecce + dots, pause on hover."*

**Accordion** *(fisarmonica)*
Sezioni espandibili al click. Tipico delle FAQ.
↳ *"Accordion FAQ con 6 domande. Click espande la risposta, chiude le altre."*

**Table** *(tabella)*
Dati in righe e colonne. Header sticky in scroll.
↳ *"Tabella ordini: colonne Data, Cliente, Importo, Stato, Azioni. Header sticky, righe zebra."*

**Gallery** *(galleria)*
Collezione di immagini. Spesso con lightbox per zoom.
↳ *"Gallery con 12 immagini in grid 3 colonne, click apre lightbox a piena pagina."*

**Embed**
Contenuto incorporato da altro sito (video YouTube, mappa Google, tweet).

**Blockquote** *(citazione)*
Citazione visivamente distinta. Tag HTML `<blockquote>`.

**Divider** *(divisore)*
Linea orizzontale o verticale che separa sezioni.

---

## D. Interazione (15 termini)

**Modal** *(finestra modale)*
Finestra centrale con overlay scuro dietro. Bloccante: devi interagire prima di tornare.
↳ *"Modal di conferma 'Sei sicuro?', bottoni Annulla (ghost) + Elimina (destructive)."*

**Drawer** *(cassetto)*
Pannello che entra dal bordo (lato/alto/basso). Tipicamente non bloccante.
↳ *"Drawer dal basso su mobile per il menu, dismissibile con swipe down."*

**Popover**
Pannello al click su un elemento. Diverso da tooltip (al hover) — il popover può contenere bottoni interattivi.

**Tooltip** *(suggerimento)*
Bubble di testo al hover. Solo informativo, non interattivo.
↳ *"Tooltip sull'icona 'i' che spiega cosa fa il filtro."*

**Dropdown** *(menu a tendina)*
Menu che si apre al click, con opzioni cliccabili.
↳ *"Dropdown 'Account' nell'header con Profilo, Settings, divisore, Logout (rosso)."*

**Button** *(bottone)*
Elemento cliccabile per azioni. Varianti: primary, secondary, ghost, destructive, icon-only.
↳ *"Bottone primary 'Salva' + bottone ghost 'Annulla' affianco."*

**Link**
Elemento testuale cliccabile per navigazione. Tag `<a href>`.

**Form** *(modulo)*
Insieme di campi per inserire dati. Submit invia al server.

**Input** *(campo di input)*
Singolo campo del form. Tipo testo, numero, password, email, ecc.

**Checkbox** *(casella)*
Casella ☐/☑ per opzioni multiple selezionabili.

**Radio** *(scelta esclusiva)*
Cerchi ⚪/🔘 per opzioni mutuamente esclusive.

**Select** *(menu a tendina di scelta)*
Input che permette di scegliere un valore da una lista. Diverso da dropdown (che è di azioni).

**Slider** *(cursore)*
Cursore per scegliere un valore in un range (es. prezzo 0-200€).

**Toggle** *(interruttore)*
Switch on/off. Tipico delle settings.

**Datepicker** *(selettore data)*
Calendario per scegliere una data.

---

## E. Feedback (8 termini)

**Toast / Snackbar** *(notifica temporanea)*
Notifica piccola in un angolo, auto-dismiss dopo qualche secondo.
↳ *"Toast verde in basso a destra dopo submit: 'Salvato', auto-dismiss 4s."*

**Alert** *(avviso)*
Avviso visivamente forte (banner persistente o popup) per messaggi importanti.

**Progress bar** *(barra di avanzamento)*
Barra che mostra avanzamento di un processo. Determinato (% nota) o indeterminato.

**Spinner**
Icona rotante per indicare "sto caricando". Generico.

**Skeleton loader** *(scheletro di caricamento)*
Placeholder grigio che simula la forma del contenuto in arrivo. Più moderno e rassicurante dello spinner.
↳ *"Skeleton loader durante il fetch dei prodotti: 6 rettangoli grigi a forma di card."*

**Empty state** *(stato vuoto)*
Schermata mostrata quando una lista non ha contenuto. Illustrazione + messaggio + CTA.
↳ *"Empty state lista cantieri: illustrazione, frase 'Crea il tuo primo cantiere', bottone 'Nuovo cantiere'."*

**Error state** *(stato di errore)*
Schermata mostrata quando una richiesta fallisce. Messaggio chiaro + pulsante "Riprova".

**Success state** *(stato di successo)*
Conferma visiva dopo operazione riuscita. Icona verde, messaggio, eventuale "Vai avanti".

---

## F. Tipografia e elementi fini (5 termini)

**Heading (h1-h6)** *(titolo)*
Titoli gerarchici. h1 = principale (uno solo per pagina), h2 = sezione, h3 = sottosezione, ecc.

**Paragraph (p)** *(paragrafo)*
Blocco di testo normale.

**List (ul/ol/li)** *(lista)*
Lista non ordinata (`<ul>` con bullet) o ordinata (`<ol>` con numeri). Item con `<li>`.

**Badge / Chip / Tag** *(etichetta)*
Piccolo elemento colorato. Badge = numero piccolo (es. notifiche carrello). Chip = tag interattivo con X. Tag = etichetta di categoria.
↳ *"Badge rosso con numero notifiche sull'icona campanella."*

**Avatar**
Immagine profilo circolare. Fallback con iniziali se manca la foto.
↳ *"Avatar 40px con iniziali su sfondo accent se la foto manca."*

---

## ✏️ Bonus: come trasformare in prompt prompt-ready

Per ogni termine, il pattern del prompt ben fatto è:

> *"[componente] [posizione/dimensione] [contenuto] [comportamento] [responsive] [stati]"*

Esempio applicato:

> *"Card prodotto (componente) in grid 3 col desktop, 1 mobile (posizione/dimensione), con immagine 4:3, titolo, prezzo, bottone 'Aggiungi' (contenuto). Hover scale 1.02 (comportamento). Card vuota mostra skeleton loader (stato)."*

Lungo? Sì. Ma è codice production-ready alla prima iterazione.

---

*Glossario 2 redatto: 2026-04-25 · Versione 1.0 · 50 termini in 6 categorie.*
