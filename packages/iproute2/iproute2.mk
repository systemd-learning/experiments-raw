include $(BASE)/../common/env.mk

iproute2/VERSION := 6.3.0
iproute2/TARBALL := https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-$(iproute2/VERSION).tar.gz
iproute2/dir = $(BUILD)/iproute2/iproute2-$(iproute2/VERSION)_build.$(LOCAL_BUILD)

define iproute2/build :=
	+cd $(iproute2/dir)
	+$(CROSS_MAKE_ENV) ./configure  --prefix="/usr" --include_dir="$(HOST)/sysroot/usr/include" --libdir="$(HOST)/sysroot//usr/lib"  --libbpf_force=off
	+$(CROSS_MAKE_ENV) '$(MAKE)'
endef

define iproute2/install :=
	+cd $(iproute2/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
