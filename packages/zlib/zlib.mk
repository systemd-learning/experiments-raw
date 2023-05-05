include $(BASE)/../common/env.mk

zlib/VERSION := 1.2.13
zlib/TARBALL := https://www.zlib.net/zlib-$(zlib/VERSION).tar.gz
zlib/dir = $(BUILD)/zlib/zlib-$(zlib/VERSION)_build.$(LOCAL_BUILD)

define zlib/build :=
	+cd $(zlib/dir)
	#+$(CROSS_MAKE_ENV) CROSS_COMPILE=$(CROSS_NAME)- CC=${CROSS_COMPILE}gcc AR=${CROSS_COMPILE}ar RANLIB=${CROSS_COMPILE}ranlib  ./configure --prefix="/usr"
	+$(CROSS_MAKE_ENV) CROSS_COMPILE=$(CROSS_NAME)-  ./configure --prefix="/usr"
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define zlib/install :=
	+cd $(zlib/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
