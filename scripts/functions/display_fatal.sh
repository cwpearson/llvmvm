llvmvm_display_fatal() {
	command -v tput &> /dev/null
	if [[ "$?" == "0" ]]  && [[ "$TERM" == "xterm" ]]; then
		tput sgr0
		tput setaf 1
		echo "ERROR: $1" >&2
		tput sgr0
	else
		echo "ERROR: $1" >&2
	fi
	exit 1
}