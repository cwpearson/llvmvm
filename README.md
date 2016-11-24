# LLVM Version Manager

LLVMVM is a tool for installing and managing different versions of LLVM on a single system.

*LLVMVM is very beta, use at your own risk.*

Inspired very heavily by [gvm](https://github.com/moovweb/gvm).

## Installing

Warning - this will delete `~/.llvmvm/bin` and `~/.llvmvm/scripts`

    ./install.sh && source ~/.llvmvm/scripts/llvmvm.sh

## Using

### Quick Start

    llvmvm install release_390_final
    llvmvm use release_390_final

### List LLVM versions

List the versions of LLVM that are installed

    llvmvm list

List the llvmvm releases available for download

    llvmvm listall

### Installing LLVM

    Usage: llvmvm install [version] [options]
        -n,  Override the default name
        -B,  Install from binary
        -c,  Override CMAKE flags

Install release 3.9.0 final from source

    llvmvm install release390
    llvmvm install release3.9.0final

Install release 3.9.0 rc1 from source

    llvmvm install release3.9.0rc1

Install release 3.9.0 binaries

    llvmvm install release390 -B

Install revision 217292

    llvmvm install r217292

Install the trunk

    llvmvm install trunk

Install and use a debug build of the trunk with a custom name

    llvmvm install trunk -c DCMAKE_BUILD_TYPE=Debug -n trunk-debug
    llvmvm use tunk-debug

Put the binaries from release 3.9.0 in the path

    llvmvm use release3.9.0

## Upcoming

* Binary downloads
* Custom build flags
* Custom names for installs
