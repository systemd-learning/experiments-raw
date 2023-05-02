#/bin/bash

BASE=`pwd`
QEMU=${BASE}/../tools/qemu
OUTPUT=${BASE}/work/output

${QEMU}/qemu-system-aarch64 \
	-L ${QEMU}/pc-bios/  \
	-m 1G -smp 4 -M virt -nographic -cpu cortex-a57 \
	-kernel ${OUTPUT}/Image.gz \
	-hda ${OUTPUT}/disk.img \
	-append "console=ttyAMA0 root=/dev/vda rw debug init=/bin/bash "


