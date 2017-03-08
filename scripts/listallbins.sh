#! /bin/bash

set -eou pipefail

. "$LLVMVM_ROOT/scripts/functions.sh" || return 1

URL="http://releases.llvm.org/download.html"
HTML=`curl -s $URL`
ALL_LINKS=`echo "$HTML" | grep href`
CLANG_LINKS=`echo "$ALL_LINKS" | grep -Eo "(llvm|clang)\+(llvm|clang)[^>]*.(g|x)z"`

for link in $CLANG_LINKS; do
  BASE_RE="(.*)\.(tar.gz|xz|tgz)"
  if [[ "$link" =~ $BASE_RE ]]; then
    echo ${BASH_REMATCH[1]};
  else
    llvmvm_display_fatal "Unhandled binary link $link"
  fi
done