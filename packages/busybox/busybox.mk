include $(BASE)/../common/env.mk

busybox/VERSION := 1.33.2
busybox/TARBALL := https://busybox.net/downloads/busybox-$(busybox/VERSION).tar.bz2
busybox/dir = $(BUILD)/busybox/busybox-$(busybox/VERSION)_build.$(LOCAL_BUILD)

define busybox/build :=
	+cd $(busybox/dir)
	+'$(MAKE)' ARCH=arm defconfig
	if [ $(STATIC) -eq  1 ]; then
		sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/g' .config
		sed -i 's|CONFIG_SYSROOT=""|CONFIG_SYSROOT="$(TOOLCHAIN)/$(CROSS_NAME)/libc"|g' .config
		+$(CROSS_ENV_RAW) '$(MAKE)' ARCH=arm CROSS_COMPILE='$(CROSS_NAME)-' CONFIG_PREFIX='$(HOST)/sysroot' install -j 8
	else
		sed -i 's|CONFIG_SYSROOT=""|CONFIG_SYSROOT="$(HOST)/sysroot"|g' .config
		+$(CROSS_MAKE_ENV) '$(MAKE)' ARCH=arm CROSS_COMPILE='$(CROSS_NAME)-' CONFIG_PREFIX='$(HOST)/sysroot' install -j 8
	fi
endef

define busybox/install :=
endef
