#! /usr/bin/env bash

function llvmvm_split_id() {
    local release_re="release([[:digit:]\.]+)([a-z0-9]*)"
    local rev_re="r([[:digit:]]+)"

    if [[ "$1" =~ $release_re ]]; then
      LLVMVM_TAG="release"
      LLVMVM_VER="${BASH_REMATCH[1]//.}" #remove '.'s
      LLVMVM_REL="${BASH_REMATCH[2]}"
      if [[ "x$LLVMVM_REL" == "x" ]]; then # unspecified release is FINAL
        LLVMVM_REL="final"
      fi
    elif [[ "$1" =~ $rev_re ]]; then
      LLVMVM_TAG="r"
      LLVMVM_VER="${BASH_REMATCH[1]}"
      LLVMVM_REL=""
    elif [[ "$1" == "trunk" ]]; then
      LLMVVM_TAG="trunk"
      LLVMVM_VER=""
      LLVMVM_REL=""
    else
      display_error "Unexpected install argument in llvmvm_get_url_for_name"
      return
    fi
}

function llvmvm_get_llvm_url_for_id() {
    echo "In bash function llvmvm_get_llvm_url_from_id"

    local svn_tag_url="http://llvm.org/svn/llvm-project/llvm/tags"
    local svn_trunk_url="http://llvm.org/svn/llvm-project/llvm/trunk"

    llvmvm_split_id "$1"

    if [[ "$LLVMVM_TAG" == "release" ]]; then
      local url="$svn_tag_url/RELEASE_$LLVMVM_VER/$LLVMVM_REL"
    elif [[ "$LLVMVM_TAG" == "r" ]]; then
      local url="$svn_trunk_url"
    elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
      local url="$svn_trunk_url"
    fi

    result="$url"
}

function llvmvm_get_clang_url_for_id() {
    echo "In bash function llvmvm_get_clang_url_from_id"

    local svn_tag_url="http://llvm.org/svn/llvm-project/cfe/tags"
    local svn_trunk_url="http://llvm.org/svn/llvm-project/cfe/trunk"

    llvmvm_split_id "$1"

    if [[ "$LLVMVM_TAG" == "release" ]]; then
      local url="$svn_tag_url/RELEASE_$LLVMVM_VER/$LLVMVM_REL"
    elif [[ "$LLVMVM_TAG" == "r" ]]; then
      local url="$svn_trunk_url"
    elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
      local url="$svn_trunk_url"
    fi

    result="$url"
}

function llvmvm_get_path_for_id() {

  llvmvm_split_id "$1"

  if [[ "$LLVMVM_TAG" == "release" ]]; then
    local path="${LLVMVM_TAG}_${LLVMVM_VER}_${LLVMVM_REL}"
  elif [[ $LLVMVM_TAG == "r" ]]; then
    local path="$LLVM_TAG$LLVMVM_VER"
  elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
    local path="$LLVM_TAG"
  fi

  result="$LLVMVM_ROOT/llvms/$path"
}

function llvmvm_get_path_for_name() {
  result="$LLVMVM_ROOT/llvms/$1"
}