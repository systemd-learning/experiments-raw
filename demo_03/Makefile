export BASE := $(PWD)
include $(BASE)/../common/env.mk

export ARCH=arm64
export KCFG=defconfig
export IMG=Image.gz
export DTB=arm/vexpress-v2f-1xv7-ca53x2.dtb
export CROSS_NAME=aarch64-none-linux-gnu
export WITH_PERF := 1
export WITH_CUSTOM_KO := 1

all: packages
	$(info "generating image ...")
	cp $(HOST)/$(IMG) $(TOY_OUT)/
	source ../common/utils.sh && make_initramfs $(HOST) $(TOY_OUT) rootfs.gz
	$(info "success.")

packages: toolchain
	$(info "building dependent packages ...")
	'$(MAKE)' -f ../common/package.mk PACKAGE=linux
	'$(MAKE)' -f ../common/package.mk PACKAGE=glibc
	'$(MAKE)' -f ../common/package.mk PACKAGE=busybox

toolchain: 
	$(info "preparing toolchain ...")
	$(call init_work_space)
	'$(MAKE)' -f ../common/package.mk PACKAGE=toolchain_arm64
clean:
	'$(MAKE)' -f ../common/package.mk clean
	'$(MAKE)' -f ../common/toolchain.mk clean
