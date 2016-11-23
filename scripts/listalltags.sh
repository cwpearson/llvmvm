#! /bin/bash

set -eou pipefail

. "$LLVMVM_ROOT/scripts/functions.sh" || return 1

URL="http://llvm.org/svn/llvm-project/llvm/tags"

TAGS=`svn ls $URL`

SUPPORTED_TAG_RE="RELEASE_"
LIST_RE="final|rc[[:digit:]]+"

for tag in $TAGS; do
  if [[ $tag =~ $SUPPORTED_TAG_RE ]]; then
    SUBDIRS=`svn ls $URL/$tag`
    PRINT_ROOT=1
    for d in $SUBDIRS; do
      if [[ "$tag$d" =~ $LIST_RE ]]; then
        PRINT_ROOT=0
        # echo "trying $tag$d"
        llvmvm_svn_tag_to_name "$tag$d"
        echo "$RESULT"
      fi
    done
    if [[ $PRINT_ROOT == 1 ]]; then
      # echo "trying $tag"
      llvmvm_svn_tag_to_name "$tag"
      echo "$RESULT"
    fi
  else
   :
    # echo "skip" $tag
  fi
done
