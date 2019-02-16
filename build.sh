#!/bin/sh

if [ -z "$MINIX_ROOT" ]; then
	echo "\$MINIX_ROOT must be set."
	exit 1
fi

export XARGO_RUST_SRC=$PWD/rust/src
export RUST_TARGET_PATH=$PWD
export RUSTFLAGS=-L$MINIX_ROOT/usr/lib

XARGO="rustup run nightly cargo run --manifest-path $PWD/xargo/Cargo.toml --"

git submodule update --init rust libc xargo
git -C rust submodule update --init src/stdsimd

cd hello
$XARGO build --target i586-unknown-minix
