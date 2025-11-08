#!/bin/bash
# Written by Ankur Pandey
# Version 1.0: 5 Nov 2025. Updated for AOSP 10 and Ubuntu 20.04

echo
echo "This script will check that this PC is suitable for building AOSP 10"
echo
echo "Checking hardware..."

FAILED=n

NUM_CPU=$(grep processor /proc/cpuinfo | wc -l)
echo -n "Number of CPU's: ${NUM_CPU}, "
if [ ${NUM_CPU} -lt 4 ]; then
    echo "FAIL. Need at least 4 cores"
    FAILED=y
else
    echo "OK"
fi

RAM_KBYTES=$(grep MemTotal /proc/meminfo | awk '{print $2}')
RAM_MBYTES=$(( ${RAM_KBYTES} / 1024 ))
echo -n "MiB of RAM: ${RAM_MBYTES}, "
if [ ${RAM_MBYTES} -lt 30720 ]; then
    echo "FAIL"
    echo " Only ${RAM_MBYTES} MiB RAM: we need at least 30 GiB"
    FAILED=y
else
    echo "OK"
fi

DISK_KBYTES=$(df  ${HOME} | awk '{if (NR == 2) print $4}')
DISK_GBYTES=$(( ${DISK_KBYTES} / 1048576 ))
echo -n "Free disk space in directory ${HOME}: ${DISK_GBYTES} GiB, "
if [ ${DISK_GBYTES} -lt 250 ]; then
    echo "FAIL"
    echo " Insufficient disk space in ${HOME}, we need at least 250 GiB"
    FAILED=y
else
    echo "OK"
fi

# Check the distribution is Ubuntu 20.04
echo -n "Checking Linux distribution, "
DISTRIB_RELEASE=x
if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
fi
if [ $DISTRIB_RELEASE != "20.04" ]; then
    echo "FAIL. The distribution must be Ubuntu 64-bit 20.04"
    FAILED=y
fi
echo "OK"

MACHINE_ARCH=$(uname -m)
echo -n "Machine architecture: ${MACHINE_ARCH}, "
if [ ${MACHINE_ARCH} != "x86_64" ]; then
    echo "FAIL. Must be 64-bit"
    FAILED=y
else
    echo "OK"
fi
if [ $FAILED == y ]; then
    echo
    echo "FAIL: this machine is not suitable for building AOSP 10"
    echo
    exit 1
fi

echo
echo "PASS: you are good to go"
echo

echo "Do you want to install the additional packages required for Android (y/n)?"
read UPDATE
if [ $UPDATE != y ]; then
    echo "Not updated"
    exit 0
fi

case $DISTRIB_RELEASE in
  18.04)
    sudo apt install flex bison gcc-multilib g++-multilib git gperf \
libxml2-utils make zlib1g-dev zip curl \
minicom gtkterm ddd patch ant vim lzop tree isc-dhcp-server \
bmap-tools python gdisk python-mako u-boot-tools ccache libncurses5-dev libssl-dev \
graphviz qemu-kvm
  ;;
  20.04)
    sudo apt install flex bison gcc-multilib g++-multilib git gperf \
libxml2-utils make zlib1g-dev zip curl \
minicom gtkterm patch vim lzop tree isc-dhcp-server \
bmap-tools python gdisk python-mako u-boot-tools ccache libncurses5-dev libssl-dev \
graphviz libncurses5 qemu-kvm
  ;;
  *)
    echo "Ubuntu version $DISTRIB_RELEASE not recognised"
    exit 1
esac

echo
echo "Done"
echo

exit 0

