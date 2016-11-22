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
  echo "Usage: llvmvm [command]
Description:
  LLVMVM is the LLVM Version Manager
Commands:
  get        - gets the latest code (for debugging)
  use        - select an LLVM version to use
  help       - display this usage text
  implode    - completely remove llvmvm
  install    - install llvm versions
  uninstall  - uninstall llvm versions
  list       - list installed LLVM versions
  listall    - list available versions
"
else
  llvmvm_display_fatal "Unrecognized command line argument: '$command'"
fi
