FROM ubuntu:18.04
RUN apt-get update && apt-get install -y git build-essential zlib1g-dev curl
RUN git clone git://git.minix3.org/minix \
	&& cd minix \
	&& bash ./releasetools/x86_hdimage.sh \
	&& cd .. \
	&& mv /obj.i386/tooldir* /tooldir \
	&& mv /minix/minix_x86.img / \
	&& mv /obj.i386/destdir.i386 /destdir \
	&& rm -rf minix obj.i386
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh /dev/stdin -y
