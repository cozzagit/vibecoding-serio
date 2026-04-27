# Modulo 4 — Il browser è stupido (ma fa tutto lui)

> 5 capitoli · 18 pagine · 1 ora 10 minuti
> Pre-requisiti: Modulo 2 letto. Sai distinguere client da server, conosci HTML/CSS/JS come parole.

---

## Mettiti comodo

Adesso scendiamo nel tecnico del **frontend**. Non per farti scrivere codice da zero — ma per farti **riconoscere** quello che Claude scrive, capire perché lo scrive così, e parlare con cognizione di causa.

Il browser è lo strumento più diffuso della storia dell'informatica, e fa molto più di quanto sembri. Ma è anche, in un certo senso, **stupido per design**: non si fida di niente, applica regole rigide, fa il minimo indispensabile da solo. Capirne il funzionamento ti permette di capire perché certe cose nei tuoi siti vanno e altre no.

Cinque capitoli:

1. HTML in 30 minuti — i tag con significato e perché contano
2. CSS responsive senza piangere — flexbox, grid, mobile-first
3. JavaScript: aggiornare vs ricaricare — la differenza tra SPA e MPA
4. Il DOM e React — cosa Claude tocca quando modifica la UI
5. Server Components vs Client Components — il concetto chiave di Next.js 14+

Andiamo.

---

## 4.1 — HTML in 30 minuti: i tag con significato

### Perché HTML conta più di quanto sembri

L'HTML è il linguaggio più antico del web, e quasi tutti pensano sia banale: *"sono solo tag"*. Sbagliato. **HTML scritto bene** vs **HTML scritto male** è la differenza tra un sito accessibile, performante, indicizzato da Google, e un sito che fatica a essere letto.

Quando Claude ti scrive una pagina, sceglie i tag in modo specifico. Vediamo perché.

### Tag con significato vs `<div>` puro

Confronta questi due pezzi di codice. Fanno apparentemente la stessa cosa: una pagina con titolo, contenuto, link, pulsante.

**Versione cattiva** (full `<div>`):

```html
<div>
  <div>Vibecoding Serio</div>
  <div>
    <div>Capitolo 1</div>
    <div>Cosa è il vibecoding...</div>
  </div>
  <div>
    <div onclick="acquista()">Compra</div>
  </div>
</div>
```

**Versione buona** (tag semantici):

```html
<header>
  <h1>Vibecoding Serio</h1>
</header>
<main>
  <article>
    <h2>Capitolo 1</h2>
    <p>Cosa è il vibecoding...</p>
  </article>
  <button onclick="acquista()">Compra</button>
</main>
```

Visivamente identico. Ma **per il browser, per gli screen reader, per Google, per gli script di accessibilità** — completamente diverso.

### I tag che contano davvero

Non hai bisogno di sapere tutti i 100 tag HTML. Te ne servono **15** ben usati:

**Struttura della pagina** (li hai già visti nel Modulo 3):
- `<header>` · `<nav>` · `<main>` · `<aside>` (sidebar) · `<footer>`

**Contenuto**:
- `<h1>` ... `<h6>` — titoli (h1 = il principale, uno solo per pagina)
- `<p>` — paragrafo di testo
- `<article>` — un pezzo di contenuto autonomo (post blog, articolo, prodotto)
- `<section>` — una sezione tematica della pagina
- `<ul>` / `<ol>` / `<li>` — liste non ordinate / ordinate / item

**Interazione**:
- `<button>` — un bottone cliccabile
- `<a href="...">` — un link
- `<form>` / `<input>` / `<label>` — form, campo di input, etichetta
- `<img src="..." alt="...">` — immagine (l'`alt` è obbligatorio per accessibilità)

### L'attributo `alt`: una piccola cosa che vale tanto

Una nota su `<img>`. Quando Claude scrive un'immagine, dovrebbe sempre includere l'attributo `alt`:

```html
<img src="cantiere.jpg" alt="Operai al lavoro su una facciata di palazzo">
```

L'`alt`:
- È letto agli **screen reader** (utenti non vedenti)
- Appare se l'immagine **non si carica**
- È letto da **Google** per indicizzazione

Se Claude te lo dimentica (succede), aggiungilo a mano. Costa zero, vale tanto.

### Accessibilità in un paragrafo

L'**accessibilità** (a11y, in gergo) significa che il sito è usabile anche da persone con disabilità (vista, motorie, cognitive). Le best practice base sono tutte gratis:

- Usa tag semantici (`<button>` invece di `<div onclick>`)
- Aggiungi `alt` a tutte le immagini
- Usa `<label>` per gli input (così il click sull'etichetta porta nel campo)
- Garantisci buon contrasto colori (testo nero su sfondo scuro = no)
- Non rimuovere mai l'**outline focus** del browser per estetica (è la riga blu che vedi attorno agli elementi quando navighi con TAB)

Quando chiedi a Claude un componente, **specifica "accessibile" nel prompt**. Lui sa cosa vuol dire e generalmente lo rispetta.

> ✏️ **Prompt-ready**: *"Form di registrazione accessibile: ogni input con label associata, aria-label sui bottoni icon-only, focus visibile, errori dichiarati con aria-live."*

### Cosa ti porti via

1. **Tag con significato** (`<header>`, `<button>`, `<article>`) sono meglio dei `<div>` puri. Lo capiscono il browser, gli screen reader, Google.
2. Ti bastano **~15 tag** per coprire il 95% dei casi.
3. **`alt` sulle immagini** è obbligatorio. Non saltarlo.
4. **Accessibilità** non è un extra: è quello che separa siti professionali da siti amatoriali. Specificalo nei prompt.

---

## 4.2 — CSS: layout responsive senza piangere

### Il box model in 30 secondi

Ogni elemento HTML è una **scatola rettangolare** composta da 4 strati concentrici, dall'interno verso l'esterno:

1. **Content** — il contenuto vero (testo, immagine)
2. **Padding** — spazio interno tra contenuto e bordo
3. **Border** — il bordo
4. **Margin** — spazio esterno verso gli altri elementi

```
┌─────────────────────────────┐  ← margin
│  ┌───────────────────────┐  │  ← border
│  │  ┌─────────────────┐  │  │  ← padding
│  │  │   contenuto     │  │  │
│  │  └─────────────────┘  │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

Quando Claude scrive `padding: 16px` sta dicendo "16 pixel di spazio interno". Quando scrive `margin-top: 24px` sta dicendo "24 pixel di spazio sopra l'elemento".

Conoscere queste 4 parole ti permette di chiedere modifiche precise: *"aumenta il padding interno della card a 24px"* invece di *"fai più aria nel box"*.

### Flexbox vs Grid: la metafora del bancomat

Le due tecnologie principali per fare layout in CSS sono **Flexbox** e **CSS Grid**. Servono entrambe ma a cose diverse.

**Flexbox** è perfetto per **una fila**. Una riga, una colonna. Pensa al **bancomat con la fila di persone** — tutti incolonnati uno dietro l'altro, possono distribuirsi nello spazio disponibile.

```css
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
```

Risultato: gli elementi della navbar in fila orizzontale, distanziati uniformemente, allineati verticalmente al centro.

**CSS Grid** è perfetto per **una griglia 2D**. Pensa alla **griglia di sportelli del bancomat** — colonne e righe insieme.

```css
.product-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}
```

Risultato: una griglia di 3 colonne uguali con 24px di gap tra ogni cella.

> 💡 **Regola pratica**: Flexbox per **navbar, footer row, lista pulsanti, single column**. Grid per **layout di pagina, griglie di card, dashboard**.

Se Claude ti propone Grid per una navbar, qualcosa è strano (stai facendo overengineering). Se ti propone Flexbox per un dashboard complesso, magari sta semplificando troppo.

### Mobile-first: l'unica strategia che funziona

**Mobile-first** significa: progetta prima per mobile (schermo piccolo), poi aggiungi regole per schermi più grandi. Non viceversa.

Perché? Tre motivi:
1. La maggior parte degli utenti naviga da mobile (60-80% del traffico)
2. Vincolare lo schermo piccolo prima evita layout che funzionano solo su desktop
3. È più facile **espandere** un layout semplice che **comprimere** un layout complesso

Esempio pratico in CSS, con **media query**:

```css
/* Mobile (default) */
.container {
  display: block;
  padding: 16px;
}

/* Tablet (≥768px) */
@media (min-width: 768px) {
  .container {
    display: flex;
    padding: 24px;
  }
}

/* Desktop (≥1024px) */
@media (min-width: 1024px) {
  .container {
    max-width: 1200px;
    margin: 0 auto;
  }
}
```

Tradotto: di default lo stile è mobile (block, 16px padding). A 768px (tablet) attiviamo il flex e aumentiamo il padding. A 1024px (desktop) limitiamo la larghezza.

> ✏️ **Prompt-ready**: *"Layout responsive mobile-first: 1 colonna mobile, 2 colonne tablet (≥768px), 4 colonne desktop (≥1024px). Gap di 16px mobile, 24px desktop."*

### Tailwind: il modo moderno di scrivere CSS

Quasi tutti i siti che Claude genera oggi usano **Tailwind CSS**. Invece di scrivere blocchi CSS in un file separato, scrivi **classi nel tag HTML**.

CSS classico:
```html
<button class="cta">Compra</button>

<style>
.cta {
  background: #2563EB;
  color: white;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 600;
}
</style>
```

Tailwind:
```html
<button class="bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold">
  Compra
</button>
```

Stesso risultato. Tailwind è **più verboso nell'HTML** ma elimina il file CSS separato e lo "switching cognitivo" (devi tenere a mente solo l'HTML, non due file).

### Cosa ti porti via

1. **Box model** in 4 parole: content / padding / border / margin.
2. **Flexbox** per fila singola, **Grid** per griglie 2D. Flexbox per navbar, Grid per layout pagina.
3. **Mobile-first**: scrivi CSS prima per mobile, poi aggiungi regole per schermi più grandi con `@media`.
4. **Tailwind**: classi inline nell'HTML al posto di file CSS separati. Standard moderno.

---

## 4.3 — JavaScript: la pagina si aggiorna o si ricarica?

### Due paradigmi: MPA e SPA

Quando un utente clicca un link in un sito, succede una di due cose:

**MPA — Multi-Page Application** *(scuola classica)*

Click sul link → il browser fa una **nuova richiesta HTTP completa** → riceve una nuova pagina HTML → la rendera da zero. Sito tipico: WordPress, e-commerce classici, blog.

Pro: semplice, robusto, SEO facile.
Contro: a ogni navigazione la pagina si ricarica completamente (vedi flash bianco).

**SPA — Single-Page Application** *(scuola moderna)*

Click sul link → JavaScript intercetta il click → fa una richiesta solo per i **nuovi dati** (non per HTML completo) → aggiorna **solo il pezzo cambiato** della pagina. La URL nella barra cambia, ma il browser non ricarica. Sito tipico: Gmail, Notion, Linear, Twitter.

Pro: sensazione "app", veloce, fluido.
Contro: più complesso, SEO richiede attenzione, usa più JavaScript.

### "Aggiornare" vs "Ricaricare": parole importanti

Quando spieghi a Claude cosa vuoi, queste due parole sono diverse:

- *"Aggiorna i prodotti quando l'utente cambia filtro"* → **JS modifica il DOM** senza ricarica. Tipico SPA.
- *"Ricarica la pagina dopo il salvataggio"* → **navigazione completa**, full reload. Tipico MPA, o caso particolare in SPA.

Sapere il termine giusto ti permette di descrivere il comportamento in 5 parole.

### Next.js fa entrambi

Ecco la cosa interessante: **Next.js**, e i meta-framework moderni, **fanno entrambe le cose** a seconda del caso. Sono **ibridi**. La prima visita a una pagina è server-rendered (come MPA, buon SEO). Le navigazioni successive interne al sito sono client-side (come SPA, sensazione veloce).

Quando vedi la "tipica app moderna", quasi sempre è questo: **best of both worlds**.

### Il flash bianco: il sintomo del MPA puro

Se sviluppi un sito Next.js / React / Astro e vedi un **flash bianco** tra una pagina e l'altra, qualcosa non va. Probabilmente:
- Stai usando link `<a href="...">` "puri" invece dei componenti `<Link>` di Next.js
- O il framework non sta gestendo bene la navigazione

> ✏️ **Prompt-ready**: *"Navigazione tra pagine senza flash bianco: usare i componenti `<Link>` di Next.js, non i tag `<a>` standard. Mostra spinner inline nella sezione che cambia, non sostituire l'intera pagina."*

### Cosa ti porti via

1. **MPA**: ogni navigazione = ricarica completa della pagina (WordPress).
2. **SPA**: JS aggiorna pezzi senza ricarica (Gmail).
3. **Next.js è ibrido**: server-rendered alla prima visita, SPA-like dopo.
4. Le parole "aggiorna" e "ricarica" hanno significati diversi nel parlare con Claude. Usa la giusta.

---

## 4.4 — Il DOM e React: dove Claude mette le mani

### Il DOM è la pagina "viva"

Quando il browser parsa l'HTML che gli arriva, costruisce in memoria una **rappresentazione viva** della pagina chiamata **DOM** (Document Object Model). Pensa al DOM come a un albero: ogni tag HTML è un nodo, ogni nodo può avere figli.

```
<html>
├── <head>
│   ├── <title>
│   └── <meta>
└── <body>
    ├── <header>
    │   └── <h1>
    └── <main>
        └── <p>
```

Il DOM è **modificabile** in tempo reale. Quando JavaScript dice *"aggiungi una classe a questo elemento"* o *"crea un nuovo paragrafo qui"*, sta modificando il DOM. Il browser **immediatamente** aggiorna la visualizzazione.

```javascript
// Modifica diretta del DOM
document.getElementById('contatore').textContent = '5';
```

### React: il modo moderno di parlare al DOM

Modificare il DOM "a mano" (con `document.getElementById`, `addEventListener`, ecc.) funziona ma diventa **infernale** quando l'app cresce. Per questo è nato React (e simili).

L'idea di React: **non modifichi il DOM direttamente**. Dichiari **com'è la UI in funzione dei dati**, e React si occupa di aggiornare il DOM quando i dati cambiano.

Un esempio:

```jsx
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      Hai cliccato {count} volte
    </button>
  );
}
```

Tradotto: *"Un componente Counter ha un valore `count` che parte da 0. Mostra un bottone con scritto 'Hai cliccato N volte'. Al click, incrementa `count`."*

Tu non scrivi mai *"trova il bottone, cambia il testo a N+1"*. Dichiari come **deve apparire** in funzione del valore, e React fa il lavoro sporco.

### Componenti, props, state

Tre concetti chiave di React. Te li spiego con un esempio della vita di tutti i giorni.

**Componente**: un pezzo di UI riusabile. Il bottone "Compra" che vedi in 100 punti del sito = un solo componente, riusato 100 volte.

```jsx
function Button({ label, onClick }) {
  return <button onClick={onClick}>{label}</button>;
}
```

**Props**: i dati che passi al componente. Sono come **parametri di una funzione**.

```jsx
<Button label="Compra" onClick={handleBuy} />
<Button label="Annulla" onClick={handleCancel} />
```

Stesso componente, props diverse, comportamento diverso.

**State**: i dati interni al componente, che cambiano nel tempo. Esempio: il valore del contatore, l'input del form, lo stato "modal aperto/chiuso".

```jsx
const [isOpen, setIsOpen] = useState(false);
```

`isOpen` è uno stato. `setIsOpen` è la funzione per cambiarlo. Quando lo cambi, React **ri-renderizza** il componente.

### Quando Claude scrive React, sa fare queste 3 cose

Tu, come vibecoder, devi **riconoscere** quando Claude scrive:

- Un **componente** (funzione che inizia con maiuscola: `Button`, `Card`, `ProductList`)
- **Props** (parametri della funzione: `function Card({ title, price })`)
- **State** (chiamate a `useState`: `const [x, setX] = useState(...)`)

Sono i tre pezzi più frequenti del codice React. Se questi tre li vedi, sei a posto. Il resto è dettaglio.

### Cosa ti porti via

1. Il **DOM** è la rappresentazione viva della pagina, modificabile in tempo reale.
2. **React** ti permette di **descrivere come la UI deve essere** in funzione dei dati, invece di modificare il DOM a mano.
3. **Tre concetti chiave** in React: componenti (UI riusabili), props (parametri), state (dati interni mutabili).
4. Quando leggi codice React di Claude, **cerca i tre**: nome con maiuscola, parametri, `useState`.

---

## 4.5 — Server Components vs Client Components (Next.js 14+)

### La cosa che il vibecoder Next.js incontra senza capire

Apri un progetto Next.js 14+. Trovi due tipi di file di componenti:

```tsx
// Componente di default (Server Component)
export default function ProductPage({ id }) {
  // Qui posso fare query al database direttamente!
  const product = await db.product.findById(id);
  return <ProductDetail product={product} />;
}
```

```tsx
// Componente con 'use client' (Client Component)
'use client';
import { useState } from 'react';

export default function AddToCartButton({ productId }) {
  const [adding, setAdding] = useState(false);
  return <button onClick={() => setAdding(true)}>Aggiungi</button>;
}
```

La differenza? Il primo gira **sul server**, il secondo nel **browser**. Decide tutto la riga `'use client'` in cima al file.

### Cosa cambia tra i due

**Server Component** (default — senza `'use client'`):
- Gira **una volta**, sul server, prima che la pagina arrivi al browser
- **Può accedere al database**, file system, API key segrete
- **Non può** usare interazioni utente (`onClick`, `useState`, `useEffect`)
- HTML risultante è già pronto, niente JS frontend → pagina più leggera

**Client Component** (con `'use client'`):
- Gira **nel browser** dopo il caricamento
- **Può usare** `useState`, `useEffect`, `onClick`, accesso al DOM
- **Non può** accedere a database o segreti (li vedrebbero gli utenti)
- Richiede JavaScript scaricato dal browser

### Regola pratica per il vibecoder

Senza scrivere codice, ti basta sapere questo: **quando vedi `'use client'` in un file, quel file gira nel browser**. Senza, gira sul server.

Perché ti importa? Perché quando Claude ti propone una soluzione, devi capire dove gira il codice. Esempi:
- *"Validazione del form lato client"* → Client Component
- *"Fetch dei prodotti dal database"* → Server Component
- *"Bottone con stato di loading durante il submit"* → Client Component (perché `useState`)
- *"Pagina pubblica indicizzata da Google"* → Server Component (perché HTML già pronto)

### Errori comuni del vibecoder che non sa la differenza

**Errore 1**: provare a usare `useState` in un Server Component.

Sintomo: Next.js dà errore *"useState can only be used in Client Components"*.
Fix: aggiungi `'use client'` in cima al file.

**Errore 2**: mettere `'use client'` ovunque "per sicurezza".

Sintomo: il sito carica più JavaScript del necessario, perdi i benefici del rendering server. Niente errore visibile, ma performance peggiori.
Fix: usa `'use client'` solo nei componenti che ne hanno davvero bisogno (interazione, stato).

**Errore 3**: chiamare un'API key direttamente in un Client Component.

Sintomo: l'API key è visibile nel codice del browser (chi ispeziona la pagina la vede in chiaro). Disastro di sicurezza.
Fix: tieni le chiamate con API key in Server Components, esponi solo i risultati al client.

### Come parlarne a Claude

Quando descrivi un componente, **dichiara dove deve girare**:

> ✏️ **"Pagina prodotto: Server Component che fetcha dal DB. Pulsante 'Aggiungi al carrello' come Client Component separato (perché ha state). Form di recensione separato come Client Component."*

Questa è la differenza tra un prompt che genera architettura sensata e uno che genera codice confuso.

### Cosa ti porti via

1. In Next.js 14+, esistono due tipi di componente: **Server Component** (default) e **Client Component** (con `'use client'` in cima).
2. **Server Component**: gira sul server, accesso al DB, niente interazione utente.
3. **Client Component**: gira nel browser, accesso a `useState`/`useEffect`, niente segreti.
4. **Regola pratica**: usa `'use client'` solo dove serve davvero (interazione, stato), non ovunque.

---

## Chiusura del Modulo 4

Adesso il **frontend non è più una scatola nera**. Sai:

- Cosa significa scegliere un tag HTML "con significato" invece di un `<div>` puro
- Come fare layout responsive con Flexbox e Grid, mobile-first
- La differenza tra MPA, SPA, e l'ibrido di Next.js
- Cosa è il DOM, cosa fa React, e i tre concetti chiave (componenti, props, state)
- Quando un componente Next.js gira sul server e quando nel browser

Quando Claude ti scrive 200 righe di codice frontend, non ti spaventi più. Ne riconosci l'architettura.

Nel **Modulo 5** ci spostiamo dall'altra parte: il backend. API REST, codici di stato HTTP, headers, JSON. Tutto quello che il frontend vede del server.

---

## 🎯 Mini-quiz di autovalutazione

**1. Vero o falso: usare `<button>` invece di `<div onClick>` cambia solo questione di stile.**

**2. Vuoi una griglia di 4 card prodotto su desktop e 1 colonna su mobile. Quale tecnologia CSS usi: Flexbox o Grid?**

**3. Cosa fa la riga `'use client'` in cima a un file Next.js?**

**4. In React, qual è la differenza tra "props" e "state"?**

**5. Hai un componente che fa fetch al database e mostra una lista. Vedi un errore Next.js *"useState can only be used in Client Components"*. Cosa cambia?**

---

### Risposte

1. **Falso**. Usare `<button>` invece di `<div onClick>` cambia: lo screen reader lo legge come bottone, è raggiungibile da tastiera (TAB), Google capisce che è interattivo, e il browser ti dà gratuitamente focus visivo. Tutto questo lo perdi col `<div>`.

2. **Grid**. Flexbox è perfetto per una fila singola; per layout 2D (colonne × righe), Grid è la scelta giusta. `grid-template-columns: repeat(4, 1fr)` su desktop, `grid-template-columns: 1fr` su mobile.

3. Dice a Next.js: **questo file è un Client Component**, deve essere bundlato e mandato al browser. Senza, sarebbe un Server Component (gira sul server).

4. **Props** sono dati che il componente **riceve dall'esterno** (immutabili dentro al componente). **State** sono dati **interni mutabili** (cambiano nel tempo, es. con `useState`). Props vengono "calate dall'alto", lo state nasce e vive dentro il componente.

5. Probabilmente stai cercando di usare `useState` (o un hook) in un Server Component. Aggiungi `'use client'` in cima al file. **Ma valuta**: se è un componente che fa fetch al DB, magari meglio **separare** la parte "fetch" (Server Component) dalla parte "interazione utente" (Client Component figlio), invece di rendere tutto Client.

---

> Hai assorbito il frontend a livello concettuale. Il **Modulo 5** ti porta dall'altra parte (backend) — più tecnico ma con la stessa logica: capire cosa Claude scrive, perché lo scrive così.

---

*Modulo 4 redatto: 2026-04-25 · Versione 1.0 · ~18 pagine · ~4400 parole*
