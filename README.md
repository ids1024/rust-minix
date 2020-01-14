[![Build Status](https://travis-ci.org/ids1024/rust-minix.svg?branch=master)](https://travis-ci.org/ids1024/rust-minix)

WIP Port of Rust's std to Minix
===============================

Some additional information on this port can by found in [my blog post introducing it](https://iandouglasscott.com/2019/02/18/cross-compiling-rust-code-to-minix/).

For the moment, this is set up to allow cross compiling from Linux. Other systems with Rust compiler may work, but are not tested.

`make` is used to build a copy of `std` targeting Minix. Then the `cargo-minix` script can be used instead of cargo to set all the necessary environmental variables so that the `i586-unknown-minix` target and `std` is available.

`cargo-minix` should either be run in a subdirectory of this repo, or the `.cargo` directory created by `make` must be copied.

```bash
export MINIX_TOOLDIR=~/minix/obj.i386/tooldir.Linux-4.20.1-arch1-1-ARCH-x86_64
export MINIX_ROOT=~/minix/obj.i386/destdir.i386

make update-submodules
make

cargo new --bin hello
cd hello
../cargo-minix build --target i586-unknown-minix --release
cd ..

git clone https://github.com/ids1024/ripgrep -b minix
cd ripgrep
../cargo-minix build --target i586-unknown-minix --release
cd ..
```

**NOTE**: Using a nightly compiler to build std from a fork of the rust repository, as done here, is not supported and not guaranteed to work, since std depends on unstable features that may change in later compiler versions. But the correct solution requires compiling rustc from the same source tree (while takes a long time and a lot of disk space). So this should be fine, but may break at any time (which is fixed by using an older nightly, or merging upstream into the rust fork).
