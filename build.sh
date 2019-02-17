#!/bin/sh

set -e

if [ -z "$MINIX_ROOT" ]; then
	echo "\$MINIX_ROOT must be set."
	exit 1
fi

LIB="$MINIX_ROOT/usr/lib"
XARGO="rustup run nightly cargo run --manifest-path $PWD/xargo/Cargo.toml --"

export XARGO_RUST_SRC=$PWD/rust/src
export XARGO_HOME=$PWD/.xargo
export RUST_TARGET_PATH=$PWD

link_arg() {
	echo "\"-C\", \"link-arg=$1\","
}

pre_link_arg() {
	echo "\"-Z\", \"pre-link-arg=$1\","
}

cargo_config() {
	echo "[target.i586-unknown-minix]"
	echo "rustflags = ["
	link_arg "-L=$LIB"
	link_arg "-lc"
	link_arg "--dynamic-linker=/usr/libexec/ld.elf_so"
	link_arg "--no-rosegment"
	for i in crt0.o crti.o crtbegin.o; do
		pre_link_arg "$LIB/$i"
	done
	for i in crtend.o crtn.o; do
		link_arg "$LIB/$i"
	done
	echo "]"
}

cargo_config > .cargo/config

git submodule update --init rust libc xargo
git -C rust submodule update --init src/stdsimd

cd hello
$XARGO build --target i586-unknown-minix
