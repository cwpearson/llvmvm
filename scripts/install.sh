#! /bin/bash

set -eou pipefail

. "$LLVMVM_ROOT/scripts/functions.sh"

read_command_line() {
	if [ -z ${1+x} ]; then
		display_fatal "Please provide a version to install"
	fi

	LLVM_ID="$1"
	LLVM_NAME="$LLVM_ID"
	shift

	if [ -z ${1+x} ]; then
		:
	else
		llvmvm_display_error "More than zero flags provided. Perhaps that function is not implemented."
	fi
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
	local new_env_file="$LLVMVM_ROOT/environments/$LLVM_NAME"

	mkdir -p "$(dirname "$new_env_file")" && touch "$new_env_file"

	echo "export LLVMVM_ROOT; LLVMVM_ROOT=\"$LLVMVM_ROOT\"" > "$new_env_file"

	echo "export PATH; PATH=\"\${LLVMVM_ROOT}/llvms/${LLVM_NAME}/ins/bin:\${LLVMVM_ROOT}/bin:\${PATH}\"" >> "$new_env_file"
	echo "export LD_LIBRARY_PATH; LD_LIBRARY_PATH=\"\${LD_LIBRARY_PATH}\"" >> "$new_env_file"
	echo "export DYLD_LIBRARY_PATH; DYLD_LIBRARY_PATH=\"\${DYLD_LIBRARY_PATH}\"" >> "$new_env_file"

	. "$LLVMVM_ROOT/scripts/env/use.sh"
	#. "$LLVMVM_ROOT/scripts/env/implode.sh"
	llvmvm_use "$LLVM_NAME" &> /dev/null ||
		llvmvm_display_fatal "Failed to use installed version"

}

configure_source() {
	local LOG="$LLVMVM_ROOT/logs/llvm-configure.log"
	mkdir -p "$LLVM_OBJ"
	llvmvm_display_message "Configuring LLVM..."
	nice -n20 cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$LLVM_INS -B$LLVM_OBJ -H$LLVM_SRC >> "$LOG" 2>&1 ||
		llvmvm_display_fatal "Couldn't configure LLVM. Check $LOG"
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

llvmvm_get_llvm_url_for_id "$LLVM_ID" # sets 'result'
LLVM_SOURCE_URL="$result"
llvmvm_get_clang_url_for_id "$LLVM_ID" # sets 'result'
CLANG_SOURCE_URL="$result"

if [[ "$LLVM_NAME" == "$LLVM_ID" ]]; then # default name
	llvmvm_get_path_for_id "$LLVM_ID"
	LLVMVM_LLVM_PATH="$result"
else 
	llvmvm_get_path_for_name "$LLVM_NAME"
	LLVMVM_LLVM_PATH="$result"
fi



BASE="$LLVMVM_LLVM_PATH"
LLVM_SRC="$BASE/src"
CLANG_SRC="$BASE/src/tools/clang"
LLVM_OBJ="$BASE/obj"
LLVM_INS="$BASE/ins"

download_llvm_source
download_clang_source
configure_source
build_source
install_source
create_environment