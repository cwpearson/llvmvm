#! /usr/bin/env bash

function llvmvm_use() {
    echo "in llvmvm_use bash function with args $@"

    if [[ -z "$1" ]]; then
        llvmvm_display_fatal "please specify the installed version (try llvmvm list)"
    fi

    if [[ ! -d "$LLVMVM_ROOT/llvms/$1" ]]; then
        llvmvm_display_fatal "couldn't find $1 locally. Try llvm listallbins/listalltags/install"
    fi

    llvmvm_export_path "$1"
    llvmvm_environment_sanitize

    if [[ ! -z "${2+x}" ]]; then # if $2 is set
      if [[ "$2" == "--default" ]]; then
        cp "$LLVMVM_ROOT/environments/$1" "$LLVMVM_ROOT/environments/default" || display_error "Couldn't make $1 default"
	  fi
    fi
}