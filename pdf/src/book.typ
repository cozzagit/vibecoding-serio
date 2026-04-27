#import "../src/template.typ": *

#show: book.with(
  title: "Vibecoding Serio",
  subtitle: "Il manuale per chi costruisce siti con l'AI ma non capisce cosa sta costruendo",
  author: "Luca Cozza",
)

// ===== FRONT MATTER =====
#cover-page()
#title-page()
#colophon()

// ===== TABLE OF CONTENTS =====
#set page(margin: (top: 3cm, bottom: 2.5cm, x: 2.4cm), header: none, footer: none)
#v(2cm)
#text(font: heading-font, size: 32pt, weight: 700, tracking: -0.5pt)[Indice]
#v(0.5cm)
#line(length: 15%, stroke: 1.5pt + ink)
#v(1.5cm)
#outline(title: none, depth: 2, indent: 1em)
#pagebreak()

// ===== PREFACE =====
#v(2cm)
#text(size: 11pt, weight: 600, fill: light, tracking: 3pt)[PREFAZIONE]
#v(0.4cm)
#text(font: heading-font, size: 32pt, weight: 700, tracking: -0.5pt)[Mettiti comodo]
#v(0.5cm)
#line(length: 15%, stroke: 1.5pt + ink)
#v(1.5cm)

Hai aperto un libro che non avresti dovuto comprare. 
Sei arrivato qui perché qualcosa, in tutto questo costruire siti con l'AI, non ti torna. 
Il sito funziona, sì. Ma se ti chiedessero perché funziona, non sapresti rispondere. 
E quando si rompe — perché si rompe sempre — non sai nemmeno dove guardare.

Questo libro non ti renderà uno sviluppatore senior. Non è il suo scopo. 
Ti darà i fondamenti che separano un progetto fragile da uno che regge. 
I concetti, il lessico, le mappe mentali. 
Quelli che, una volta dentro, non ti escono più dalla testa.

Tre modi di leggerlo:

+ #strong[Lineare] — dall'inizio alla fine, in 8-10 ore in 3-4 sessioni.
+ #strong[Quick Wins] — i 5 capitoli "killer" che risolvono problemi che hai avuto la settimana scorsa.
+ #strong[Riferimento] — glossari e appendici come dizionario quando ti servono.

Inizia come vuoi. Ma una raccomandazione: 
#strong[non saltare il Modulo 0]. Sembra introduttivo, ma è il vocabolario su cui poggia tutto il resto.

#v(2cm)
#align(right)[#text(style: "italic", fill: muted)[L. C. — primavera 2026]]


// ===== PARTE I — MODULI =====

#include "../build/modulo-00.typ"

#include "../build/modulo-01.typ"

#include "../build/modulo-02.typ"

#include "../build/modulo-03.typ"

#include "../build/modulo-04.typ"

#include "../build/modulo-05.typ"

#include "../build/modulo-06.typ"

#include "../build/modulo-07.typ"

#include "../build/modulo-08.typ"

// ===== PARTE II — QUICK WINS =====
#pagebreak(weak: true)
#v(3cm)
#text(size: 11pt, weight: 600, fill: light, tracking: 3pt)[PARTE II]
#v(0.5cm)
#text(font: heading-font, size: 38pt, weight: 700, tracking: -1pt)[I 5 capitoli killer]
#v(0.5cm)
#line(length: 20%, stroke: 1.5pt + ink)
#v(0.5cm)
#text(size: 12pt, fill: muted, style: "italic")[I quick wins che da soli giustificano il prezzo del libro.]
#pagebreak()

#include "../build/qw-01.typ"

#include "../build/qw-02.typ"

#include "../build/qw-03.typ"

#include "../build/qw-04.typ"

#include "../build/qw-05.typ"

// ===== PARTE III — GLOSSARI =====
#pagebreak(weak: true)
#v(3cm)
#text(size: 11pt, weight: 600, fill: light, tracking: 3pt)[PARTE III]
#v(0.5cm)
#text(font: heading-font, size: 38pt, weight: 700, tracking: -1pt)[Glossari]
#v(0.5cm)
#line(length: 20%, stroke: 1.5pt + ink)
#v(0.5cm)
#text(size: 12pt, fill: muted, style: "italic")[130+ termini, organizzati per categoria. Da consultare come dizionario.]
#pagebreak()

#include "../build/glossario-1programmazione.typ"

#include "../build/glossario-2anatomiapagina.typ"

// ===== APPENDICI =====
#pagebreak(weak: true)
#v(3cm)
#text(size: 11pt, weight: 600, fill: light, tracking: 3pt)[APPENDICI]
#v(0.5cm)
#text(font: heading-font, size: 38pt, weight: 700, tracking: -1pt)[Strumenti pratici]
#v(0.5cm)
#line(length: 20%, stroke: 1.5pt + ink)
#v(0.5cm)
#text(size: 12pt, fill: muted, style: "italic")[Cheat sheet, checklist, prompt template, GDPR. Stampabili.]
#pagebreak()

#include "../build/app-A.typ"

#include "../build/app-B.typ"

#include "../build/app-C.typ"

#include "../build/app-D.typ"

// ===== BACKMATTER =====
#pagebreak(weak: true)
#set page(margin: (top: 4cm, bottom: 3cm, x: 2.4cm), header: none, footer: none)
#v(3cm)
#align(center)[
  #text(font: mono-font, size: 12pt, fill: muted)[\{ vibecoding • serio \}]
  #v(0.5cm)
  #text(size: 11pt, fill: muted, style: "italic")[Fine del libro.]
  #v(2cm)
  #text(size: 14pt)[Buon vibecoding.]
  #v(0.3cm)
  #text(size: 14pt, weight: 700)[Sul serio.]
]
