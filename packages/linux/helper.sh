#!/bin/bash

set -eo pipefail
set -x

do_patch() {
	patch -p1 < ${TOY_WORK}/../../packages/linux/patches/patch-5.10.65-rt53.patch
	patch -p1 < ${TOY_WORK}/../../packages/linux/patches/0001-perf-sched-Cast-PTHREAD_STACK_MIN-to-int-as-it-may-t.patch
}

do_cfg() {
	cp -f ${TOY_WORK}/../../packages/linux/custom/arm64_defconfig  arch/arm64/configs/defconfig
}

do_custom() {
	cp -fr ${TOY_WORK}/../../packages/linux/custom   ../
}

