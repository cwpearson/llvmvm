#! /usr/bin/env bash

function llvmvm_split_id() {
    local release_re="release[_]?([[:digit:]\.]+)[_]?([a-z0-9]*)"
    local rev_re="r([[:digit:]]+)"
    local bin_re="([[:digit:].]+)-.+-.+"

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
    elif [[ "$1" =~ $bin_re ]]; then
      LLVMVM_TAG=""
      LLVMVM_VER="${BASH_REMATCH[1]}"
      LLVMVM_REL="binary"
    else
      llvmvm_display_error "Unexpected argument in llvmvm_split_id: $1"
      return
    fi
}

function llvmvm_tag_to_id() {
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
    result="$NAME"
}

function llvmvm_rev_to_id() {
  local rev_re="r([[:digit:]]+)"
  
  if [[ "$1" =~ $release_re ]]; then
    NAME="$1" #remove '.'s
  else
    llvmvm_display_error "Unexpected argument in llvmvm_svn_tag_to_name:" $1
    return
  fi
  result="$NAME"
}

function llvmvm_get_llvm_url_for_id() {
    local svn_url="http://llvm.org/svn/llvm-project/llvm"

    llvmvm_split_id "$1"

    if [[ "$LLVMVM_TAG" == "release" ]]; then
      local url="$svn_url/tags/RELEASE_$LLVMVM_VER/$LLVMVM_REL"
    elif [[ "$LLVMVM_TAG" == "r" ]]; then
      local url="$svn_url/trunk"
    elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
      local url="$svn_url/trunk"
    fi

    result="$url"
}

function llvmvm_get_clang_url_for_id() {
    local svn_url="http://llvm.org/svn/llvm-project/cfe"

    llvmvm_split_id "$1"

    if [[ "$LLVMVM_TAG" == "release" ]]; then
      local url="$svn_url/tags/RELEASE_$LLVMVM_VER/$LLVMVM_REL"
    elif [[ "$LLVMVM_TAG" == "r" ]]; then
      local url="$svn_url/trunk"
    elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
      local url="$svn_url/trunk"
    fi

    result="$url"
}

function llvmvm_get_rt_url_for_id() {
    local svn_url="http://llvm.org/svn/llvm-project/compiler-rt"

    llvmvm_split_id "$1"

    if [[ "$LLVMVM_TAG" == "release" ]]; then
      local url="$svn_url/tags/RELEASE_$LLVMVM_VER/$LLVMVM_REL"
    elif [[ "$LLVMVM_TAG" == "r" ]]; then
      local url="$svn_url/trunk"
    elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
      local url="$svn_url/trunk"
    fi

    result="$url"
}

function llvmvm_get_omp_url_for_id() {
    local svn_url="http://llvm.org/svn/llvm-project/openmp"

    llvmvm_split_id "$1"

    if [[ "$LLVMVM_TAG" == "release" ]]; then
      local url="$svn_url/tags/RELEASE_$LLVMVM_VER/$LLVMVM_REL"
    elif [[ "$LLVMVM_TAG" == "r" ]]; then
      local url="$svn_url/trunk"
    elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
      local url="$svn_url/trunk"
    fi

    result="$url"
}

function llvmvm_get_libcxx_url_for_id() {
    local svn_url="http://llvm.org/svn/llvm-project/libcxx"

    llvmvm_split_id "$1"

    if [[ "$LLVMVM_TAG" == "release" ]]; then
      local url="$svn_url/tags/RELEASE_$LLVMVM_VER/$LLVMVM_REL"
    elif [[ "$LLVMVM_TAG" == "r" ]]; then
      local url="$svn_url/trunk"
    elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
      local url="$svn_url/trunk"
    fi

    echo "$url"
}

function llvmvm_get_libcxxabi_url_for_id() {
    local svn_url="http://llvm.org/svn/llvm-project/libcxxabi"

    llvmvm_split_id "$1"

    if [[ "$LLVMVM_TAG" == "release" ]]; then
      local url="$svn_url/tags/RELEASE_$LLVMVM_VER/$LLVMVM_REL"
    elif [[ "$LLVMVM_TAG" == "r" ]]; then
      local url="$svn_url/trunk"
    elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
      local url="$svn_url/trunk"
    fi

    echo "$url"
}

function llvmvm_get_name_for_id() {
    llvmvm_split_id "$1"

  if [[ "$LLVMVM_TAG" == "release" ]]; then
    local name="release_${LLVMVM_VER}_${LLVMVM_REL}"
  elif [[ "$LLVMVM_TAG" == "r" ]]; then
    local name="r$LLVMVM_VER"
  elif [[ "$LLVMVM_TAG" == "trunk" ]]; then
    local name="trunk"
  elif [[ "$LLVMVM_REL" == "binary" ]]; then
    local name="$1"
  else 
    llvmvm_display_fatal "Couldn't get name for id: $1"
  fi

  result="$name"
}

function llvmvm_get_path_for_id() {
  llvmvm_get_name_for_id "$1"
  result="$LLVMVM_ROOT/llvms/$result"
}

function llvmvm_get_path_for_name() {
  result="$LLVMVM_ROOT/llvms/$1"
}

function llvmvm_nproc() {
  case "$(uname -s)" in
   Darwin)
     sysctl -n hw.ncpu
     ;;
   Linux)
     nproc
     ;;
   CYGWIN*|MINGW32*|MSYS*)
     echo 1
     ;;
   *)
     echo 1
     ;;
  esac
}