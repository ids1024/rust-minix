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
CARGO := rustup run nightly-2019-06-19 cargo
RUST_RELEASEDIR := rust/target/i586-unknown-minix/release


all: .cargo/config $(RUST_RELEASEDIR)/libtest.rlib

libc-test: .cargo/config $(RUST_RELEASEDIR)/libtest.rlib
	cd libc/libc-test && ../../cargo-minix test --target i586-unknown-minix --no-run

clean:
	rm -rf deps .cargo
	cd libc && $(CARGO) clean
	cd rust && $(CARGO) clean

update-submodules:
	git submodule update --init rust libc
	git -C rust submodule update --init src/stdsimd

.cargo/config: $(RUST_RELEASEDIR)/libstd.rlib
	mkdir -p .cargo
	echo "[target.i586-unknown-minix]" > $@
	echo 'rustflags = ["-L$(PWD)/rust/target/i586-unknown-minix/release/deps"]' >> $@

$(RUST_RELEASEDIR)/libstd.rlib: FORCE deps/lib/libpthread.so deps/lib/libsemaphore.so i586-unknown-minix.json
	cd rust/src/$(notdir $(@:.rlib=)) && \
	   env -u CARGO_TARGET_DIR \
	          RUSTFLAGS='-Z force-unstable-if-unmarked' \
	   $(CARGO) build --target i586-unknown-minix \
	                  --features "panic-unwind backtrace" \
	                  --release

$(RUST_RELEASEDIR)/%.rlib: FORCE $(RUST_RELEASEDIR)/libstd.rlib .cargo/config
	cd rust/src/$(notdir $(@:.rlib=)) && \
	   env -u CARGO_TARGET_DIR \
	   $(CARGO) build --target i586-unknown-minix \
	                  --release

deps/lib/libpthread.so: deps/pth-2.0.7nb4.tgz
	tar xf $< -C deps include lib

deps/lib/libsemaphore.so: deps/pthread-sem-1.0nb2.tgz
	tar xf $< -C deps include lib

deps/%.tgz:
	mkdir -p deps
	cd deps && wget https://minix3.org/pkgsrc/packages/3.4.0/i386/All/$(@:deps/%=%)

FORCE: ;

.PHONY: all clean update-submodules libc-test
