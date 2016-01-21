#!/usr/bin/env bash

BIBTEX_FILENAME="$HOME/Dropbox/BibTeX/BibTeX collections-PhD Thesis.bib"
BIBTEX_TARGET="content/references-mendeley.bib"
MAIN_TEX="main.tex"
OUT_PDF="out/main.pdf"

if [ "$BIBTEX_FILENAME" -nt "$BIBTEX_TARGET" ]; then
    echo "Copying .bib file"
    python3 correct_bib.py
fi

echo "Compiling $MAIN_TEX"
latexmk -silent "$MAIN_TEX" && cp "$OUT_PDF" .

