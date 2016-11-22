#!/usr/bin/env bash
for function in $LLVMVM_ROOT/scripts/functions/*; do
	. "$function"
done