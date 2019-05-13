#!/usr/bin/env bash

set -euo pipefail

mkdir -p json

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
query=()

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

if [[ $download -eq 1 ]]; then
    max=`wget -O- 'https://xkcd.com/info.0.json' | jq -r .num`
    pushd json
    seq 1 $max | xargs -n 1 -P 10 bash -c 'get_json "$0"'
    popd
fi

declare -A idx
declare -A res

while read n words; do
    for w in $words; do
        idx[$w]="$n ${idx[$w]-}"
    done
done < <(
    jq -r '(.num | tostring) + " " + .title' json/*.json |
        tr A-Z a-z | sed 's/[^a-z0-9]/ /g; s/  */ /g'
)

for word in "$@"; do
    for id in ${idx[$word]}; do
        res[$id]=$((${res[$id]-0}+1))
    done
done

sort -nr < <(for id in "${!res[@]}"; do
    printf '%s % 6s %s\n' "${res[$id]}" "($id)" "$(jq -r .title json/$id.json)"
done)
