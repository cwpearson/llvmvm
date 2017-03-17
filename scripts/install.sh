#! /bin/bash

set -eou pipefail

. "$LLVMVM_ROOT/scripts/functions.sh"

read_command_line() {
	if [[ -z ${1+x} ]]; then
		llvmvm_display_fatal "Please provide a version to install"
	fi

	LLVM_ID="$1"
	shift

	BINARY_INSTALL=false
	CUSTOM_CMAKE_FLAGS=""
	CUSTOM_NAME=""
	while getopts "Bc:n:" arg; do
	  case "$arg" in
	  	B)
		  BINARY_INSTALL=true
		  ;;
		c)
		  echo "c is ${OPTARG}"
		  CUSTOM_CMAKE_FLAGS="${CUSTOM_CMAKE_FLAGS} ${OPTARG}"
		  ;;
		n)
		  CUSTOM_NAME="$OPTARG"
		  echo "Using name: $CUSTOM_NAME" 
		  ;;
      esac
	done
}

download_llvm_source() {
	local llvm_src="$1"
	local llvm_src_url="$2"
	local log="$LLVMVM_ROOT/logs/llvm-download.log"
    mkdir -p "$LLVMVM_ROOT/logs"
    mkdir -p "$llvm_src"

	llvmvm_display_message "Downloading LLVM source..."

	echo "$llvm_src_url -> $llvm_src"
	svn co "$llvm_src_url" "$llvm_src" >> "$log"  2>&1 ||
		llvmvm_display_fatal "Couldn't download LLVM source. Check $log"
}

download_clang_source() {
	local clang_src="$1"
	local clang_src_url="$2"
	local log="$LLVMVM_ROOT/logs/clang-download.log"
    mkdir -p "$LLVMVM_ROOT/logs"

	llvmvm_display_message "Downloading Clang source..."
	echo "$clang_src_url -> $clang_src"
	svn co "$clang_src_url" "$clang_src" >> "$log"  2>&1 ||
		llvmvm_display_fatal "Couldn't download Clang source. Check $log"
}

download_rt_source() {
	local rt_src="$1"
	local rt_src_url="$2"
	local log="$LLVMVM_ROOT/logs/rt-download.log"
    mkdir -p "$LLVMVM_ROOT/logs"

	llvmvm_display_message "Downloading compiler-rt source..."
	echo "$rt_src_url -> $rt_src"
	svn co "$rt_src_url" "$rt_src" >> "$log"  2>&1 ||
		llvmvm_display_fatal "Couldn't download compiler-rt source. Check $log"
}

download_libomp_source() {
	local omp_src="$1"
	local omp_src_url="$2"
	local log="$LLVMVM_ROOT/logs/omp-download.log"
    mkdir -p "$LLVMVM_ROOT/logs"

	llvmvm_display_message "Downloading libomp source..."
	echo "$omp_src_url -> $omp_src"
	svn co "$omp_src_url" "$omp_src" >> "$log"  2>&1 ||
		llvmvm_display_fatal "Couldn't download libomp source. Check $log"
}

download_libcxx_source() {
	local cxx_src="$1"
	local cxx_src_url="$2"
	local log="$LLVMVM_ROOT/logs/cxx-download.log"
    mkdir -p "$LLVMVM_ROOT/logs"

	llvmvm_display_message "Downloading libcxx source..."
	echo "$cxx_src_url -> $cxx_src"
	svn co "$cxx_src_url" "$cxx_src" >> "$log"  2>&1 ||
		llvmvm_display_fatal "Couldn't download libcxx source. Check $log"
}

download_libcxxabi_source() {
	local cxx_src="$1"
	local cxx_src_url="$2"
	local log="$LLVMVM_ROOT/logs/cxx-download.log"
    mkdir -p "$LLVMVM_ROOT/logs"

	llvmvm_display_message "Downloading libcxxabi source..."
	echo "$cxx_src_url -> $cxx_src"
	svn co "$cxx_src_url" "$cxx_src" >> "$log"  2>&1 ||
		llvmvm_display_fatal "Couldn't download libcxxabi source. Check $log"
}

create_environment() {
	local name="$1"
	local new_env_file="$LLVMVM_ROOT/environments/$LLVM_ID"

	mkdir -p "$(dirname "$new_env_file")" && touch "$new_env_file"

	echo "export LLVMVM_ROOT; LLVMVM_ROOT=\"$LLVMVM_ROOT\"" > "$new_env_file"
	echo "export PATH; PATH=\"\${LLVMVM_ROOT}/llvms/${name}/ins/bin:\${LLVMVM_ROOT}/bin:\${PATH}\"" >> "$new_env_file"
	echo "export LD_LIBRARY_PATH; LD_LIBRARY_PATH=\"\${LD_LIBRARY_PATH}\"" >> "$new_env_file"
	echo "export DYLD_LIBRARY_PATH; DYLD_LIBRARY_PATH=\"\${DYLD_LIBRARY_PATH}\"" >> "$new_env_file"

	. "$LLVMVM_ROOT/scripts/env/use.sh"
	#. "$LLVMVM_ROOT/scripts/env/implode.sh"
	llvmvm_use "$name" &> /dev/null ||
		llvmvm_display_fatal "Failed to use installed version"

}

configure_source() {
	local ins="$1"
	local obj="$2"
	local src="$3"

	local LOG="$LLVMVM_ROOT/logs/llvm-configure.log"
	mkdir -p "$obj"


	CMAKE_FLAGS="$CUSTOM_CMAKE_FLAGS"
	echo $CMAKE_FLAGS
	if [[ -z "$CMAKE_FLAGS" ]]; then
		CMAKE_FLAGS="-DCMAKE_BUILD_TYPE=Release"
	fi
	CMAKE_FLAGS="$CMAKE_FLAGS -DCMAKE_INSTALL_PREFIX=$ins -B$obj -H$src"

	llvmvm_display_message "Configuring LLVM... with $CMAKE_FLAGS"
	nice -n20 cmake $CMAKE_FLAGS >> "$LOG" 2>&1 ||
		{
			{ echo "" && tail "$LOG"; } ||
			llvmvm_display_fatal "Couldn't configure LLVM. Tail of $LOG above."
		}

}

build_source() {
	local obj="$1"
	local LOG="$LLVMVM_ROOT/logs/llvm-build.log"
	llvmvm_display_message "Building LLVM..."
	nice -n20 make -C $obj -j$(llvmvm_nproc) >> "$LOG" 2>&1 ||
		{
			{ echo "" && cat "$LOG"; } ||
			llvmvm_display_fatal "Couldn't build LLVM. cat of $LOG above."
		}
}

install_source() {
	local ins="$1"
	local obj="$2"
	local LOG="$LLVMVM_ROOT/logs/llvm-install.log"
    mkdir -p "$ins"
	llvmvm_display_message "Installing LLVM..."
    nice -n20 make -C "$obj" install -j$(llvmvm_nproc) >> "$LOG" 2>&1 ||
		{
			{ echo "" && tail "$LOG"; } ||
			llvmvm_display_fatal "Couldn't install LLVM. Tail of $LOG above."
		}
}

echo "install arguments:" "$@"

read_command_line "$@"

# Use custom name if one was provided
if [[ -z ${CUSTOM_NAME} ]]; then # name unset, use default
  llvmvm_get_name_for_id "$LLVM_ID"
  LLVM_NAME="$result"
else
  LLVM_NAME="${CUSTOM_NAME}"
fi

# Determine the path that LLVM will be installed to
llvmvm_get_path_for_name "${LLVM_NAME}" # sets 'result'
LLVMVM_LLVM_PATH="$result"

BASE="$LLVMVM_LLVM_PATH"
LLVM_SRC="$BASE/src"
LLVM_OBJ="$BASE/obj"
LLVM_INS="$BASE/ins"

if [ "$BINARY_INSTALL" = false ]; then
	echo "Source install!"
    llvmvm_get_llvm_url_for_id "$LLVM_ID"
    LLVM_SOURCE_URL="$result"
    llvmvm_get_clang_url_for_id "$LLVM_ID"
    CLANG_SOURCE_URL="$result"
	llvmvm_get_rt_url_for_id "$LLVM_ID"
    RT_SOURCE_URL="$result"
    llvmvm_get_omp_url_for_id "$LLVM_ID"
    OMP_SOURCE_URL="$result"
	CXX_SOURCE_URL=`llvmvm_get_libcxx_url_for_id "$LLVM_ID"`
	CXXABI_SOURCE_URL=`llvmvm_get_libcxxabi_url_for_id "$LLVM_ID"`
    download_llvm_source "$LLVM_SRC" "$LLVM_SOURCE_URL"
    download_clang_source "$LLVM_SRC/tools/clang" "$CLANG_SOURCE_URL"
	download_rt_source "$LLVM_SRC/projects/compiler-rt" "$RT_SOURCE_URL"
	download_libomp_source  "$LLVM_SRC/projects/openmp" "$OMP_SOURCE_URL"
	download_libcxx_source  "$LLVM_SRC/projects/libcxx" "$CXX_SOURCE_URL"
	download_libcxxabi_source  "$LLVM_SRC/projects/libcxxabi" "$CXXABI_SOURCE_URL"
    configure_source "$LLVM_INS" "$LLVM_OBJ" "$LLVM_SRC"
    build_source "$LLVM_OBJ"
    install_source "$LLVM_INS" "$LLVM_OBJ"
else
	echo "Binary install!"
    llvmvm_download_extract_binary "$LLVM_INS" "$LLVM_ID" 
fi
create_environment "$LLVM_NAME"