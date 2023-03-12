#!/bin/bash

BASE=`pwd`
QEMU=${BASE}/../tools/qemu

${QEMU}/qemu-system-aarch64 \
	-L ${QEMU}/pc-bios/  \
	-m 1G -M virt -nographic -cpu cortex-a57 -smp 4\
	-kernel ./out/Image.gz \
	-initrd ./out/rootfs.gz \
	-append "console=ttyAMA0 rdinit=/sbin/init " 
