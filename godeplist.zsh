#!/bin/zsh

typeset -A deps

zparseopts -D -A opts d:
local delim="${opts[-d]- }"

go mod graph | while read s d; do
    deps[${s}]="${deps[${s}]} ${d}"
done

print_deps(){
    local dep_path="${1:+${1}${delim}}${2}"
    echo "${dep_path}"
    for c in $(echo ${deps[${2}]} | tr ' ' '\n'); do
        print_deps "${dep_path}" "${c}"
    done
}

search_go_mod(){
    local dir="$(pwd)"
    while :; do
        if [ -f "${dir}/go.mod" ]; then
            echo "${dir}/go.mod"
            return
        fi
        if [ "${dir}" = "/" ]; then
            return
        fi
        dir="$(dirname ${dir})"
    done
}
local go_mod=$(search_go_mod)
[ -z "${go_mod}" ] && exit 1

if [ $# -eq 0 ]; then
    print_deps '' "$(grep '^module' "${go_mod}" | awk '{print $2}')"
else
    print_deps '' "$(grep '^module' "${go_mod}" | awk '{print $2}')" |\
    awk -F "${delim}" \
        -v keys="$(echo "$@" | tr ' ' '|' | sed -e 's/[^|]*/^&/g')" \
        'match($NF,keys)'
fi
