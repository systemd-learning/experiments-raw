include $(BASE)/../common/env.mk

iptables/VERSION := 1.8.7
iptables/TARBALL := https://www.netfilter.org/projects/iptables/files/iptables-$(iptables/VERSION).tar.bz2
iptables/dir = $(BUILD)/iptables/iptables-$(iptables/VERSION)_build.$(LOCAL_BUILD)

define iptables/build :=
	+cd $(iptables/dir)
	+$(CROSS_MAKE_ENV) ./configure --prefix="/usr" --enable-static --host=aarch64-linux-gnu libmnl_LIBS="-L$(HOST)/sysroot/lib/ -lmnl" libnftnl_CFLAGS="-I$(HOST)/sysroot/usr/include/" libnftnl_LIBS="-L$(HOST)/sysroot/lib/ -lnftnl"
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define iptables/install :=
	+cd $(iptables/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
