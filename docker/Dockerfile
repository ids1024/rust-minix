FROM ubuntu:18.04
RUN apt-get update && apt-get install -y git build-essential zlib1g-dev curl file
RUN git clone --depth=1 git://git.minix3.org/minix \
	&& cd minix \
	&& ./build.sh -U -u -mi386 -O build makewrapper \
	&& ./build/tooldir*/bin/nbmake-i386 do-tools do-distrib-dirs includes do-lib \
	&& mv ./build/tooldir* /tooldir \
	&& mv ./build/destdir.i386 /destdir \
	&& cd .. \
	&& rm -rf minix
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
	| sh /dev/stdin -y --default-toolchain nightly-2019-06-19 \
	&& mv /root/.cargo /root/.rustup / \ 
	&& chmod -R 777 /.cargo /.rustup
