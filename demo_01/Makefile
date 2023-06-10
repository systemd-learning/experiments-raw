export BASE := $(PWD)
include $(BASE)/../common/env.mk

export STATIC := 1
export ARCH=arm
export KCFG=vexpress_defconfig
export IMG=zImage
export DTB=vexpress-v2p-ca9.dtb
export CROSS_NAME=arm-none-linux-gnueabihf

all: packages
	$(info "generating image ...")
	cp $(HOST)/$(IMG) $(TOY_OUT)/
	cp $(HOST)/$(DTB) $(TOY_OUT)/
	source ../common/utils.sh && make_initramfs $(HOST) $(TOY_OUT) rootfs.gz
	$(info "success.")

packages: toolchain
	$(info "building dependent packages ...")
	'$(MAKE)' -f ../common/package.mk PACKAGE=linux
	'$(MAKE)' -f ../common/package.mk PACKAGE=busybox

toolchain:
	$(info "preparing toolchain ...")
	$(call init_work_space)
	'$(MAKE)' -f ../common/package.mk PACKAGE=toolchain_arm32

clean:
	'$(MAKE)' -f ../common/package.mk clean
	'$(MAKE)' -f ../common/toolchain.mk clean
