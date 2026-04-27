// =============================================================
// VIBECODING SERIO — Template tipografico
// =============================================================
// Design system coerente con landing e infografiche
// Format: 6×9 inch (libro classico)
// Engine: Typst 0.14+
// =============================================================

// ===== PALETTE =====
#let ink = rgb("#0F1419")
#let muted = rgb("#6B7280")
#let border-c = rgb("#E5E7EB")
#let light = rgb("#9CA3AF")
#let bg = rgb("#FAFAF7")
#let accent-amber = rgb("#D97706")
#let accent-blue = rgb("#2563EB")
#let accent-teal = rgb("#0D9488")
#let accent-rose = rgb("#BE123C")
#let accent-violet = rgb("#7C3AED")
#let code-bg = rgb("#0F1419")
#let code-fg = rgb("#FAFAF7")

// ===== FONTS =====
// Body: serif elegante per lettura lunga (fallback: Georgia)
// Headings: sans moderna (Inter Tight con fallback Inter)
// Code: monospace
#let body-font = ("Source Serif 4", "Source Serif Pro", "Georgia", "Times New Roman")
#let heading-font = ("Inter Tight", "Inter", "Helvetica Neue", "Arial")
#let mono-font = ("JetBrains Mono", "Consolas", "Courier New")

// ===== MAIN TEMPLATE =====
#let book(
  title: "Vibecoding Serio",
  subtitle: "Il manuale per chi costruisce siti con l'AI ma non capisce cosa sta costruendo",
  author: "Luca Cozza",
  doc,
) = {
  set document(
    title: title,
    author: author,
  )

  set page(
    paper: "us-letter",  // overridden below
    width: 6in,
    height: 9in,
    margin: (top: 2.4cm, bottom: 2.2cm, inside: 2.2cm, outside: 1.8cm),
    fill: bg,
  )

  // Body text settings
  set text(
    font: body-font,
    size: 10.5pt,
    lang: "it",
    fill: ink,
    hyphenate: true,
  )

  set par(
    leading: 0.72em,
    first-line-indent: 0pt,
    justify: true,
  )

  // Heading styles
  show heading: set text(font: heading-font, weight: 700, fill: ink)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(2cm)
    text(size: 26pt, weight: 700, tracking: -0.5pt)[#it.body]
    v(0.6em)
    line(length: 30%, stroke: 1.2pt + ink)
    v(1.2cm)
  }
  show heading.where(level: 2): it => {
    v(1.2em, weak: true)
    block(text(size: 18pt, weight: 700, tracking: -0.3pt)[#it.body])
    v(0.4em, weak: true)
  }
  show heading.where(level: 3): it => {
    v(0.8em, weak: true)
    block(text(size: 13pt, weight: 700, fill: ink)[#it.body])
    v(0.2em, weak: true)
  }
  show heading.where(level: 4): it => {
    v(0.6em, weak: true)
    block(text(size: 11pt, weight: 700, fill: accent-amber)[#it.body])
    v(0.1em, weak: true)
  }

  // Inline code
  show raw.where(block: false): it => box(
    fill: rgb("#F3F4F6"),
    inset: (x: 4pt, y: 1pt),
    outset: (y: 2pt),
    radius: 2pt,
    text(font: mono-font, size: 0.88em, fill: rgb("#BE123C"))[#it.text],
  )

  // Code blocks
  show raw.where(block: true): it => block(
    fill: code-bg,
    inset: (x: 14pt, y: 12pt),
    radius: 4pt,
    width: 100%,
    text(font: mono-font, size: 9pt, fill: code-fg)[#it.text],
  )

  // Strong / emphasis
  show strong: set text(weight: 700, fill: ink)
  show emph: set text(style: "italic", fill: ink)

  // Lists
  set list(indent: 1em, body-indent: 0.4em, marker: ([•], [◦], [▪]))
  set enum(indent: 1em, body-indent: 0.4em)

  // Quote (blockquote / callout)
  show quote: it => block(
    fill: rgb("#FFFBEB"),
    stroke: (left: 3pt + accent-amber),
    inset: (x: 14pt, y: 10pt),
    radius: 2pt,
    width: 100%,
    text(style: "italic", fill: ink)[#it.body],
  )

  // Tables
  set table(
    stroke: (x, y) => if y == 0 { (bottom: 1pt + ink) } else { (bottom: 0.5pt + border-c) },
    inset: (x: 8pt, y: 6pt),
  )
  show table.cell.where(y: 0): set text(weight: 700, size: 9.5pt)
  show table.cell: set text(size: 9.5pt)

  // Links
  show link: it => text(fill: accent-blue, underline(it))

  // Page numbering & headers
  set page(
    header: context {
      let page-num = counter(page).get().first()
      if page-num <= 6 [] else {
        let header-text = state("module-name", "")
        let module-name = header-text.get()
        if calc.even(page-num) {
          align(left, text(size: 8pt, fill: light, tracking: 1pt, upper("Vibecoding Serio")))
        } else {
          align(right, text(size: 8pt, fill: light, tracking: 1pt, upper(module-name)))
        }
      }
    },
    footer: context {
      let page-num = counter(page).get().first()
      if page-num <= 2 [] else {
        align(center, text(size: 9pt, fill: muted)[#counter(page).display("1")])
      }
    },
  )

  doc
}

// ===== HELPERS =====

// Callout box: tip / warning / note
#let callout(kind: "tip", body) = {
  let (color, bg-color, label) = if kind == "tip" {
    (accent-blue, rgb("#EFF6FF"), "SUGGERIMENTO")
  } else if kind == "warning" {
    (accent-rose, rgb("#FEF2F2"), "ATTENZIONE")
  } else if kind == "note" {
    (accent-teal, rgb("#F0FDF4"), "NOTA")
  } else if kind == "italian" {
    (accent-amber, rgb("#FFFBEB"), "NOTA ITALIANA")
  } else if kind == "prompt" {
    (accent-violet, rgb("#F5F3FF"), "PROMPT-READY")
  } else {
    (ink, rgb("#F9FAFB"), "INFO")
  }

  block(
    fill: bg-color,
    stroke: (left: 3pt + color),
    inset: (x: 14pt, y: 10pt),
    radius: 2pt,
    width: 100%,
    spacing: 1em,
  )[
    #text(size: 8pt, weight: 700, fill: color, tracking: 1.5pt)[#label]
    #v(2pt)
    #text(size: 10pt, fill: ink)[#body]
  ]
}

// Module title page
#let module-title(num, title, meta) = {
  pagebreak(weak: true)
  v(3cm)
  block(text(size: 9pt, weight: 600, fill: light, tracking: 3pt, upper("Modulo " + str(num))))
  v(0.5cm)
  block(text(font: heading-font, size: 36pt, weight: 700, tracking: -1pt)[#title])
  v(0.3cm)
  line(length: 30%, stroke: 1.5pt + ink)
  v(0.5cm)
  block(text(size: 10pt, fill: muted, style: "italic")[#meta])
  v(2cm)
}

// Section divider
#let divider() = {
  v(1em)
  align(center)[#text(size: 14pt, fill: light, tracking: 6pt)[• • •]]
  v(1em)
}

// Quiz block
#let quiz-block(body) = {
  block(
    fill: rgb("#F9FAFB"),
    stroke: 1pt + border-c,
    inset: 16pt,
    radius: 4pt,
    width: 100%,
  )[
    #text(size: 8pt, weight: 700, fill: accent-amber, tracking: 2pt)[QUIZ DI AUTOVALUTAZIONE]
    #v(8pt)
    #body
  ]
}

// Drop cap
#let dropcap(letter) = {
  text(font: heading-font, size: 60pt, weight: 700, fill: accent-amber)[#letter]
}

// Front matter pages
#let cover-page() = {
  set page(
    margin: 0pt,
    fill: bg,
    header: none,
    footer: none,
  )
  set par(justify: false, leading: 0.5em)

  // Cover layout
  block(
    width: 100%,
    height: 100%,
    inset: (top: 3.5cm, bottom: 3cm, left: 2.4cm, right: 2.4cm),
  )[
    #set align(left)
    #text(size: 10pt, weight: 600, fill: muted, tracking: 4pt)[VIBECODING SERIO]
    #v(0.3cm)
    #line(length: 8%, stroke: 1.5pt + ink)
    #v(2.2cm)

    #text(font: heading-font, size: 30pt, weight: 800, tracking: -1pt, fill: ink, hyphenate: false)[
      Smetti di copiare #linebreak()
      prompt.
    ]
    #v(0.4cm)
    #text(font: heading-font, size: 30pt, weight: 800, tracking: -1pt, fill: accent-amber, hyphenate: false)[
      Inizia a capire #linebreak()
      cosa stai #linebreak()
      costruendo.
    ]

    #v(1.2cm)
    #text(size: 12pt, fill: muted, style: "italic", hyphenate: false)[
      Il manuale per chi costruisce siti con #linebreak()
      l'AI ma non capisce cosa sta costruendo.
    ]

    #v(1fr)

    // Footer cover
    #grid(
      columns: (1fr, auto),
      align: (left + bottom, right + bottom),
      [
        #text(size: 11pt, weight: 700, fill: ink)[Luca Cozza] #linebreak()
        #text(size: 9pt, fill: muted)[Edizione 1.0  ·  2026]
      ],
      [
        #text(font: mono-font, size: 9pt, fill: muted)[\{ vibecoding • serio \}]
      ],
    )
  ]

  pagebreak()
}

// Title page
#let title-page() = {
  set page(margin: (top: 4cm, bottom: 3cm, left: 3cm, right: 3cm), header: none, footer: none)
  set par(justify: false, leading: 0.5em)
  set align(center)
  v(3cm)
  text(font: heading-font, size: 36pt, weight: 700, tracking: -1pt, hyphenate: false)[Vibecoding Serio]
  v(0.5cm)
  line(length: 8%, stroke: 1pt + ink)
  v(0.5cm)
  text(size: 13pt, fill: muted, style: "italic", hyphenate: false)[
    Il manuale per chi costruisce siti con l'AI #linebreak()
    ma non capisce cosa sta costruendo.
  ]
  v(1fr)
  text(size: 11pt, weight: 600)[Luca Cozza]
  v(0.3cm)
  text(size: 10pt, fill: muted)[Edizione 1.0 — 2026]
  v(1cm)
  pagebreak()
}

// Colophon
#let colophon() = {
  set page(margin: (top: 4cm, bottom: 3cm, left: 3cm, right: 3cm), header: none, footer: none)
  set align(left)
  v(2fr)
  text(size: 9pt, fill: muted)[
    *Vibecoding Serio* #linebreak()
    Il manuale per chi costruisce siti con l'AI ma non capisce cosa sta costruendo. #linebreak()
    #linebreak()
    Edizione 1.0 — 2026 #linebreak()
    © 2026 Luca Cozza. Tutti i diritti riservati. #linebreak()
    #linebreak()
    Composto in *Source Serif 4* per il testo, *Inter Tight* per i titoli, #linebreak()
    *JetBrains Mono* per il codice. #linebreak()
    Impaginato con Typst. #linebreak()
    #linebreak()
    vibecodingserio.vibecanyon.com #linebreak()
    luca.cozza\@gmail.com #linebreak()
    github.com/cozzagit/vibecoding-serio
  ]
  v(1fr)
  pagebreak()
}
