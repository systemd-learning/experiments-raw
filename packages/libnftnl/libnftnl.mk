include $(BASE)/../common/env.mk

libnftnl/VERSION := 1.2.1
libnftnl/TARBALL := https://www.netfilter.org/projects/libnftnl/files/libnftnl-$(libnftnl/VERSION).tar.bz2
libnftnl/dir = $(BUILD)/libnftnl/libnftnl-$(libnftnl/VERSION)_build.$(LOCAL_BUILD)

define libnftnl/build :=
	+cd $(libnftnl/dir)
	+autoreconf -vfi
	+$(CROSS_MAKE_ENV) ./configure --prefix="/usr"  --host=aarch64-none-linux-gnu  LIBMNL_CFLAGS=-I$(HOST)/sysroot/include LIBMNL_LIBS="-L$(HOST)/sysroot/lib/ -lmnl"
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define libnftnl/install :=
	+cd $(libnftnl/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
