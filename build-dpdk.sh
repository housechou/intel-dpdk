#!/bin/bash

export DPDK_VER=20.08
export RTE_TARGET=x86_64-native-linuxapp-gcc
export RTE_SDK=~/intel-dpdk/dpdk-$DPDK_VER
export MAKE_PAUSE=n

if [ ! -d $RTE_SDK ]; then
    if [ ! -f dpdk-$DPDK_VER.tar.xz ]; then
        echo "Downloading DPDK..."
        wget https://fast.dpdk.org/rel/dpdk-$DPDK_VER.tar.xz
        echo "Unpacking DPDK..."
        tar xvf dpdk-$DPDK_VER.tar.xz
    fi
fi


echo "Building DPDK..."
cd $RTE_SDK
make config T=x86_64-native-linuxapp-gcc
make -j8 CONFIG_RTE_EAL_IGB_UIO=y
ln -sf $RTE_SDK/build $RTE_TARGET
