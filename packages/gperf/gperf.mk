SHELL := /bin/bash
gperf/VERSION := 3.1
gperf/TARBALL := https://ftp.gnu.org/pub/gnu/gperf/gperf-$(gperf/VERSION).tar.gz

gperf/dir = $(BUILD)/gperf/gperf-$(gperf/VERSION)_build.$(LOCAL_BUILD)
include $(BASE)/../common/env.mk

define gperf/build :=
	+cd $(gperf/dir)
	+$(CROSS_MAKE_ENV) ./configure --host=aarch64-none-linux CC='$(TOOLCHAIN)/bin/$(CROSS_PREFIX)gcc' CXX='$(TOOLCHAIN)/bin/$(CROSS_PREFIX)g++' --prefix='$(HOST)/sysroot'
	+'$(MAKE)' -j 8
endef

define gperf/install :=
	+cd $(gperf/dir)
	+'$(MAKE)' install
endef