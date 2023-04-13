#!/bin/bash

BASE=`pwd`
QEMU=${BASE}/../tools/qemu
OUTPUT=${BASE}/work/output

${QEMU}/qemu-system-aarch64 \
	-L ${QEMU}/pc-bios/  \
	-m 1G -smp 4 -M virt -nographic -cpu cortex-a57 \
	-kernel ${OUTPUT}/Image.gz \
	-initrd ${OUTPUT}/rootfs.gz \
	-append "console=ttyAMA0 rdinit=/usr/sbin/init " 
