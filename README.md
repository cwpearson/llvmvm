# LLVM Version Manager

| master  | ![travis-master]  |
|---------|-------------------|
| develop | ![travis-develop] |
[travis-master]: https://travis-ci.org/cwpearson/llvmvm.svg?branch=master
[travis-develop]: https://travis-ci.org/cwpearson/llvmvm.svg?branch=develop

LLVMVM is a tool for installing and managing different versions of LLVM on a single system. It presently works for relatively recent versions of LLVM.

*LLVMVM is very beta, use at your own risk.*

Inspired very heavily by [gvm](https://github.com/moovweb/gvm).

## Installing

    bash < <(curl -s -S -L https://raw.githubusercontent.com/cwpearson/llvmvm/master/binscripts/llvmvm-installer)

This will download the LLVMVM scripts to `$HOME/.llvmvm`, and modify your `.bashrc` (or equivalent) to source the LLVMVM environment scripts.

## Removing

Delete `$HOME/.llvmvm`. Optionally also remove a line like

    [[ -s "/home/username/.llvmvm/scripts/llvmvm.sh" ]] && source "/home/username/.llvmvm/scripts/llvmvm.sh"

from your `.bashrc` or equivalent


### Quick Start (installing from source)

Check supported LLVM tags

    llvmvm listalltags

Choose a tag to install

    llvmvm install release_391_final

Add the installed version to the path. This must be done for every new terminal in the future.

    llvmvm use release_391_final

### Quick Start (installing binaries)

Check supported LLVM binaries

    llvmvm listallbins

Choose a binary to install (**note -B flag**)

    llvmvm install 3.2-x86_64-linux-ubuntu-12.04 -B

Add the installed version to the path. This must be done for every new terminal in the future.

    llvmvm use 3.2-x86_64-linux-ubuntu-12.04

### List LLVM versions

List the versions of LLVM that are installed

    llvmvm list

List the llvmvm sources available for download

    llvmvm listalltags

List the llvmvm binaries available for download

    llvmvm listallbins

### "Advanced" LLVMVM Examples

    Usage: llvmvm [command] [version] [options]
    
    Available Options:
        -B,  Binary download
        -c,  Override CMAKE flags
        -n,  Provide a custom name for an install

    Available Commands:
        help,         Display something like this message
        install,      Install an LLVM
        listalltags,  List support LLVM tags
        listallbins,  List supported LLVM binaries
        list,         List installed LLVMs
        use,          Switch to use an installed LLVM (with --default to set default llvmvm for future shells)


Install revision 217292

    llvmvm install r217292

Install the trunk

    llvmvm install trunk

Install and use a debug build of the trunk, with a custom name. Use that as the default llvm for all new shells.

    llvmvm install trunk -c DCMAKE_BUILD_TYPE=Debug -n trunk-debug
    llvm use trunk-debug --default

## Upcoming (in rough order of priority)

* ~~Custom CMAKE build flags~~
* ~~Custom names for installs~~
* ~~Binary downloads~~
* ~~Set a default llvm version~~
* Add an uninstall command
* Updating a trunk install
* Choose to keep or remove source and object files