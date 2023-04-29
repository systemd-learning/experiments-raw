include $(BASE)/../common/env.mk

coreutils/VERSION := 9.2
coreutils/TARBALL := https://ftp.gnu.org/gnu/coreutils/coreutils-$(coreutils/VERSION).tar.xz
coreutils/dir = $(BUILD)/coreutils/coreutils-$(coreutils/VERSION)_build.$(LOCAL_BUILD)

define coreutils/build :=
	+cd $(coreutils/dir)
	+$(CROSS_MAKE_ENV) ./configure aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu --target=aarch64-none-linux-gnu --prefix="/usr" 
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define coreutils/install :=
	+cd $(coreutils/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
