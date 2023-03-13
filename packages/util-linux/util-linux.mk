SHELL := /bin/bash
util-linux/VERSION := 2.38
util-linux/TARBALL := https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v$(util-linux/VERSION)/util-linux-$(util-linux/VERSION).tar.xz

util-linux/dir = $(BUILD)/util-linux/util-linux-$(util-linux/VERSION)_build.$(LOCAL_BUILD)
include $(BASE)/../common/env.mk

define util-linux/build :=
	+cd $(util-linux/dir)
	+$(CROSS_MAKE_ENV) ./configure --host=aarch64-none-linux --prefix='$(HOST)/sysroot' --without-systemd --without-python --without-tinfo  --without-ncursesw --without-ncurses
	+'$(MAKE)' -j 8
endef

define util-linux/install :=
	+cd $(util-linux/dir)
	+sudo '$(MAKE)' install
endef
