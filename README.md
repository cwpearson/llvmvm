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

    llvmvm install RELEASE_391/final

Add the installed version to the path

    llvmvm use RELEASE_391/final

### Quick Start (installing binaries)

Coming soon\*...

\* whenever I get to it.

### List LLVM versions

List the versions of LLVM that are installed

    llvmvm list

List the llvmvm sources available for download

    llvmvm listalltags

### Installing LLVM

    Usage: llvmvm install [version] [options]
        -B,  Install from binary
        -c,  Override CMAKE flags

Install a tag

    llvmvm install RELEASE_391/final

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
* Updating trunk install
* Choose to keep/remove object files
