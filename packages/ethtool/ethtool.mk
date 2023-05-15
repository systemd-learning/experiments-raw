include $(BASE)/../common/env.mk

ethtool/VERSION := 4.13
ethtool/TARBALL := https://mirrors.edge.kernel.org/pub/software/network/ethtool/ethtool-$(ethtool/VERSION).tar.gz
ethtool/dir = $(BUILD)/ethtool/ethtool-$(ethtool/VERSION)_build.$(LOCAL_BUILD)

define ethtool/build :=
	+cd $(ethtool/dir)
	+$(CROSS_MAKE_ENV) ./configure --prefix="/usr" --enable-static --host=aarch64-linux-gnu  LDFLAGS=-static
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define ethtool/install :=
	+cd $(ethtool/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
