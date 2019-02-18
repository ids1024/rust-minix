ifndef MINIX_TOOLDIR
$(error MINIX_TOOLDIR must be set.)
endif

ifndef MINIX_SYSROOT
$(error MINIX_SYSROOT must be set.)
endif


export XARGO_RUST_SRC := $(PWD)/rust/src
export XARGO_HOME := $(PWD)/.xargo
export RUST_TARGET_PATH := $(PWD)
export RUST_MINIX_DIR := $(PWD)
export PATH := $(PWD)/bin:$(MINIX_TOOLDIR)/bin:$(PATH)
export CC_i586_unknown_minix := i586-elf32-minix-clang
export AR_i586_unknown_minix := i586-elf32-minix-ar


XARGO := $(PWD)/xargo/target/release/xargo
LIBS := deps/pth/lib/libpthread.so


all: hello libc-test

hello: $(LIBS) $(XARGO) hello/Xargo.toml
	cd hello && $(XARGO) build --target i586-unknown-minix

libc-test: $(LIBS) $(XARGO) libc/libc-test/Xargo.toml
	cd libc/libc-test && $(XARGO) test --target i586-unknown-minix --no-run

update-submodules:
	git submodule update --init rust libc xargo
	git -C rust submodule update --init src/stdsimd

clean:
	rm -rf .xargo libc/target hello/target xargo/target deps

%/Xargo.toml: Xargo.toml
	cp $< $@

Xargo.toml: Xargo.toml.in
	sed "s|LIBC|$(PWD)/libc|" $< > $@

$(XARGO):
	cd xargo && cargo build --release

deps/pth/lib/libpthread.so: deps/pth-2.0.7nb4.tgz
	mkdir -p deps/pth
	cd deps/pth && tar xmf ../pth-2.0.7nb4.tgz

deps/pth-2.0.7nb4.tgz:
	mkdir -p deps
	cd deps && wget https://minix3.org/pkgsrc/packages/3.4.0/i386/All/pth-2.0.7nb4.tgz

.PHONY: all clean libc-test hello update-submodules $(XARGO)
