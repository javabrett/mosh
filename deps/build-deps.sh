#!/usr/bin/env bash

set -euo pipefail

PWD=$(pwd)
TMUX_SRC_DIR=${PWD}/tmux-2.6
LIBEVENT_SRC_DIR=${PWD}/libevent-2.1.8-stable
NCURSES_SRC_DIR=${PWD}/ncurses-6.0
PROTOBUF_SRC_DIR=${PWD}/protobuf-3.4.1
MOSH_SRC_DIR=${PWD}/mosh-1.3.2
OPENSSL_SRC_DIR=${PWD}/openssl-1.0.2l
GPM_SRC_DIR=${PWD}/gpm-1.20.7

export INSTALL_DIR=/usr/local/mosh
export CFLAGS="-I${INSTALL_DIR}/include -fPIC"
export CXXFLAGS="${CFLAGS}"
export PATH="${INSTALL_DIR}/bin:${PATH}"
export LDFLAGS="-L${INSTALL_DIR}/lib -Wl,-rpath,${INSTALL_DIR}/lib"
export PKG_CONFIG_PATH="${INSTALL_DIR}/lib/pkgconfig"
export LD_LIBRARY_PATH="${INSTALL_DIR}/lib"

MAKEOPTS="-j4"

cd $LIBEVENT_SRC_DIR
make clean || echo
./configure --enable-static=yes --enable-shared=yes --prefix=${INSTALL_DIR}
make ${MAKEOPTS}
make install

cd $OPENSSL_SRC_DIR
make clean || echo
./config no-shared -fPIC --prefix=${INSTALL_DIR}
make ${MAKEOPTS}
make install

echo "Building protobuf..."
cd $PROTOBUF_SRC_DIR
make clean || echo
./configure --disable-shared --prefix=${INSTALL_DIR}
make ${MAKEOPTS}
make install

NCURSES_CONFIGURE_OPTS="--enable-pc-files --without-gpm --with-pkg-config --with-shared --with-termlib --prefix=${INSTALL_DIR}"
NCURSESW_CONFIGURE_OPTS="${NCURSES_CONFIGURE_OPTS} --enable-widec"

echo "Building ncursesw..."
cd $NCURSES_SRC_DIR
make clean || echo
./configure ${NCURSESW_CONFIGURE_OPTS}
make ${MAKEOPTS}
make install

echo "Building ncurses..."
cd $NCURSES_SRC_DIR
make clean || echo
./configure ${NCURSES_CONFIGURE_OPTS}
make ${MAKEOPTS}
make install

echo "Building tmux..."
cd $TMUX_SRC_DIR
make clean || echo
./configure --prefix=${INSTALL_DIR}
make ${MAKEOPTS}
make install
