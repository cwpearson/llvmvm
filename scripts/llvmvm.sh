unset LLVMVM_ROOT

export LLVMVM_ROOT="$HOME/.llvmvm"
export PATH="$LLVMVM_ROOT/bin:$PATH"
export LLVMVM_PATH_BACKUP="$PATH"

# [ -f "$LLVMVM_ROOT/environments/default" ] && . "$LLVMVM_ROOT/environments/default"

. "$LLVMVM_ROOT/scripts/env/llvmvm.sh"