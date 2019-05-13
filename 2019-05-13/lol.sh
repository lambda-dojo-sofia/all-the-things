#!/usr/bin/env bash

set -euo pipefail

get_json() {
    n="$1"
    out="$n.json"
    url="https://xkcd.com/$n/info.0.json"
    if [[ ! -f $out ]]; then
        wget -O"$out~" "$url"
        mv "$out~" "$out"
    fi
}
export -f get_json

download=1

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-download)
            shift
            download=0
            ;;
        --*)
            echo "Usage: $0 [--skip-download]" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [[ $# -eq 0 ]]; then
    echo "Need query" >&2
    exit 1
fi

mkdir -p json
cd json

if [[ $download -eq 1 ]]; then
    max=`wget -O- 'https://xkcd.com/info.0.json' | jq -r .num`
    seq 1 $max | grep -vx 404 | xargs -n 1 -P 10 bash -c 'get_json "$0"'
fi

declare -A idx
declare -A res

get_title() {
    grep -Po '"title":\s*"\K(\\.|[^"])*' "$@"
}

while read n t; do
    for w in $t; do
        idx[$w]="$n ${idx[$w]-}"
    done
done < <( get_title *.json | sed 's/\.json:/ /' |
          tr A-Z a-z | sed 's/[^a-z0-9]/ /g; s/  */ /g' )

for w in "$@"; do
    for n in ${idx[$w]-}; do
        res[$n]=$((${res[$n]-0}+1))
    done
done

sort -nr < <(for n in "${!res[@]}"; do
    printf '%s % 6s %s\n' "${res[$n]}" "($n)" "$(get_title $n.json)"
done)
