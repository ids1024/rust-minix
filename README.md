WIP Port of Rust's std to Minix
===============================

```bash
MINIX_ROOT=~/minix/obj.i386/destdir.i386 ./build.sh
```

**NOTE**: Using a nightly compiler to build std from a fork of the rust repository, as done here, is not supported and not guaranteed to work, since std depends on unstable features that may change in later compiler versions. But the correct solution requires compiling rustc from the same source tree (while takes a long time and a lot of disk space). So this should be fine, but may break at any time (which is fixed by using an older nightly, or merging upstream into the rust fork).

TODO
----
* Use `pth` for pthreads support, which should remove the need for some hacks