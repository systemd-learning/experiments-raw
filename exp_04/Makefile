export BASE := $(PWD)
include $(BASE)/../common/env.mk

export ARCH=arm64
export KCFG=defconfig
export IMG=Image.gz
export DTB=arm/vexpress-v2f-1xv7-ca53x2.dtb
export CROSS_NAME=aarch64-none-linux-gnu

all: packages
	$(info "generating image ...")
	+cp $(HOST)/$(IMG) $(TOY_OUT)/
	+source ../common/utils.sh && make_initramfs $(HOST) $(TOY_OUT) rootfs.gz
	$(info "success.")

packages: toolchain
	$(info "building dependent packages ...")
	'$(MAKE)' -f ../common/package.mk PACKAGES=linux
	'$(MAKE)' -f ../common/package.mk PACKAGES=glibc
	'$(MAKE)' -f ../common/package.mk PACKAGES=busybox
	'$(MAKE)' -f ../common/package.mk PACKAGES=pkgconf LOCAL_BUILD=1
	'$(MAKE)' -f ../common/package.mk PACKAGES=pkgconf
	'$(MAKE)' -f ../common/package.mk PACKAGES=libcap
	'$(MAKE)' -f ../common/package.mk PACKAGES=gperf
	'$(MAKE)' -f ../common/package.mk PACKAGES=util-linux
	'$(MAKE)' -f ../common/package.mk PACKAGES=systemd

toolchain:
	$(info "preparing toolchain ...")
	$(call init_work_space)  
	'$(MAKE)' -f ../common/package.mk PACKAGES=toolchain_arm64

clean:
	'$(MAKE)' -f ../common/package.mk clean
