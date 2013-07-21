#!/bin/sh

export DOWNLOADS=/home/Storage/Downloads/Apps/Linux/MIPS.Cross.Compiler
export WORK=/tmp
export TARGET=mips-unknown-linux-gnu
export PREFIX=/opt/mipscross
export PATH="${PATH}":${PREFIX}/bin

cd $WORK
mkdir ${TARGET}-toolchain  && cd ${TARGET}-toolchain
cp $DOWNLOADS/*.tar.gz 
tar xzf binutils-2.23.2.tar.gz
mkdir build-binutils && cd build-binutils
../binutils-2.23.2/configure --target=$TARGET --prefix=$PREFIX
make
sudo make install
cd ..

# tar xzf gcc-4.8.1.tar.gz
# mkdir build-gcc-bootstrap && cd build-gcc-bootstrap
# ../gcc-3.4.4/configure --target=$TARGET --prefix=$PREFIX \
# --enable-languages=c --without-headers \
# --with-gnu-ld --with-gnu-as \
# --disable-shared --disable-threads 
# make -j2
# sudo make install
# cd ..

# tar xjf gdb-6.3.tar.bz2
# mkdir build-gdb && cd build-gdb
# ../gdb-6.3/configure --target=$TARGET --prefix=$PREFIX
# make
# sudo make install
# cd ..
