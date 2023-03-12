#!/bin/bash

BASE=`pwd`
QEMU=${BASE}/../tools/qemu

${QEMU}/qemu-system-aarch64 \
	-L ${QEMU}/pc-bios/  \
	-m 1G -M virt -nographic -cpu cortex-a57 \
	-kernel ./out/Image.gz \
	-initrd ./out/rootfs.gz \
	-append "console=ttyAMA0 rdinit=/sbin/init " 
#/mnt_sdb/git/devel/little-experiments/exp_05/stage/rootfs
