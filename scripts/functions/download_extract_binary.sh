#!/usr/bin/env bash

function llvmvm_get_binary_link_for_id() {
  local id=$1
  RELEASE_URL="http://releases.llvm.org"
  LIST_URL="http://releases.llvm.org/download.html"

  HTML=`curl -s $LIST_URL`
  ALL_LINKS=`echo "$HTML" | grep href`
  CLANG_LINKS=`echo "$ALL_LINKS" | grep -Eo "(llvm|clang)\+(llvm|clang)[^>]*.(g|x)z"`

  # local ver_re="([[:digit:].]+)-"
  local ver_re="([[:digit:].]+)-"

  for clang_link in $CLANG_LINKS; do
    if [[ $clang_link == *"$id"* ]]; then
      if [[ "$id" =~ $ver_re ]]; then
        result="$RELEASE_URL/${BASH_REMATCH[1]}/$clang_link";
        return
      fi
    fi
  done
  llvmvm_display_fatal "Couldn't find binary download link for id: $id"
}

function llvmvm_download_extract_binary() {
	local id="$2"
  local dest="$1"
  echo "$id -> $dest"
	llvmvm_get_binary_link_for_id "$id"
	link="$result"
	echo "$link -> $dest"
  mkdir -p "$dest"
  curl -s $link | tar -xJ -C "$dest"
}