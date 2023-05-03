include $(BASE)/../common/env.mk

diagnose/VERSION := 1.0
diagnose/TARBALL := https://url/diagnose-1.0.tar.gz
diagnose/dir = $(BUILD)/diagnose/diagnose-$(diagnose/VERSION)_build.$(LOCAL_BUILD)

DIAG_VENDER_ENV = \
	ARCH=arm64 \
	UNAME=5.10.65-rt53 \
	KERNEL_BUILD_PATH=/mnt_sdb/git/experiments/demo_07/work/host/sysroot/lib/modules/5.10.65-rt53/build \
	CFLAGS_MODULE="-DMODULE -DCHUSHI_ARM64 -DCONFIG_CHUSHI_PREEMPT_RT " \
	VENDER_LDFLAGS="--sysroot=/mnt_sdb/git/experiments/demo_07/work/host/sysroot " \
	VENDER_CXXFLAGS="-DCHUSHI_ARM64 --sysroot=/mnt_sdb/git/experiments/demo_07/work/host/sysroot "

define diagnose/build :=
	+cd $(diagnose/dir)
	+$(CROSS_MAKE_ENV) $(DIAG_VENDER_ENV) make 
endef

define diagnose/install :=
	+cd $(diagnose/dir)
	+$(CROSS_MAKE_ENV) $(DIAG_VENDER_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
