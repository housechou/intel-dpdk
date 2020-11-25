#!/bin/bash

export DPDK_VER=20.08
export PKTGEN_VER=20.02.0
export PKTGEN_DIR=~/intel-dpdk/pktgen-$PKTGEN_VER
export RTE_TARGET=x86_64-native-linuxapp-gcc
export RTE_SDK=~/intel-dpdk/dpdk-$DPDK_VER
export PCI_IF0="0000:01:00.0"
export PCI_IF1="0000:01:00.1"

if [ "$1" == "-u" ]; then
    $RTE_SDK/usertools/dpdk-devbind.py -u $PCI_IF0
    $RTE_SDK/usertools/dpdk-devbind.py -u $PCI_IF0
    $RTE_SDK/usertools/dpdk-devbind.py -b ixgbe $PCI_IF0
    $RTE_SDK/usertools/dpdk-devbind.py -b ixgbe $PCI_IF1
    exit 0
fi

cd $PKTGEN_DIR
if [ $UID -ne 0 ]; then
	echo "You must run this script as root" >&2
    exit 1
fi

if [ ! -d /mnt/huge1G ]; then
    mkdir /mnt/huge1G
    chmod 777 /mnt/huge1G/
fi

rm -fr /mnt/huge1G/*
r=`mount |grep /mnt/huge1G`
if [ $? -eq 1 ]; then
    mount -t hugetlbfs -o pagesize=1G nodev /mnt/huge1G
fi

#grep -i huge /proc/meminfo
modprobe uio
echo "trying to remove old igb_uio module and may get an error message, ignore it"
r=`lsmod |grep igb_uio`
if [ $? -eq 1 ]; then
    rmmod igb_uio
fi
insmod $RTE_SDK/$RTE_TARGET/kmod/igb_uio.ko

$RTE_SDK/usertools/dpdk-devbind.py -b igb_uio $PCI_IF0
$RTE_SDK/usertools/dpdk-devbind.py -b igb_uio $PCI_IF1
$RTE_SDK/usertools/dpdk-devbind.py --status

python2 ./tools/run.py -s two-ports.cfg
python2 ./tools/run.py two-ports.cfg
