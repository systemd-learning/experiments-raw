#!/bin/bash

set -eo pipefail
set -x

do_patch() {
	patch -p1 < ${WORK}/../../packages/linux/patches/0001-perf-sched-Cast-PTHREAD_STACK_MIN-to-int-as-it-may-t.patch
}

