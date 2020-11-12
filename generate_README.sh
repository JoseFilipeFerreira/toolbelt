#!/bin/bash
# autogenerate [README](README.md)

generate_description(){
    find "$1" -maxdepth 1 -type f -not -path '*/\.*' |
        sort |
        while read -r script
    do
        [ "$(sed -n '/^#!/p;q' "$script")" ] || continue
        filename="$(basename -- $script)"
        echo -n "* [${filename%.*}]($script) "
        sed -n 2p "$script" | sed 's/ *# *//g'
    done

}

intro(){
    echo "# Toolbelt"
    echo "Collection of scripts and dotfiles that follow me in all of my linux adventures"
}

toolbox(){
    echo "## 🧰 [Toolbox](toolbox)(scripts)"
    echo "Colection of scripts to be used in the terminal or a keybind"

    generate_description "toolbox"
}

toolkit(){
    echo "## 🪛 [Toolkit](toolkit) (dmenu scripts)"
    echo "Collection of scripts to be launched from a [menu](toolbox/menu.tool)"

    generate_description "toolkit"
}

powertools(){
    echo "## 🪚 [Powertools](powertools) (.dotfiles)"
    echo "Colection of static config files"
}

install(){
    echo "## 🔗 Install"
    echo "collection of installation scripts"

    generate_description .
}

license(){
    echo "## License"
    echo "This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details"
}


for section in intro toolbox toolkit powertools install license; do
    $section
    echo
done
