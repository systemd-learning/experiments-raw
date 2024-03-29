export BASE := $(PWD)
include $(BASE)/../common/env.mk

export ARCH=arm64
export KCFG=defconfig
export IMG=Image.gz
export DTB=arm/vexpress-v2f-1xv7-ca53x2.dtb
export CROSS_NAME=aarch64-none-linux-gnu
export WITH_PERF := 1
export STATIC := 1
export WITH_CUSTOM_KO := 1

all: packages
	$(info "generating image ...")
	cp $(HOST)/$(IMG) $(TOY_OUT)/
	source ../common/utils.sh && copy_libs_from_toolchain $(HOST) libgcc_s.so*
	source ../common/utils.sh && make_diskimg $(HOST) $(TOY_OUT) disk.img
	$(info "success.")

packages: toolchain
	$(info "building dependent packages ...")
	'$(MAKE)' -f ../common/package.mk PACKAGE=linux
	'$(MAKE)' -f ../common/package.mk PACKAGE=glibc
	'$(MAKE)' -f ../common/package.mk PACKAGE=busybox
	'$(MAKE)' -f ../common/package.mk PACKAGE=bash
	'$(MAKE)' -f ../common/package.mk PACKAGE=pkgconf LOCAL_BUILD=1
	'$(MAKE)' -f ../common/package.mk PACKAGE=pkgconf
	'$(MAKE)' -f ../common/package.mk PACKAGE=libcap
	'$(MAKE)' -f ../common/package.mk PACKAGE=gperf
	'$(MAKE)' -f ../common/package.mk PACKAGE=util-linux
	'$(MAKE)' -f ../common/package.mk PACKAGE=coreutils
	'$(MAKE)' -f ../common/package.mk PACKAGE=expat
	'$(MAKE)' -f ../common/package.mk PACKAGE=dbus
	'$(MAKE)' -f ../common/package.mk PACKAGE=systemd
	'$(MAKE)' -f ../common/package.mk PACKAGE=dbus LOCAL_BUILD=1
	'$(MAKE)' -f ../common/package.mk PACKAGE=libunwind
	'$(MAKE)' -f ../common/package.mk PACKAGE=zlib
	'$(MAKE)' -f ../common/package.mk PACKAGE=elfutils
	#'$(MAKE)' -f ../common/package.mk PACKAGE=kmod

toolchain:
	$(info "preparing toolchain ...")
	$(call init_work_space)
	'$(MAKE)' -f ../common/package.mk PACKAGES=toolchain_arm64
clean:
	'$(MAKE)' -f ../common/package.mk clean
	'$(MAKE)' -f ../common/toolchain.mk clean
