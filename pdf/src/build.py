#!/usr/bin/env python3
"""
build.py — Assembla il PDF finale del libro Vibecoding Serio.

1. Converte tutti i .md in .typ
2. Genera book.typ master che li include
3. Compila con typst → output/vibecoding-serio.pdf
"""

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MANUSCRIPT = ROOT / "manuscript"
PDF = ROOT / "pdf"
BUILD = PDF / "build"
OUTPUT = PDF / "output"
SRC = PDF / "src"

BUILD.mkdir(parents=True, exist_ok=True)
OUTPUT.mkdir(parents=True, exist_ok=True)


def convert(md: Path, typ: Path):
    subprocess.check_call(
        [sys.executable, str(SRC / "md2typ.py"), str(md), str(typ)],
        stderr=subprocess.STDOUT,
    )
    # Prepend import statement so callout/divider/etc. helpers are visible
    content = typ.read_text(encoding="utf-8")
    typ.write_text('#import "../src/template.typ": *\n\n' + content, encoding="utf-8")


def main():
    chapters = []

    # 1. Modulo 0..8
    moduli_dir = MANUSCRIPT / "moduli"
    for md in sorted(moduli_dir.glob("*.md")):
        typ = BUILD / f"modulo-{md.stem[:2]}.typ"
        convert(md, typ)
        chapters.append(("module", typ.name, md.stem))

    # 2. Quick Wins
    qw_dir = MANUSCRIPT / "quick-wins"
    for md in sorted(qw_dir.glob("*.md")):
        typ = BUILD / f"qw-{md.stem[:2]}.typ"
        convert(md, typ)
        chapters.append(("quickwin", typ.name, md.stem))

    # 3. Glossari
    for md in sorted(MANUSCRIPT.glob("glossario-*.md")):
        typ = BUILD / f"glossario-{md.stem[10:].replace('-', '')}.typ"
        convert(md, typ)
        chapters.append(("glossary", typ.name, md.stem))

    # 4. Appendici
    app_dir = MANUSCRIPT / "appendici"
    for md in sorted(app_dir.glob("*.md")):
        typ = BUILD / f"app-{md.stem[0]}.typ"
        convert(md, typ)
        chapters.append(("appendix", typ.name, md.stem))

    # Build master book.typ
    book_lines = [
        '#import "../src/template.typ": *',
        '',
        '#show: book.with(',
        '  title: "Vibecoding Serio",',
        '  subtitle: "Il manuale per chi costruisce siti con l\'AI ma non capisce cosa sta costruendo",',
        '  author: "Lupo Carro",',
        ')',
        '',
        '// ===== FRONT MATTER =====',
        '#cover-page()',
        '#title-page()',
        '#colophon()',
        '',
        '// ===== TABLE OF CONTENTS =====',
        '#page(margin: (top: 3cm, bottom: 2.5cm, x: 2cm), header: none, footer: none)[',
        '  #v(1cm)',
        '  #text(font: heading-font, size: 32pt, weight: 700, tracking: -0.5pt)[Indice]',
        '  #v(0.5cm)',
        '  #line(length: 15%, stroke: 1.5pt + ink)',
        '  #v(1.2cm)',
        '  #outline(title: none, depth: 2, indent: 1em)',
        ']',
        '',
        '// ===== PREFACE =====',
        '#v(2cm)',
        '#text(size: 11pt, weight: 600, fill: light, tracking: 3pt)[PREFAZIONE]',
        '#v(0.4cm)',
        '#text(font: heading-font, size: 32pt, weight: 700, tracking: -0.5pt)[Mettiti comodo]',
        '#v(0.5cm)',
        '#line(length: 15%, stroke: 1.5pt + ink)',
        '#v(1.5cm)',
        '',
        'Hai aperto un libro che non avresti dovuto comprare. ',
        'Sei arrivato qui perché qualcosa, in tutto questo costruire siti con l\'AI, non ti torna. ',
        'Il sito funziona, sì. Ma se ti chiedessero perché funziona, non sapresti rispondere. ',
        'E quando si rompe — perché si rompe sempre — non sai nemmeno dove guardare.',
        '',
        'Questo libro non ti renderà uno sviluppatore senior. Non è il suo scopo. ',
        'Ti darà i fondamenti che separano un progetto fragile da uno che regge. ',
        'I concetti, il lessico, le mappe mentali. ',
        'Quelli che, una volta dentro, non ti escono più dalla testa.',
        '',
        'Tre modi di leggerlo:',
        '',
        '+ #strong[Lineare] — dall\'inizio alla fine, in 8-10 ore in 3-4 sessioni.',
        '+ #strong[Quick Wins] — i 5 capitoli "killer" che risolvono problemi che hai avuto la settimana scorsa.',
        '+ #strong[Riferimento] — glossari e appendici come dizionario quando ti servono.',
        '',
        'Inizia come vuoi. Ma una raccomandazione: ',
        '#strong[non saltare il Modulo 0]. Sembra introduttivo, ma è il vocabolario su cui poggia tutto il resto.',
        '',
        '#v(2cm)',
        '#align(right)[#text(style: "italic", fill: muted)[L. C. — primavera 2026]]',
        '',
    ]

    # Now include all chapters
    book_lines.append('')
    book_lines.append('// ===== PARTE I — MODULI =====')
    book_lines.append('')

    for kind, fname, stem in chapters:
        if kind == "module":
            book_lines.append(f'#include "../build/{fname}"')
            book_lines.append('')

    book_lines.append('// ===== PARTE II — QUICK WINS =====')
    book_lines.append('#pagebreak(weak: true)')
    book_lines.append('#v(3cm)')
    book_lines.append('#text(size: 11pt, weight: 600, fill: light, tracking: 3pt)[PARTE II]')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#text(font: heading-font, size: 38pt, weight: 700, tracking: -1pt)[I 5 capitoli killer]')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#line(length: 20%, stroke: 1.5pt + ink)')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#text(size: 12pt, fill: muted, style: "italic")[I quick wins che da soli giustificano il prezzo del libro.]')
    book_lines.append('#pagebreak()')
    book_lines.append('')

    for kind, fname, stem in chapters:
        if kind == "quickwin":
            book_lines.append(f'#include "../build/{fname}"')
            book_lines.append('')

    book_lines.append('// ===== PARTE III — GLOSSARI =====')
    book_lines.append('#pagebreak(weak: true)')
    book_lines.append('#v(3cm)')
    book_lines.append('#text(size: 11pt, weight: 600, fill: light, tracking: 3pt)[PARTE III]')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#text(font: heading-font, size: 38pt, weight: 700, tracking: -1pt)[Glossari]')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#line(length: 20%, stroke: 1.5pt + ink)')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#text(size: 12pt, fill: muted, style: "italic")[130+ termini, organizzati per categoria. Da consultare come dizionario.]')
    book_lines.append('#pagebreak()')
    book_lines.append('')

    for kind, fname, stem in chapters:
        if kind == "glossary":
            book_lines.append(f'#include "../build/{fname}"')
            book_lines.append('')

    book_lines.append('// ===== APPENDICI =====')
    book_lines.append('#pagebreak(weak: true)')
    book_lines.append('#v(3cm)')
    book_lines.append('#text(size: 11pt, weight: 600, fill: light, tracking: 3pt)[APPENDICI]')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#text(font: heading-font, size: 38pt, weight: 700, tracking: -1pt)[Strumenti pratici]')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#line(length: 20%, stroke: 1.5pt + ink)')
    book_lines.append('#v(0.5cm)')
    book_lines.append('#text(size: 12pt, fill: muted, style: "italic")[Cheat sheet, checklist, prompt template, GDPR. Stampabili.]')
    book_lines.append('#pagebreak()')
    book_lines.append('')

    for kind, fname, stem in chapters:
        if kind == "appendix":
            book_lines.append(f'#include "../build/{fname}"')
            book_lines.append('')

    # Backmatter
    book_lines.append('// ===== BACKMATTER =====')
    book_lines.append('#page(margin: (top: 4cm, bottom: 3cm, x: 2.4cm), header: none, footer: none)[')
    book_lines.append('  #v(3cm)')
    book_lines.append('  #align(center)[')
    book_lines.append('    #text(font: mono-font, size: 12pt, fill: muted)[\\{ vibecoding • serio \\}]')
    book_lines.append('    #v(0.5cm)')
    book_lines.append('    #text(size: 11pt, fill: muted, style: "italic")[Fine del libro.]')
    book_lines.append('    #v(2cm)')
    book_lines.append('    #text(size: 14pt)[Buon vibecoding.]')
    book_lines.append('    #v(0.3cm)')
    book_lines.append('    #text(size: 14pt, weight: 700)[Sul serio.]')
    book_lines.append('  ]')
    book_lines.append(']')
    book_lines.append('')

    book_path = SRC / "book.typ"
    book_path.write_text("\n".join(book_lines), encoding="utf-8")
    print(f"OK: book.typ generato ({sum(1 for _ in book_lines)} righe, {len(chapters)} capitoli)")

    # Compile with typst
    output_pdf = OUTPUT / "vibecoding-serio.pdf"
    print("Compilando PDF...")
    typst_bin = "C:/Users/lucap/bin/typst.exe"
    err_log = BUILD / "typst-error.log"
    fonts_dir = PDF / "fonts"
    result = subprocess.run(
        [typst_bin, "compile",
         "--root", str(ROOT),
         "--font-path", str(fonts_dir),
         str(book_path), str(output_pdf)],
        capture_output=True,
    )
    err_log.write_bytes((result.stdout or b"") + b"\n---STDERR---\n" + (result.stderr or b""))
    if result.returncode != 0:
        print(f"ERRORE compilazione. Vedi: {err_log}")
        # print first 2000 bytes safely
        out = (result.stderr or b"").decode("utf-8", errors="replace")
        sys.stdout.buffer.write(out[:3000].encode("utf-8", errors="replace"))
        sys.exit(1)
    size = output_pdf.stat().st_size / 1024 / 1024
    print(f"OK: {output_pdf.name} generato ({size:.2f} MB)")


if __name__ == "__main__":
    main()
