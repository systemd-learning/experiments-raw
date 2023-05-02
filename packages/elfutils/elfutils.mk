include $(BASE)/../common/env.mk

elfutils/VERSION := 0.188
elfutils/TARBALL := https://sourceware.org/elfutils/ftp/0.188/elfutils-$(elfutils/VERSION).tar.bz2
elfutils/dir = $(BUILD)/elfutils/elfutils-$(elfutils/VERSION)_build.$(LOCAL_BUILD)

define elfutils/build :=
	+cd $(elfutils/dir)
	+$(CROSS_MAKE_ENV) ./configure aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu --target=aarch64-none-linux-gnu --prefix="/usr"  --disable-libdebuginfod --disable-debuginfod
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define elfutils/install :=
	+cd $(elfutils/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
