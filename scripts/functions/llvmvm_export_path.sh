#!/usr/bin/env bash

function remove_llvmvm() {
    local var="$1"
    local var_lines=`echo "$var" | tr ":" "\n" | grep -v '^$'`
    local var_without_llvmvm=`echo "$var_lines" | egrep -v "$LLVMVM_ROOT/(llvms|bin)" | tr "\n" ":" | sed 's/:*$//'`
    result="$var_without_llvmvm"
}

function llvmvm_export_path() {
    echo "in llvmvm_export_path bash function"
    echo "with args $@"

    # Remove prior llvmvm-related paths from the path
    remove_llvmvm "$PATH"
    path_without_llvmvm="$result"

    remove_llvmvm "$LD_LIBRARY_PATH"
    ld_without_llvmvm="$result"

    remove_llvmvm "$DYLD_LIBRARY_PATH"
    dyld_without_llvmvm="$result"


	export PATH="$LLVMVM_ROOT/bin:$path_without_llvmvm"
    export LD_LIBRARY_PATH="$ld_without_llvmvm"
    export DYLD_LIBRARY_PATH="$dyld_without_llvmvm"
    export LLVMVM_PATH_BACKUP="$PATH"


    # Add the requested llvm to the path
    llvmvm_get_path_for_name "$1"
    export PATH="$result/ins/bin:$PATH"
    export LD_LIBRARY_PATH="$result/ins/lib:$LD_LIBRARY_PATH"
    export DYLD_LIBRARY_PATH="$result/ins/lib:$DYLD_LIBRARY_PATH"
}