llvmvm_display_message() {
	command -v tput &> /dev/null
	if [[ "$?" == "0" ]]  && [[ "$TERM" == "xterm" ]]; then
		# GREEN!
		tput sgr0
		tput setaf 2
		echo "$1"
		tput sgr0
	else
		echo "$1"
	fi
}