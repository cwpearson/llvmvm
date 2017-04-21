#!/usr/bin/env bash

function llvmvm_get_binary_link_for_id() {
  local id=$1
  RELEASE_URL="http://releases.llvm.org"
  LIST_URL="http://releases.llvm.org/download.html"

  HTML=`curl -s $LIST_URL`
  ALL_LINKS=`echo "$HTML" | grep href`
  CLANG_LINKS=`echo "$ALL_LINKS" | grep -Eo "(llvm|clang)\+(llvm|clang)[^>]*.(g|x)z"`

  local ver_re="([[:digit:].]+)-"

  for clang_link in $CLANG_LINKS; do
    if [[ $clang_link == *"$id"* ]]; then
      if [[ "$id" =~ $ver_re ]]; then
        result="$RELEASE_URL/${BASH_REMATCH[1]}/$clang_link";
        return 0
      fi
    fi
  done
  llvmvm_display_fatal "Couldn't find binary download link for id: $id"
}

function llvmvm_download_untar() {
  local link=$2
  local dst=$1
  case "$link" in
    *.gz | *.tgz ) 
      curl -s $link | tar -xz -C "$dest"
      ;;
    *.xz)
      curl -s $link | tar -xJ -C "$dest"
      ;;
    *)
      llvmvm_display_fatal "Don't know how to untar $link"
      ;;
  esac
}

function llvmvm_download_extract_binary() {
  local id="$2"
  local dest="$1"
  llvmvm_get_binary_link_for_id "$id"
  link="$result"
  echo "$link -> $dest"
  mkdir -p "$dest"
  llvmvm_download_untar "$dest" "$link" || llvmvm_display_fatal "error downloading and untaring"

  # Move to make consistent with source install structure
  for dir in $dest/*/*; do
    mv $dir $dest/.
  done
  for dir in `find $dest -type d -empty`; do # remove all empty dirs (the one tar created)
    rmdir "$dir";
  done
}
