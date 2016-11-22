#!/usr/bin/env bash

. "$LLVMVM_ROOT/scripts/functions.sh" || return 1

function llvmvm() {

    echo "in llvmvm bash function"
    mkdir -p "$LLVMVM_ROOT/environments"

    command="$1"
    if [[ "$command" == "use" ]]; then
        . "$LLVMVM_ROOT/scripts/env/use.sh"
        shift
        llvmvm_use "$@"
    else
        "$LLVMVM_ROOT/bin/llvmvm.sh" "$@"
    fi
}