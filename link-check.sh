#!/bin/bash
# check the validity of relative and hard links in all the md files

while read -rd '' -r file; do
    echo "Checking file: $file"
    grep -Eno '\[[^]]+\]([^)]+))' "$file" | while read -r line; do
        line_link="$(echo "$line" | grep -oP '(?<=\().*(?=\))')"
        echo -n " - $(echo "$line" | cut -d: -f1): $line_link "
        case "$line_link" in
            http*)
                if [[ "$(curl -o /dev/null -Isw '%{http_code}\n' "$line_link")" == "200" ]]; then
                    echo -e "\033[32m[ OK ]\e[0m"
                else
                    echo -e "\033[31m[ ERROR ]\e[0m" && exit 1
                fi
                ;;
            *)
                if [[ -e "$(dirname "$file")/$line_link" ]]; then
                    echo -e "\033[32m[ OK ]\e[0m"
                else
                    echo -e "\033[31m[ ERROR ]\e[0m" && exit 1
                fi
                ;;
        esac
    done
done < <(find . -type f -name '*.md' -print0)
exit 0
