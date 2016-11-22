#! /bin/bash

set -eou pipefail

URL="http://llvm.org/svn/llvm-project/llvm/tags"

TAGS=`svn ls $URL`

for t in $TAGS; do
  echo $t;
  subtags=`svn ls $URL/$t`
  for s in $subtags; do
    echo $t$s | awk '$1 ~ /final|rc[[:digit:]]+/'
  done
done