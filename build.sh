#!/bin/sh

set -e

. ./env.sh

git submodule update --init rust libc xargo
git -C rust submodule update --init src/stdsimd

mkdir -p deps
cd deps
	wget -nc https://minix3.org/pkgsrc/packages/3.4.0/i386/All/pth-2.0.7nb4.tgz
	if [ ! -d pth ]; then
		mkdir pth
		cd pth
			tar xf ../pth-2.0.7nb4.tgz
		cd ..
	fi
cd ..

cd hello
$XARGO build --target i586-unknown-minix
