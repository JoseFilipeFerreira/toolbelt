#!/bin/bash
# compile LaTeX and BibTeX with a single commmand

case "$1" in
    --completion)
        echo '_labib_completion(){'
        echo '    [[ "$COMP_CWORD" -eq 1 ]] &&'
        echo '        mapfile -t COMPREPLY < <(compgen -W \'
        echo '            "$(find \'
        echo '                -maxdepth 1 \'
        echo '                -type f \'
        echo '                -name "*.tex" \'
        echo '                -exec basename {} .tex \; |'
        echo '            sort -u)" \'
        echo '            -- "${COMP_WORDS[COMP_CWORD]}")'
        echo '}'
        echo 'complete -F _labib_completion labib'

        exit
        ;;
    *)
        ;;
esac

tex_file="$1.tex"
bib_file="$1.bib"

[ ! -f "$tex_file" ] && echo "$tex_file not found" && exit

if [ -f "$bib_file" ]; then
    pdflatex "$tex_file"
    bibtex "$bib_file"
fi

pdflatex "$tex_file"
pdflatex "$tex_file"
