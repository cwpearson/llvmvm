#! /usr/bin/env bash

function llvmvm_use() {
    echo "in llvmvm_use bash function with args: $@"

    if [[ -z "${1+x}" ]]; then
        llvmvm_display_error "please specify the installed version (try llvmvm list)"
        return 1
    fi

    if [[ ! -d "$LLVMVM_ROOT/llvms/$1" ]]; then
        llvmvm_display_error "couldn't find $1 locally. Try llvm listallbins/listalltags/install"
        return 1
    fi

    llvmvm_export_path "$1"
    llvmvm_environment_sanitize

    if [[ ! -z "${2+x}" ]]; then # if $2 is set
      if [[ "$2" == "--default" ]]; then
        cp "$LLVMVM_ROOT/environments/$1" "$LLVMVM_ROOT/environments/default" || llvmvm_display_error "Couldn't make $1 default"
	  fi
    fi

    llvmvm_display_message "Now using $1"
}