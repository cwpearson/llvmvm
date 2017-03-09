#!/usr/bin/env bash

function llvmvm_export_path() {
    echo "in llvmvm_export_path bash function"
    echo "with args $@"

    echo "Path before:"
    echo $PATH

    # Remove prior llvmvm-related paths from the path
    path_lines=`echo "$PATH" | tr ":" "\n" | grep -v '^$'`
    path_without_llvmvm=`echo "$path_lines" | egrep -v "$LLVMVM_ROOT/(llvms|bin)" | tr "\n" ":" | sed 's/:*$//'`
    echo "cleaned path"

    echo $PATH

    # Add llvmvm back to the path
	export PATH="$LLVMVM_ROOT/bin:$path_without_llvmvm"
    export LLVMVM_PATH_BACKUP="$PATH"

    # Add the requested llvm to the path
    llvmvm_get_path_for_name "$1"
    local path="$result/ins/bin"
    export PATH="$path:$PATH"
}