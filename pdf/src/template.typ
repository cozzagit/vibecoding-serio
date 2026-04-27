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
  author: "Lupo Carro",
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
    margin: (top: 2cm, bottom: 1.8cm, inside: 1.6cm, outside: 1.4cm),
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

  // Increased leading for breathing room
  set par(
    leading: 0.85em,
    first-line-indent: 0pt,
    justify: true,
    spacing: 1.4em,
  )

  // Block / paragraph spacing — generous, key for readability
  show par: set block(spacing: 1.3em)

  // Heading styles — generous breathing
  show heading: set text(font: heading-font, weight: 700, fill: ink)
  show heading: set block(above: 1.6em, below: 0.9em)
  // Headings cling to following content (no orphans at page bottom)
  show heading: set block(breakable: false)
  // Figure styling (used by infographics)
  show figure: it => block(
    breakable: false,
    above: 1.8em,
    below: 1.8em,
  )[
    #align(center)[#it.body]
    #v(0.4em)
    #align(center, text(size: 8.5pt, fill: muted, style: "italic", tracking: 0.3pt)[#it.caption])
  ]

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(1.5cm)
    text(size: 28pt, weight: 700, tracking: -0.5pt)[#it.body]
    v(0.5em)
    line(length: 30%, stroke: 1.2pt + ink)
    v(1.2cm)
  }
  show heading.where(level: 2): it => block(
    above: 2.6em,
    below: 1.1em,
    text(size: 19pt, weight: 700, tracking: -0.3pt)[#it.body],
  )
  show heading.where(level: 3): it => block(
    above: 2em,
    below: 0.9em,
    text(size: 13.5pt, weight: 700, fill: ink, tracking: -0.1pt)[#it.body],
  )
  show heading.where(level: 4): it => block(
    above: 1.6em,
    below: 0.7em,
    text(size: 11pt, weight: 700, fill: accent-amber, tracking: 0.5pt)[#it.body],
  )

  // Inline code
  show raw.where(block: false): it => box(
    fill: rgb("#F3F4F6"),
    inset: (x: 4pt, y: 1pt),
    outset: (y: 2pt),
    radius: 2pt,
    text(font: mono-font, size: 0.88em, fill: rgb("#BE123C"))[#it.text],
  )

  // Code blocks with generous spacing around — unbreakable when short
  show raw.where(block: true): it => {
    let lines-count = it.text.split("\n").len()
    let is-short = lines-count <= 14
    block(
      fill: code-bg,
      inset: (x: 14pt, y: 12pt),
      radius: 4pt,
      width: 100%,
      above: 1.4em,
      below: 1.4em,
      breakable: not is-short,
      text(font: mono-font, size: 8.8pt, fill: code-fg)[#it.text],
    )
  }

  // Strong / emphasis
  show strong: set text(weight: 700, fill: ink)
  show emph: set text(style: "italic", fill: ink)

  // Lists with proper spacing
  set list(indent: 1em, body-indent: 0.5em, marker: ([•], [◦], [▪]), spacing: 0.7em)
  set enum(indent: 1em, body-indent: 0.5em, spacing: 0.7em)
  show list: set block(above: 1.1em, below: 1.1em)
  show enum: set block(above: 1.1em, below: 1.1em)
  // List items breathe more
  show list.item: it => block(above: 0.4em, below: 0.4em)[#it]
  show enum.item: it => block(above: 0.4em, below: 0.4em)[#it]

  // Tables with breathing
  show table: set block(above: 1.4em, below: 1.4em)

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

  // Page numbering & headers — dynamic via heading queries
  set page(
    header: context {
      let pn = here().page()
      // Skip header on first ~5 pages (cover, title, colophon, indice, prefazione)
      if pn <= 5 { return [] }

      // Find current H1 (modulo / parte) before this page
      let h1s = query(selector(heading.where(level: 1)).before(here()))
      let current-title = if h1s.len() > 0 {
        h1s.last().body
      } else {
        [Vibecoding Serio]
      }

      // Two-column header: left = book name, right = current chapter
      grid(
        columns: (1fr, auto),
        align: (left, right),
        text(size: 8pt, fill: light, tracking: 1.5pt)[VIBECODING SERIO],
        text(size: 8pt, fill: light, tracking: 1pt)[#current-title],
      )
      v(2pt)
      line(length: 100%, stroke: 0.4pt + border-c)
    },
    footer: context {
      let pn = here().page()
      if pn <= 3 { return [] }
      align(center)[
        #text(size: 9pt, fill: muted, font: heading-font, weight: 500)[
          #counter(page).display("1")
        ]
      ]
    },
  )

  doc
}

// ===== HELPERS =====

// Callout box: tip / warning / note — with proper breathing
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
    inset: (x: 14pt, y: 12pt),
    radius: 2pt,
    width: 100%,
    above: 1.4em,
    below: 1.4em,
    breakable: false,
  )[
    #text(size: 8pt, weight: 700, fill: color, tracking: 1.5pt)[#label]
    #v(4pt)
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

// Front matter pages — COVER with illustration
// Uses page() function (local override, does NOT persist after this page)
#let cover-page() = page(
  margin: 0pt,
  fill: bg,
  header: none,
  footer: none,
)[
  #set par(justify: false, leading: 0.5em)
  #block(
    width: 100%,
    height: 100%,
    inset: (top: 1.5cm, bottom: 1.5cm, left: 1.6cm, right: 1.6cm),
  )[
    // Top label
    #text(size: 10pt, weight: 600, fill: muted, tracking: 4pt)[VIBECODING SERIO]
    #v(0.15cm)
    #line(length: 8%, stroke: 1.5pt + ink)

    // Illustration block (constrained height so title doesn't get pushed)
    #v(0.4cm)
    #align(center)[
      #box(width: 100%, height: 11cm)[
        #image("../assets/cover-art.svg", height: 100%, fit: "contain")
      ]
    ]
    #v(0.4cm)

    // Title block
    #text(font: heading-font, size: 22pt, weight: 800, tracking: -0.8pt, fill: ink, hyphenate: false)[
      Smetti di copiare prompt.
    ]
    #v(0.1cm)
    #text(font: heading-font, size: 22pt, weight: 800, tracking: -0.8pt, fill: accent-amber, hyphenate: false)[
      Inizia a capire cosa stai costruendo.
    ]

    #v(0.4cm)
    #text(size: 10.5pt, fill: muted, style: "italic", hyphenate: false)[
      Il manuale per chi costruisce siti con l'AI #linebreak()
      ma non capisce cosa sta costruendo.
    ]

    #v(1fr)

    // Footer cover
    #grid(
      columns: (1fr, auto),
      align: (left + bottom, right + bottom),
      [
        #text(size: 11pt, weight: 700, fill: ink)[Lupo Carro] #linebreak()
        #text(size: 9pt, fill: muted)[Edizione 1.0  ·  2026]
      ],
      [
        #text(font: mono-font, size: 9pt, fill: muted)[\{ vibecoding • serio \}]
      ],
    )
  ]
]

// Title page
#let title-page() = page(
  margin: (top: 4cm, bottom: 3cm, left: 3cm, right: 3cm),
  header: none,
  footer: none,
)[
  #set par(justify: false, leading: 0.5em)
  #set align(center)
  #v(3cm)
  #text(font: heading-font, size: 36pt, weight: 700, tracking: -1pt, hyphenate: false)[Vibecoding Serio]
  #v(0.5cm)
  #line(length: 8%, stroke: 1pt + ink)
  #v(0.5cm)
  #text(size: 13pt, fill: muted, style: "italic", hyphenate: false)[
    Il manuale per chi costruisce siti con l'AI #linebreak()
    ma non capisce cosa sta costruendo.
  ]
  #v(1fr)
  #text(size: 11pt, weight: 600)[Lupo Carro]
  #v(0.3cm)
  #text(size: 10pt, fill: muted)[Edizione 1.0 — 2026]
  #v(1cm)
]

// Colophon
#let colophon() = page(
  margin: (top: 4cm, bottom: 3cm, left: 3cm, right: 3cm),
  header: none,
  footer: none,
)[
  #set align(left)
  #v(2fr)
  #text(size: 9pt, fill: muted)[
    *Vibecoding Serio* #linebreak()
    Il manuale per chi costruisce siti con l'AI ma non capisce cosa sta costruendo. #linebreak()
    #linebreak()
    Edizione 1.0 — 2026 #linebreak()
    © 2026 Lupo Carro. Tutti i diritti riservati. #linebreak()
    #linebreak()
    Composto in *Source Serif 4* per il testo, *Inter Tight* per i titoli, #linebreak()
    *JetBrains Mono* per il codice. #linebreak()
    Impaginato con Typst. #linebreak()
    #linebreak()
    vibecodingserio.vibecanyon.com #linebreak()
    luca.cozza\@gmail.com #linebreak()
    github.com/cozzagit/vibecoding-serio
  ]
  #v(1fr)
]
