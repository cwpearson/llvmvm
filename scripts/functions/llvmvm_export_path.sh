#!/usr/bin/env bash

function llvmvm_export_path() {
    echo "in llvmvm_export_path bash function"
    echo "with args $@"

    path_lines=`echo "$PATH" | tr ":" "\n" | "$GREP_PATH" -v '^$'`
    path_without_llvmvm=`echo "$path_lines" | egrep -v "$LLVMVM_ROOT/(llvms|bin)" | tr "\n" ":" | sed 's/:*$//'`
    echo "cleaned path"

	export PATH="$LLVMVM_ROOT/bin:$path_without_llvmvm"
    export LLVMVM_PATH_BACKUP="$PATH"

    llvmvm_get_path_for_name "$1"
    local path="$result/ins/bin"

    export PATH="$path:$PATH"
}