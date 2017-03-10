#! /bin/bash

set -eou pipefail

echo "Falling back to $LLVMVM_ROOT/bin/llvmvm.sh..."

. "$LLVMVM_ROOT/scripts/functions.sh" || exit 1

command=$1
#if [[ $command == "implode" ]]; then
#  llvmvm_implode
#	exit 0
# fi

#"$LLVMVM_ROOT/scripts/llvmvm-check"
#if [[ "$?" != "0" ]]; then
#	llvmvm_display_fatal "Missing requirements."
#fi

if [ -f "$LLVMVM_ROOT/scripts/$command.sh" ]; then
  echo $command
  shift
  "$LLVMVM_ROOT/scripts/$command.sh" "$@"
elif [[ -z $command || $command = help ]]; then
  echo "Usage: llvmvm [command] [version] [options]
    Description:
      LLVMVM is the LLVM Version Manager
    
    Available Options:
        -B,         Binary download
        -c,         Override CMAKE flags
        -n,         Provide a custom name for an install
        --default,  (with 'use' command, sets an install as the default LLVM)

    Available Commands:
        help,         Display something like this message
        install,      Install an LLVM
        uninstall,    Remove an installed LLVM
        listalltags,  List support LLVM tags
        listallbins,  List supported LLVM binaries
        list,         List installed LLVMs
        use,          Switch to use an installed LLVM (with --default to set default llvmvm for future shells)
"
else
  llvmvm_display_fatal "Unrecognized command line argument: '$command'"
fi
