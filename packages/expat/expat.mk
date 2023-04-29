include $(BASE)/../common/env.mk

expat/VERSION := 2.5.0
expat/TARBALL :=https://github.com/libexpat/libexpat/releases/download/R_2_5_0/expat-$(expat/VERSION).tar.bz2
expat/dir = $(BUILD)/expat/expat-$(expat/VERSION)_build.$(LOCAL_BUILD)

define expat/build :=
	+cd $(expat/dir)
	+$(CROSS_MAKE_ENV) ./configure aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu --target=aarch64-none-linux-gnu --prefix=/usr
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define expat/install :=
	+cd $(expat/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
