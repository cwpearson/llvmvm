#! /bin/bash

set -eou pipefail

. "$LLVMVM_ROOT/scripts/functions.sh" || return 1

URL="http://releases.llvm.org/download.html"
HTML=`curl -s $URL`
ALL_LINKS=`echo "$HTML" | grep href`
CLANG_LINKS=`echo "$ALL_LINKS" | grep -Eo "[[:digit:].]*/(llvm|clang)\+(llvm|clang)[^>]*.(g|x)z"`

echo "$CLANG_LINKS"

# GREP_URL_DESC_RE="clang"
# SUPPORTED_TAG_RE="RELEASE_"
# LIST_RE="final|rc[[:digit:]]+"

# for tag in $TAGS; do
#   if [[ $tag =~ $SUPPORTED_TAG_RE ]]; then
#     SUBDIRS=`svn ls $URL/$tag`
#     PRINT_ROOT=1
#     for d in $SUBDIRS; do
#       if [[ "$tag$d" =~ $LIST_RE ]]; then
#         PRINT_ROOT=0
#         llvmvm_tag_to_id "$tag$d"
#         echo "$result"
#       fi
#     done
#     if [[ $PRINT_ROOT == 1 ]]; then
#       echo "$tag"
#     fi
#   else
#    :
#     # echo "skip" $tag
#   fi
# done
