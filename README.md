# LLVM Version Manager

LLVMVM is a tool for installing and managing different versions of LLVM on a single system.

*LLVMVM is very beta, use at your own risk.*

Inspired very heavily by [gvm](https://github.com/moovweb/gvm).

## Installing

Warning - this will delete `~/.llvmvm/bin` and `~/.llvmvm/scripts`

    ./install.sh && source ~/.llvmvm/scripts/llvmvm.sh

## Using

### Quick Start (installing from source)

Check supported LLVM tags

    llvmvm listalltags

Choose a tag to install

    llvmvm install release_391_final

Add the installed version to the path

    llvmvm use release_391_final

### List LLVM versions

List the versions of LLVM that are installed

    llvmvm list

List the llvmvm sources available for download

    llvmvm listalltags

### Advanced LLVM

    Usage: llvmvm install [version] [options]
        -B,  Install from binary
        -c,  Override CMAKE flags

Install revision 217292

    llvmvm install r217292

Install the trunk

    llvmvm install trunk

Install and use a debug build of the trunk

    llvmvm install trunk -c DCMAKE_BUILD_TYPE=Debug
    llvm use trunk

## Upcoming

* Binary downloads
* ~~Custom build flags~~
* Custom names for installs
* Updating an install if trunk
* Choose to keep or remove source and object files
