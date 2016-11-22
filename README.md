# Readme #

LLVMVM is a tool for installing and managing different versions of LLVM on a single system.

*LLVMVM is very beta, use at your own risk.*

Inspired very heavily by [gvm](https://github.com/moovweb/gvm).

## Installing

Warning - this will delete `~/.llvmvm/bin` and `~/.llvmvm/scripts`

    ./install.sh && source ~/.llvmvm/scripts/llvmvm.sh

## Using

### List LLVM versions

List the versions of LLVM that are installed

    llvmvm list

List the llvmvm releases available for download

    llvmvm listall

### Installing LLVM

    Usage: llvmvm install [version] [options]
        -n,  Override the default name
        -B,  Install from binary
        -c,  Pass flags to CMAKE

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

    llvm install trunk

Put the binaries from release 3.9.0 in the path

    llvmvm use release3.9.0