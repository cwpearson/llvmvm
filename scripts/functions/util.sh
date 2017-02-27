#! /usr/bin/env bash

function llvmvm_split_tag() {
    local release_re="release[_]?([[:digit:]\.]+)[_]?([a-z0-9]*)"
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
      LLVMVM_TAG="trunk"
      LLVMVM_VER=""
      LLVMVM_REL=""
    else
      llvmvm_display_error "Unexpected argument in llvmvm_split_id:" $1
      return
    fi
}

function llvmvm_svn_tag_to_name() {
    local release_re="RELEASE_([[:digit:]]+)/*([a-z0-9]*)"

    local NAME="release_"

    if [[ "$1" =~ $release_re ]]; then
      NAME="${NAME}${BASH_REMATCH[1]//.}" #remove '.'s
      if [[ "${BASH_REMATCH[2]}" ]]; then
        NAME="${NAME}_${BASH_REMATCH[2]}"
      fi
    else
      llvmvm_display_error "Unexpected argument in llvmvm_svn_tag_to_name:" $1
      return
    fi
    RESULT="$NAME"
}

function llvmvm_get_llvm_url_for_tag() {
    echo "In bash function llvmvm_get_llvm_url_for_tag"

    local svn_tag_url="http://llvm.org/svn/llvm-project/llvm/tags"
    local svn_trunk_url="http://llvm.org/svn/llvm-project/llvm/trunk"

    if [[ "$1" == "trunk" ]]; then
      local url="$svn_trunk_url";
    else
      local url="$svn_tag_url/$1";
    fi

    result="$url"
}

function llvmvm_get_clang_url_for_tag() {
    echo "In bash function llvmvm_get_clang_url_for_id"

    local svn_tag_url="http://llvm.org/svn/llvm-project/cfe/tags"
    local svn_trunk_url="http://llvm.org/svn/llvm-project/cfe/trunk"

    if [[ "$1" == "trunk" ]]; then
      local url="$svn_trunk_url";
    else
      local url="$svn_tag_url/$1";
    fi

    result="$url"
}

function llvmvm_get_path_for_name() {
  result="$LLVMVM_ROOT/llvms/$1"
}

function llvmvm_get_path_for_tag() {
  result="$LLVMVM_ROOT/llvms/$1"
}