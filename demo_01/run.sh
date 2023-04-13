#!/bin/bash

BASE=`pwd`
QEMU=${BASE}/../tools/qemu
OUTPUT=${BASE}/work/output

${QEMU}/qemu-system-arm \
		-m 128M -smp 4 \
		-M vexpress-a9 \
		-kernel ${OUTPUT}/zImage \
		-dtb ${OUTPUT}/vexpress-v2p-ca9.dtb \
		-initrd ${OUTPUT}/rootfs.gz \
		-nographic \
		--append "console=ttyAMA0 debug rdinit=/sbin/init "
