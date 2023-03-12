SHELL := /bin/bash
libcap/VERSION := 2.65
libcap/TARBALL := https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-$(libcap/VERSION).tar.xz

libcap/dir = $(BUILD)/libcap/libcap-$(libcap/VERSION)

define libcap/build :=
	+cd $(libcap/dir)
	$(info prefix: $(CROSS_PREFIX))
	+make CROSS_COMPILE='$(CROSS_PREFIX)' BUILD_CC=/usr/bin/gcc prefix='$(STAGE)/rootfs'
endef

define libcap/install :=
	+cd $(libcap/dir)
	+make CROSS_COMPILE='$(CROSS_PREFIX)' BUILD_CC=/usr/bin/gcc prefix='$(STAGE)/rootfs' install
endef
