SHELL := /bin/bash
pkgconf/VERSION := 1.9.4
pkgconf/TARBALL := https://distfiles.dereferenced.org/pkgconf/pkgconf-$(pkgconf/VERSION).tar.gz

pkgconf/dir = $(BUILD)/pkgconf/pkgconf-$(pkgconf/VERSION)

define pkgconf/build :=
	$(info PATH=$(PATH))
	+cd $(pkgconf/dir)
	+mkdir -p build && cd build
	../configure --host=aarch64-linux CC='$(TOOLCHAIN)/bin/$(CROSS_PREFIX)gcc' LDFLAGS='-L$(STAGE)/rootfs' --with-sysroot='$(STAGE)/rootfs' --prefix='$(STAGE)/rootfs'
	+'$(MAKE)' -j 8
endef

define pkgconf/install :=
	+cd $(pkgconf/dir)/build
	+'$(MAKE)' install --debug
endef
