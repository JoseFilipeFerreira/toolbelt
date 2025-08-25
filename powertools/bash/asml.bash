if hash cleartool &>/dev/null; then
    alias ctco='cleartool co -nc'
    alias ctci='cleartool ci -nc'
    alias ctmk='cleartool mkelem'
    alias ctunco='cleartool unco'
    # List files checked out by me
    alias ctlsco='cleartool lsco -me -cview -avobs -fmt "%Tf\t%n\n" | sort'
    alias ccupdate='ccrebase -ml && ccmake && ccrebase -c'
fi

if hash devbench &>/dev/null; then
    alias dba='devbench activate -s'
    alias dbd='devbench deactivate'
    alias dbls='devbench list'
    alias dbrm='devbench remove'
fi

if hash gtc &>/dev/null; then
    alias dbsync='gtc sync && gtc devbench sync -ltps'
    alias gmake='gtc ccmake'
    alias gsmake='gtc sync && gtc ccmake'
    alias gssmake='gtc setup && gtc sync && gtc ccmake'
    alias gcssmake='gtc clean && gtc setup && gtc sync && gtc ccmake'
    alias wololomake='gtc clean && gtc setup && gtc sync && gtc ccmake'

    dbcreate() {
        declare -A MACHINE_ALIAS=(
            [NXT1]="NXT:1960Bi"
            [NXT3]="NXT:1970Ci"
            [NXT_WET]="NXT:2050Ei"
            [NXT_DRY]="NXT:1470E"
            [MK9]="NXT:870H"
            [EXE]="EXE:5000"
        )

        machine_name="$1"
        db_name="$2"

        if [[ -z "$machine_name" || -z "$db_name" ]]; then
            echo "USAGE: dbcreate [MACHINE_ALIAS|MACHINE_VERSION] DB_NAME"
            echo ""
            echo "Available MACHINE_ALIAS values:"
            echo "+---------------|-----------------+"
            echo "| MACHINE_ALIAS | MACHINE_VERSION |"
            echo "+---------------|-----------------+"
            for alias in $(printf "%s\n" "${!MACHINE_ALIAS[@]}" | sort); do
                printf "| %-14s| %-16s|\n" "$alias" "${MACHINE_ALIAS[$alias]}"
            done
            echo "+---------------|-----------------+"

            return 1
        fi

        machine_version="${MACHINE_ALIAS[$machine_name]}"

        [[ -z "$machine_version" ]] && machine_version="$machine_name"

        gtc devbench create -t test -a -M "$machine_version" -p "$db_name"
    }

fi
