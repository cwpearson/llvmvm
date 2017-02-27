#! /bin/bash

set -eou pipefail

. "$LLVMVM_ROOT/scripts/functions.sh"

read_command_line() {
	if [[ -z ${1+x} ]]; then
		llvmvm_display_fatal "Please provide a version to install"
	fi

	LLVM_TAG="$1"
	shift

	IS_BINARY_INSTALL=false
	CUSTOM_CMAKE_FLAGS=""
	while getopts "Bc:n:" arg; do
	  case "$arg" in
	  	B)
		  echo "B triggered"
		  echo "doing binary download"
		  IS_BINARY_INSTALL=true
		  ;;
		c)
		  echo "c is ${OPTARG}"
		  echo "using custom cmake flags"
		  CUSTOM_CMAKE_FLAGS="${OPTARG}"
		  ;;
		n)
		  echo "n is ${OPTARG}"
		  echo "custom name not supported!"
		  exit -1
		  ;;
      esac
	done
}

download_llvm_source() {
	local LOG="$LLVMVM_ROOT/logs/llvm-download.log"
    mkdir -p "$LLVMVM_ROOT/logs"
    mkdir -p "$LLVM_SRC"

	llvmvm_display_message "Downloading LLVM source..."
	echo "$LLVM_SOURCE_URL > $LLVM_SRC"
	svn co "$LLVM_SOURCE_URL" "$LLVM_SRC" >> "$LOG"  2>&1 ||
		llvmvm_display_fatal "Couldn't download LLVM source. Check $LOG"
}

download_clang_source() {
	local LOG="$LLVMVM_ROOT/logs/clang-download.log"
    mkdir -p "$LLVMVM_ROOT/logs"

	llvmvm_display_message "Downloading Clang source..."
	echo "$CLANG_SOURCE_URL > $CLANG_SRC"
	svn co "$CLANG_SOURCE_URL" "$CLANG_SRC" >> "$LOG"  2>&1 ||
		llvmvm_display_fatal "Couldn't download Clang source. Check $LOG"
}

create_environment() {
	local new_env_file="$LLVMVM_ROOT/environments/$LLVM_TAG"

	mkdir -p "$(dirname "$new_env_file")" && touch "$new_env_file"

	echo "export LLVMVM_ROOT; LLVMVM_ROOT=\"$LLVMVM_ROOT\"" > "$new_env_file"
	echo "export PATH; PATH=\"\${LLVMVM_ROOT}/llvms/${LLVM_TAG}/ins/bin:\${LLVMVM_ROOT}/bin:\${PATH}\"" >> "$new_env_file"
	echo "export LD_LIBRARY_PATH; LD_LIBRARY_PATH=\"\${LD_LIBRARY_PATH}\"" >> "$new_env_file"
	echo "export DYLD_LIBRARY_PATH; DYLD_LIBRARY_PATH=\"\${DYLD_LIBRARY_PATH}\"" >> "$new_env_file"

	. "$LLVMVM_ROOT/scripts/env/use.sh"
	#. "$LLVMVM_ROOT/scripts/env/implode.sh"
	llvmvm_use "$LLVM_TAG" &> /dev/null ||
		llvmvm_display_fatal "Failed to use installed version"

}

configure_source() {
	local LOG="$LLVMVM_ROOT/logs/llvm-configure.log"
	mkdir -p "$LLVM_OBJ"


	CMAKE_FLAGS="$CUSTOM_CMAKE_FLAGS"
	echo $CMAKE_FLAGS
	if [[ -z "$CMAKE_FLAGS" ]]; then
		# CMAKE_FLAGS="-DCMAKE_BUILD_TYPE=Release"
		CMAKE_FLAGS="-DCMAKE_BUILD_TYPE=Release"
	fi
	CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_INSTALL_PREFIX=$LLVM_INS -B$LLVM_OBJ -H$LLVM_SRC"

	llvmvm_display_message "Configuring LLVM... with $CMAKE_FLAGS"
	nice -n20 cmake $CMAKE_FLAGS >> "$LOG" 2>&1 ||
		{
			{ echo "" && tail "$LOG"; } ||
			llvmvm_display_fatal "Couldn't configure LLVM. Tail of $LOG above."
		}

}

build_source() {
	local LOG="$LLVMVM_ROOT/logs/llvm-build.log"
	llvmvm_display_message "Building LLVM..."
	nice -n20 make -C $LLVM_OBJ -j8 >> "$LOG" 2>&1 ||
		llvmvm_display_fatal "Couldn't build LLVM. Check $LOG"
}

install_source() {
    mkdir -p "$LLVM_INS"
	llvmvm_display_message "Installing LLVM..."
    nice -n20 make -C $LLVM_OBJ install -j8
}

echo "install arguments:" "$@"

read_command_line "$@"

llvmvm_get_llvm_url_for_tag "$LLVM_TAG" # sets 'result'
LLVM_SOURCE_URL="$result"
llvmvm_get_clang_url_for_tag "$LLVM_TAG" # sets 'result'
CLANG_SOURCE_URL="$result"
llvmvm_get_path_for_tag "$LLVM_TAG" # sets 'result'
LLVMVM_LLVM_PATH="$result"

BASE="$LLVMVM_LLVM_PATH"
LLVM_SRC="$BASE/src"
CLANG_SRC="$BASE/src/tools/clang"
LLVM_OBJ="$BASE/obj"
LLVM_INS="$BASE/ins"

if [[ "$IS_BINARY_INSTALL" ]]; then
    download_llvm_source
    download_clang_source
    configure_source
    build_source
    install_source
else
	echo "Binary install!"
	llvmvm_get_version_for_id "$LLVM_ID"
    download_llvm_binary
	download_clang_binary
	install_binaries
fi
create_environment