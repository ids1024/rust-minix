CARGO := $(PWD)/cargo-minix
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
	git -C rust submodule update --init src/stdsimd src/tools

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
	curl -o $@ https://minix3.org/pkgsrc/packages/3.4.0/i386/All/$(@:deps/%=%)

FORCE: ;

.PHONY: all clean update-submodules libc-test
