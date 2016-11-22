#! /usr/bin/env bash

set -eou pipefail

LLVMVM_ROOT="$HOME/.llvmvm"



# Blow away old install
echo "Removing old" $LLVMVM_ROOT "bin and scripts"
rm -rf "$LLVMVM_ROOT/bin"
rm -rf "$LLVMVM_ROOT/scripts"

echo "Installing llvmvm to" $LLVMVM_ROOT
mkdir -p "$LLVMVM_ROOT"
cp -r bin "$LLVMVM_ROOT"/bin
cp -r scripts "$LLVMVM_ROOT"/scripts