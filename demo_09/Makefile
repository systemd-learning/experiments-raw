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
	source ../common/utils.sh && make_diskimg $(HOST) $(TOY_OUT) disk.img
	$(info "success.")

packages: toolchain
	$(info "building dependent packages ...")
	'$(MAKE)' -f ../common/package.mk PACKAGES=linux
	'$(MAKE)' -f ../common/package.mk PACKAGES=glibc
	'$(MAKE)' -f ../common/package.mk PACKAGES=busybox
	'$(MAKE)' -f ../common/package.mk PACKAGES=libmnl
	'$(MAKE)' -f ../common/package.mk PACKAGES=libnftnl
	'$(MAKE)' -f ../common/package.mk PACKAGES=iptables
	'$(MAKE)' -f ../common/package.mk PACKAGES=ethtool
	'$(MAKE)' -f ../common/package.mk PACKAGES=qperf
#	'$(MAKE)' -f ../common/package.mk PACKAGES=selinux

toolchain: 
	$(info "preparing toolchain ...")
	$(call init_work_space)
	'$(MAKE)' -f ../common/package.mk PACKAGES=toolchain_arm64
	source ../common/utils.sh && copy_libs_from_toolchain $(HOST) libgcc_s.so*

clean:
	'$(MAKE)' -f ../common/package.mk clean
	'$(MAKE)' -f ../common/toolchain.mk clean
