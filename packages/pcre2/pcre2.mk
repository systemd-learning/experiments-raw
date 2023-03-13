SHELL := /bin/bash
pcre2/VERSION := 10.42
pcre2/TARBALL := https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$(pcre2/VERSION)/pcre2-$(pcre2/VERSION).tar.gz

pcre2/dir = $(BUILD)/pcre2/pcre2-$(pcre2/VERSION)_build.$(LOCAL_BUILD)
include $(BASE)/../common/env.mk

define pcre2/build :=
	+cd $(pcre2/dir)
	+$(CROSS_MAKE_ENV) CC='$(TOOLCHAIN)/bin/$(CROSS_PREFIX)gcc' CXX='$(TOOLCHAIN)/bin/$(CROSS_PREFIX)g++' ./configure --host=aarch64-none-linux --with-sysroot="$(HOST)/sysroot"  --prefix="$(HOST)/sysroot"
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define pcre2/install :=
	+cd $(pcre2/dir)
	+'$(MAKE)' install
endef
