#! /usr/bin/env bash

function llvmvm_use() {
    echo "in llvmvm_use bash function with args $@"

    if [[ -z "$1" ]]; then
        llvmvm_display_fatal "please specify the installed version (try llvmvm list)"
    fi
    llvmvm_export_path "$1"
    llvmvm_environment_sanitize
}