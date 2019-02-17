#!/bin/sh

set -e

. ./env.sh

git submodule update --init rust libc xargo
git -C rust submodule update --init src/stdsimd

cd hello
$XARGO build --target i586-unknown-minix
