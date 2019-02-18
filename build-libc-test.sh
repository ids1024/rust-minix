#!/bin/sh

set -e

. ./env.sh

cd libc/libc-test
$XARGO test --target i586-unknown-minix --no-run
