SHELL := /bin/bash
export BASE := $(PWD)
export DOWNLOAD := $(BASE)/../download
export TOOLCHAIN = $(BASE)/toolchain
export STAGE := $(BASE)/stage
export BUILD := $(BASE)/build
export STAGE := $(BASE)/state
export OUT := $(BASE)/out
export STATIC := 1
export INITRD := 1

export ARCH=arm
export KCFG=vexpress_defconfig
export IMG=zImage
export DTB=vexpress-v2p-ca9.dtb
export CROSS_PREFIX=arm-none-linux-gnueabihf-

all: packages
	$(info "generating image ...")
	+cp $(STAGE)/$(IMG) $(OUT)/
	+cp $(STAGE)/$(DTB) $(OUT)/
	+source ../common/utils.sh && make_initrd $(STAGE) $(OUT) initrd.img
	$(info "success.")

packages: toolchain
	$(info "building dependent packages ...")
	'$(MAKE)' -f ../common/package.mk PACKAGES=linux
	'$(MAKE)' -f ../common/package.mk PACKAGES=busybox

toolchain:
	$(info "preparing toolchain ...")
	'$(MAKE)' -f ../common/package.mk PACKAGES=toolchain_arm32

clean:
	'$(MAKE)' -f ../common/package.mk clean
	'$(MAKE)' -f ../common/toolchain.mk clean
