#! /bin/bash

set -eou pipefail

LLVMS=$LLVMVM_ROOT/llvms

if [ ! -d $LLVMS ]; then
  echo "None downloaded"
  exit 0
fi

ls $LLVMS