include $(BASE)/../common/env.mk

qperf/VERSION := 0.4.11
qperf/TARBALL := https://github.com/linux-rdma/qperf/archive/refs/tags/v$(qperf/VERSION).tar.gz
qperf/dir = $(BUILD)/qperf/qperf-$(qperf/VERSION)_build.$(LOCAL_BUILD)

define qperf/build :=
	+cd $(qperf/dir)
	+./cleanup
	+./autogen.sh
	+$(CROSS_MAKE_ENV) ./configure --prefix="/usr"  --host=aarch64-none-linux-gnu  LDFLAGS="-static "
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define qperf/install :=
	+cd $(qperf/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
