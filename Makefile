ifndef MINIX_TOOLDIR
$(error MINIX_TOOLDIR must be set.)
endif

ifndef MINIX_SYSROOT
$(error MINIX_SYSROOT must be set.)
endif


export RUST_TARGET_PATH := $(PWD)
export RUST_MINIX_DIR := $(PWD)
export PATH := $(PWD)/bin:$(MINIX_TOOLDIR)/bin:$(PATH)
export CC_i586_unknown_minix := i586-elf32-minix-clang
export AR_i586_unknown_minix := i586-elf32-minix-ar


all: libstd

clean:
	rm -rf deps rust/target i586-unknown-minix.json

update-submodules:
	git submodule update --init rust libc
	git -C rust submodule update --init src/stdsimd

libstd: deps/pth/lib/libpthread.so i586-unknown-minix.json
	cd rust/src/libstd && \
	   env -u CARGO_TARGET_DIR \
	          RUSTFLAGS='-Z force-unstable-if-unmarked' \
	   cargo build --target i586-unknown-minix \
	               --features "panic-unwind backtrace" \
	               --release

i586-unknown-minix.json: i586-unknown-minix.json.in
	sed "s|%DEPDIR%|$(PWD)/rust/target/i586-unknown-minix/release/deps|" $< > $@

deps/pth/lib/libpthread.so: deps/pth-2.0.7nb4.tgz
	mkdir -p deps/pth
	cd deps/pth && tar xmf ../pth-2.0.7nb4.tgz

deps/pth-2.0.7nb4.tgz:
	mkdir -p deps
	cd deps && wget https://minix3.org/pkgsrc/packages/3.4.0/i386/All/pth-2.0.7nb4.tgz

.PHONY: all clean update-submodules libstd
