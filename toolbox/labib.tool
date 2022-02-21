#!/bin/bash
# compile LaTeX and BibTeX with a single commmand

case "$1" in
    --completion)
        #shellcheck disable=SC1004,SC2016
        echo '
_labib_completion(){
    [[ "$COMP_CWORD" -eq 1 ]] &&
        mapfile -t COMPREPLY < <(compgen -W \
            "$(find \
                -maxdepth 1 \
                -type f \
                -name "*.tex" \
                -exec basename {} .tex \; |
            sort -u)" \
            -- "${COMP_WORDS[COMP_CWORD]}")
}
complete -F _labib_completion labib'

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
