include $(BASE)/../common/env.mk

libunwind/VERSION := 1.6.2
libunwind/TARBALL := http://download.savannah.nongnu.org/releases/libunwind/libunwind-$(libunwind/VERSION).tar.gz
libunwind/dir = $(BUILD)/libunwind/libunwind-$(libunwind/VERSION)_build.$(LOCAL_BUILD)

define libunwind/build :=
	+cd $(libunwind/dir)
	+$(CROSS_MAKE_ENV) ./configure aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu --target=aarch64-none-linux-gnu --with-sysroot='$(HOST)/sysroot' --prefix="/usr"
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define libunwind/install :=
	+cd $(libunwind/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
