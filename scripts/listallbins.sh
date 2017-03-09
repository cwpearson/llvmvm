#! /bin/bash

set -eou pipefail

. "$LLVMVM_ROOT/scripts/functions.sh" || return 1

URL="http://releases.llvm.org/download.html"
HTML=`curl -s $URL`
ALL_LINKS=`echo "$HTML" | grep href`
CLANG_LINKS=`echo "$ALL_LINKS" | grep -Eo "(llvm|clang)\+(llvm|clang)[^>]*.(g|x)z"`

BASE_RE="(clang|llvm)\+(llvm|clang)-(.*)"
EXT_RE1="(\.tar\.gz|\.tar\.xz)"
EXT_RE2="(\.tgz|\.xz)"

for link in $CLANG_LINKS; do
  if [[ "$link" =~ $BASE_RE$EXT_RE1 ]]; then
    echo "${BASH_REMATCH[3]}";
  elif [[ "$link" =~ $BASE_RE$EXT_RE2 ]]; then
    echo "${BASH_REMATCH[3]}"
  else
    llvmvm_display_fatal "Unhandled binary link $link"
  fi
done