include $(BASE)/../common/env.mk

libmnl/VERSION := 1.0.4
libmnl/TARBALL := https://www.netfilter.org/projects/libmnl/files/libmnl-$(libmnl/VERSION).tar.bz2
libmnl/dir = $(BUILD)/libmnl/libmnl-$(libmnl/VERSION)_build.$(LOCAL_BUILD)

define libmnl/build :=
	+cd $(libmnl/dir)
	+autoreconf -vfi
	+$(CROSS_MAKE_ENV) ./configure --prefix="/usr"  --host=aarch64-none-linux-gnu
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define libmnl/install :=
	+cd $(libmnl/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
