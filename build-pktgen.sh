#!/bin/bash

export DPDK_VER=20.08
export PKTGEN_VER=20.02.0
export PKTGEN_DIR=~/intel-dpdk/pktgen-$PKTGEN_VER
export RTE_TARGET=x86_64-native-linuxapp-gcc
export RTE_SDK=~/intel-dpdk/dpdk-$DPDK_VER

echo "Downloading pktgen..."
if [ ! -d $PKTGEN_DIR ]; then
    wget http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-$PKTGEN_VER.tar.gz
    echo "Unpacking pktgen..."
    tar xvf pktgen-$PKTGEN_VER.tar.gz
fi


echo "building pktgen..."
cd $PKTGEN_DIR
make -j8
