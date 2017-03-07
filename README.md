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

Warning - this will delete `~/.llvmvm/bin` and `~/.llvmvm/scripts`

    ./install.sh && source ~/.llvmvm/scripts/llvmvm.sh

## Removing

Remove `~/.llvmvm` and open a new terminal.

## Using

In a new terminal, run `source ~/.llvmvm/scripts/llvmvm.sh`.

### Quick Start (installing from source)

Check supported LLVM tags

    llvmvm listalltags

Choose a tag to install

    llvmvm install release_391_final

Add the installed version to the path. This must be done for every new terminal.

    llvmvm use release_391_final

### List LLVM versions

List the versions of LLVM that are installed

    llvmvm list

List the llvmvm sources available for download

    llvmvm listalltags

List the llvmvm binaries available for download

    llvmvm listalltbins

### "Advanced" LLVMVM

    Usage: llvmvm install [version] [options]
        -c,  Override CMAKE flags
        -n,  Provide a custom name for an install

Install revision 217292

    llvmvm install r217292

Install the trunk

    llvmvm install trunk

Install and use a debug build of the trunk, with a custom name

    llvmvm install trunk -c DCMAKE_BUILD_TYPE=Debug -n trunk-debug
    llvm use trunk-debug

## Upcoming (in rough order of priority)

* ~~Custom CMAKE build flags~~
* ~~Custom names for installs~~
* Binary downloads
* Set a default llvm version
* Updating a trunk install
* Choose to keep or remove source and object files