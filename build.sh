#!/bin/sh

set -e

if [ -z "$MINIX_TOOLDIR" ]; then
	echo "\$MINIX_TOOLDIR must be set."
	exit 1
fi

if [ -z "$MINIX_SYSROOT" ]; then
	echo "\$MINIX_SYSROOT must be set."
	exit 1
fi

XARGO="rustup run nightly cargo run --manifest-path $PWD/xargo/Cargo.toml --"

export XARGO_RUST_SRC=$PWD/rust/src
export XARGO_HOME=$PWD/.xargo
export RUST_TARGET_PATH=$PWD
export PATH=$PWD/bin:$MINIX_TOOLDIR/bin:$PATH
export CC_i586_unknown_minix=i586-elf32-minix-clang
export AR_i586_unknown_minix=i586-elf32-minix-ar

git submodule update --init rust libc xargo
git -C rust submodule update --init src/stdsimd

cd hello
$XARGO build --target i586-unknown-minix
