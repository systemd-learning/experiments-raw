SHELL := /bin/bash
export BASE := $(PWD)
export DOWNLOAD := $(BASE)/../download
export TOOLCHAIN = $(BASE)/toolchain
export STAGE := $(BASE)/stage
export BUILD := $(BASE)/build
export STATE := $(BASE)/state
export OUT := $(BASE)/out

export ARCH=arm64
export KCFG=defconfig
export IMG=Image.gz
export DTB=arm/vexpress-v2f-1xv7-ca53x2.dtb
export CROSS_PREFIX=aarch64-none-linux-gnu-

all: packages
	$(info "generating image ...")
	cp $(STAGE)/$(IMG) $(OUT)/
	source ../common/utils.sh && make_initramfs $(STAGE) $(OUT) rootfs.gz
	$(info "success.")

packages: toolchain
	$(info "building dependent packages ...")
	'$(MAKE)' -f ../common/package.mk PACKAGES=linux
	'$(MAKE)' -f ../common/package.mk PACKAGES=glibc
	'$(MAKE)' -f ../common/package.mk PACKAGES=busybox

toolchain:
	$(info "preparing toolchain ...")
	'$(MAKE)' -f ../common/package.mk PACKAGES=toolchain_arm64

clean:
	'$(MAKE)' -f ../common/package.mk clean
	'$(MAKE)' -f ../common/toolchain.mk clean
