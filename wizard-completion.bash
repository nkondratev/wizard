CACHE_FILE="$HOME/.wizard/cache/go_versions.txt"

get_go_versions() {
    if [[ ! -f "$CACHE_FILE" || $(find "$CACHE_FILE" -mtime +7) ]]; then
        curl -s https://go.dev/dl/ \
        | grep -oP 'id="go\K1\.\d+\.\d+' \
        | sort -u -V > "$CACHE_FILE"
    fi
    cat "$CACHE_FILE"
}

_wizard_install() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "$(get_go_versions)" -- "$cur"))
}

_wizard_use() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    if [[ -d "$HOME/.wizard/versions" ]]; then
        local installed_versions
        installed_versions=$(ls "$HOME/.wizard/versions" | sed 's/^go//')
        COMPREPLY=($(compgen -W "$installed_versions" -- "$cur"))
    fi
}

_wizard() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "help use install" -- "$cur"))
        return 0
    fi

    case "${COMP_WORDS[1]}" in
        install) _wizard_install ;;
        use)     _wizard_use ;;
        *)       ;;
    esac
}

complete -F _wizard wizard
