# LLVM Version Manager

| master  | ![travis-master]  |
|---------|-------------------|
| develop | ![travis-develop] |
[travis-master]: https://travis-ci.org/cwpearson/llvmvm.svg?branch=master
[travis-develop]: https://travis-ci.org/cwpearson/llvmvm.svg?branch=develop

LLVMVM is a tool for installing and managing different versions of LLVM on a single system. It presently works for relatively recent versions of LLVM.

Inspired very heavily by [gvm](https://github.com/moovweb/gvm).

## Installing

This will download the LLVMVM scripts to `$HOME/.llvmvm`, and modify your `.bashrc` (or equivalent) to source the LLVMVM environment scripts.

To install release v0.1.1

    bash < <(curl -s -S -L https://raw.githubusercontent.com/cwpearson/llvmvm/v0.1.1/binscripts/llvmvm-installer)

To install the most recent revision (check 'master' build status above)

    bash < <(curl -s -S -L https://raw.githubusercontent.com/cwpearson/llvmvm/master/binscripts/llvmvm-installer)


## Removing

Delete `$HOME/.llvmvm`. Optionally also remove a line like

    [[ -s "/home/username/.llvmvm/scripts/llvmvm.sh" ]] && source "/home/username/.llvmvm/scripts/llvmvm.sh"

from your `.bashrc` or equivalent


### Quick Start (installing an LLVM from source)

Check supported LLVM tags

    llvmvm listalltags

Choose a tag to install

    llvmvm install release_391_final

Add the installed version to the path. This must be done for every new terminal in the future.

    llvmvm use release_391_final

### Quick Start (installing LLVM binaries)

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

### Uninstall an LLVM

List the installed versions of LLVM

    llvmvm list

Choose a version to remove

    llvmvm uninstall [version]

### "Advanced" LLVMVM Examples

    Usage: llvmvm [command] [version] [options]
    Description:
      LLVMVM is the LLVM Version Manager
    
    Available Options:
        -B,         Binary download
        -c,         Override CMAKE flags
        -n,         Provide a custom name for an install
        --default,  (with 'use' command, sets an install as the default LLVM)

    Available Commands:
        help,         Display something like this message
        install,      Install an LLVM
        uninstall,    Remove an installed LLVM
        listalltags,  List support LLVM tags
        listallbins,  List supported LLVM binaries
        list,         List installed LLVMs
        use,          Switch to use an installed LLVM (with --default to set default llvmvm for future shells)


Install revision 217292

    llvmvm install r217292

Install the trunk

    llvmvm install trunk

Install a debug build of the trunk, with a custom name. Use that as the default llvm for all new shells.

    llvmvm install trunk -c DCMAKE_BUILD_TYPE=Debug -n trunk-debug
    llvmvm use trunk-debug --default

## Upcoming (in rough order of priority)

* Updating a trunk install
* Build more LLVM components during source install (openmp, libcxx, etc...)
* Choose to keep or remove source and object files