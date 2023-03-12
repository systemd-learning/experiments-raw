#!/bin/bash

BASE=`pwd`
QEMU=${BASE}/../tools/qemu

${QEMU}/qemu-system-arm \
	-m 128M \
	-M vexpress-a9 \
	-kernel ./out/zImage \
	-dtb ./out/vexpress-v2p-ca9.dtb \
	-initrd ./out/initrd.img \
	-nographic \
	--append "console=ttyAMA0 debug rdinit=/sbin/init"
