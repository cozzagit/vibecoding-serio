#!/usr/bin/env python3
"""
md2typ — Convertitore markdown → typst per Vibecoding Serio.

Uso: python md2typ.py input.md > output.typ
"""

import re
import sys
from pathlib import Path


def escape_typ(text):
    """Escape Typst special chars in plain text."""
    text = text.replace("\\", "\\\\")
    text = text.replace("#", "\\#")
    text = text.replace("$", "\\$")
    text = text.replace("@", "\\@")
    text = text.replace("<", "\\<")
    text = text.replace(">", "\\>")
    return text


def process_inline(text):
    """Process inline markdown elements."""
    # Inline code (preserve, escape inside)
    code_blocks = []

    def stash_code(m):
        idx = len(code_blocks)
        code_blocks.append(m.group(1))
        return f"\x00CODE{idx}\x00"

    text = re.sub(r"`([^`]+)`", stash_code, text)

    # Now escape special chars
    text = escape_typ(text)

    # Bold + italic
    text = re.sub(r"\*\*\*(.+?)\*\*\*", r"#emph[#strong[\1]]", text)
    text = re.sub(r"\*\*(.+?)\*\*", r"#strong[\1]", text)
    text = re.sub(r"(?<!\w)\*([^\*]+?)\*(?!\w)", r"#emph[\1]", text)
    text = re.sub(r"_([^_]+)_", r"#emph[\1]", text)

    # Links [text](url)
    def link_repl(m):
        label = m.group(1)
        url = m.group(2)
        return f'#link("{url}")[{label}]'

    text = re.sub(r"\[([^\]]+)\]\(([^\)]+)\)", link_repl, text)

    # Restore inline code
    def restore_code(m):
        idx = int(m.group(1))
        c = code_blocks[idx].replace("\\", "\\\\").replace('"', '\\"')
        return f'#raw("{c}")'

    text = re.sub(r"\x00CODE(\d+)\x00", restore_code, text)

    return text


def convert_table(lines):
    """Convert a markdown table to typst table."""
    if len(lines) < 2:
        return "\n".join(lines)

    # Parse header
    header = [c.strip() for c in lines[0].strip("|").split("|")]
    cols = len(header)

    # Skip separator line
    rows = []
    for line in lines[2:]:
        if not line.strip().startswith("|"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        # Pad if needed
        while len(cells) < cols:
            cells.append("")
        rows.append(cells[:cols])

    out = ["#table("]
    out.append(f"  columns: {cols},")
    # Header
    header_cells = [f"[*{process_inline(h)}*]" for h in header]
    out.append("  table.header(" + ", ".join(header_cells) + "),")
    # Rows
    for row in rows:
        cells = [f"[{process_inline(c)}]" for c in row]
        out.append("  " + ", ".join(cells) + ",")
    out.append(")")
    out.append("")
    return "\n".join(out)


def convert_md(md_text):
    """Main conversion function."""
    lines = md_text.split("\n")
    out = []
    i = 0

    in_code_block = False
    code_lang = ""
    code_lines = []

    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        # Code block fence
        if stripped.startswith("```"):
            if in_code_block:
                # Close
                code = "\n".join(code_lines)
                # escape backticks and quotes for raw block
                code_escaped = code.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
                out.append(f'#raw(block: true, lang: "{code_lang}", "{code_escaped}")')
                out.append("")
                in_code_block = False
                code_lang = ""
                code_lines = []
            else:
                in_code_block = True
                code_lang = stripped[3:].strip()
                code_lines = []
            i += 1
            continue

        if in_code_block:
            code_lines.append(line)
            i += 1
            continue

        # Skip frontmatter HTML comments
        if stripped.startswith("<!--") and stripped.endswith("-->"):
            i += 1
            continue

        # Horizontal rule
        if stripped in ("---", "***", "___"):
            out.append("#line(length: 100%, stroke: 0.5pt + rgb(\"#E5E7EB\"))")
            out.append("")
            i += 1
            continue

        # Headings
        if stripped.startswith("#"):
            m = re.match(r"^(#{1,6})\s+(.+)$", stripped)
            if m:
                level = len(m.group(1))
                text = process_inline(m.group(2))
                out.append("=" * level + " " + text)
                out.append("")
                i += 1
                continue

        # Blockquote (callout)
        if stripped.startswith("> "):
            quote_lines = []
            kind = "tip"
            while i < len(lines) and (lines[i].strip().startswith("> ") or lines[i].strip() == ">"):
                inner = lines[i].strip()[2:] if lines[i].strip().startswith("> ") else ""
                quote_lines.append(inner)
                i += 1
            quote_text = "\n".join(quote_lines).strip()
            # Detect kind from emoji
            if "⚠" in quote_text or "WARNING" in quote_text.upper():
                kind = "warning"
            elif "💡" in quote_text:
                kind = "tip"
            elif "🇮🇹" in quote_text:
                kind = "italian"
            elif "✏️" in quote_text or "Prompt-ready" in quote_text:
                kind = "prompt"
            elif "🎯" in quote_text or "🎨" in quote_text:
                kind = "note"
            # Strip leading emoji + bold marker
            quote_text = re.sub(r"^[💡⚠️✏️🇮🇹🎯🎨📚📋✅❌📁⌨️🚀🧱🍳🧰🧩📦📛📒🏢⚙️📤📥🤝🔍🖱️🎨👁️]+\s*", "", quote_text)
            content = process_inline(quote_text)
            # Replace newlines with #linebreak()
            content = content.replace("\n", " #linebreak() ")
            out.append(f"#callout(kind: \"{kind}\")[{content}]")
            out.append("")
            continue

        # Tables
        if stripped.startswith("|"):
            tbl_lines = []
            while i < len(lines) and lines[i].strip().startswith("|"):
                tbl_lines.append(lines[i])
                i += 1
            out.append(convert_table(tbl_lines))
            continue

        # Lists (unordered)
        if re.match(r"^\s*[-*+]\s+", line):
            list_lines = []
            while i < len(lines) and (re.match(r"^\s*[-*+]\s+", lines[i]) or (lines[i].strip() == "" and i + 1 < len(lines) and re.match(r"^\s*[-*+]\s+", lines[i + 1]))):
                if lines[i].strip():
                    item_text = re.sub(r"^\s*[-*+]\s+", "", lines[i])
                    list_lines.append(f"- {process_inline(item_text)}")
                i += 1
            out.extend(list_lines)
            out.append("")
            continue

        # Numbered lists
        if re.match(r"^\s*\d+\.\s+", line):
            list_lines = []
            while i < len(lines) and (re.match(r"^\s*\d+\.\s+", lines[i]) or (lines[i].strip() == "" and i + 1 < len(lines) and re.match(r"^\s*\d+\.\s+", lines[i + 1]))):
                if lines[i].strip():
                    item_text = re.sub(r"^\s*\d+\.\s+", "", lines[i])
                    list_lines.append(f"+ {process_inline(item_text)}")
                i += 1
            out.extend(list_lines)
            out.append("")
            continue

        # Empty line
        if not stripped:
            out.append("")
            i += 1
            continue

        # Plain paragraph
        para_lines = [line]
        i += 1
        while i < len(lines) and lines[i].strip() and not lines[i].strip().startswith(("#", ">", "|", "```", "- ", "* ", "+ ")) and not re.match(r"^\d+\.\s", lines[i].strip()) and lines[i].strip() not in ("---", "***"):
            para_lines.append(lines[i])
            i += 1
        para = " ".join(line.strip() for line in para_lines)
        out.append(process_inline(para))
        out.append("")

    return "\n".join(out)


def strip_frontmatter(text):
    """Remove --- frontmatter at start (if any) and the very first H1."""
    return text


def main():
    if len(sys.argv) < 3:
        print("Usage: md2typ.py input.md output.typ", file=sys.stderr)
        sys.exit(1)

    md_path = Path(sys.argv[1])
    out_path = Path(sys.argv[2])
    md_text = md_path.read_text(encoding="utf-8")
    typst_out = convert_md(md_text)
    out_path.write_text(typst_out, encoding="utf-8")
    sys.stderr.write(f"OK: {md_path.name} -> {out_path.name} ({len(typst_out)} chars)\n")


if __name__ == "__main__":
    main()
