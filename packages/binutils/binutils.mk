include $(BASE)/../common/env.mk

binutils/VERSION := 2.40
binutils/TARBALL := https://ftp.gnu.org/gnu/binutils/binutils-$(binutils/VERSION).tar.xz
binutils/dir = $(BUILD)/binutils/binutils-$(binutils/VERSION)_build.$(LOCAL_BUILD)

define binutils/build :=
	+cd $(binutils/dir)
	+$(CROSS_MAKE_ENV) CROSS_COMPILE=$(CROSS_NAME)-  ./configure --prefix="/usr" --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define binutils/install :=
	+cd $(binutils/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
