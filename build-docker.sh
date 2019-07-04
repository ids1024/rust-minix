#!/bin/sh

IMAGE=ids1024/rust-minix-build

sudo docker run \
	--rm \
	-it \
	-v "$PWD:/rust-minix:Z" \
	-u $(id -u):$(id -g) \
	-w /rust-minix \
	-e PWD=/rust-minix \
	-e MINIX_TOOLDIR=/tooldir \
	-e MINIX_SYSROOT=/destdir \
	-e PATH=/.cargo/bin:/bin:/usr/bin \
	$IMAGE \
	make libc-test
