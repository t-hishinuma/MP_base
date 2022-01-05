FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y  \
    && apt-get install -y wget make \
    && apt-get install -y gcc g++ gfortran \
    && apt-get install -y automake libtool ccache \
    && apt-get install -y autotools-dev libgomp1 libquadmath0 libgmp-dev libmpfr-dev libmpc-dev libqd-dev  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/nakatamaho/mplapack/archive/refs/tags/v1.0.1.tar.gz  \
    && tar xzf v1.0.1.tar.gz \
    && rm -rf v1.0.1.tar.gz

WORKDIR mplapack-1.0.1

RUN cd mplapack/test/compare && bash gen.Makefile.am.sh && cd - \
    && aclocal; autoconf; automake; autoreconf --force --install 

RUN ./configure --enable-gmp --enable-mpfr --enable-qd --enable-dd --enable-double --enable-_Float128 --enable-_Float64x --enable-optimization --with-system-gmp=/usr/lib/x86_64-linux-gnu/ --with-system-mpfr=/usr/lib/x86_64-linux-gnu/ --with-system-mpc=/usr/lib/x86_64-linux-gnu/ --with-system-qd=/usr/lib/x86_64-linux-gnu/ 

RUN make -j `nproc` && make install
