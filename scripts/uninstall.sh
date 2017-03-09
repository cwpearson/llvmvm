#!/usr/bin/env bash

. "$LLVMVM_ROOT/scripts/functions.sh"

[[ "$1" == "" ]] &&
	llvmvm_display_fatal "Please specify the version"

fuzzy_match=$(ls "$LLVMVM_ROOT/llvms" | sort | grep "$1" | head -n 1 | grep "$1") ||
	llvmvm_display_fatal "Invalid version $1"

if [[ -d $LLVMVM_ROOT/llvms/$fuzzy_match ]]; then
	rm -f "$LLVMVM_ROOT/environments/$fuzzy_match" &> /dev/null ||
		llvmvm_display_fatal "Couldn't remove environment files"
	rm -rf "$LLVMVM_ROOT/llvms/$fuzzy_match" &> /dev/null ||
		llvmvm_display_fatal "Couldn't remove LLVM folder"
	llvmvm_display_message "Uninstalled version $fuzzy_match"
else
	llvmvm_display_fatal "Invalid version"
fi