SHELL := /bin/bash
gdb/VERSION := 11.2
gdb/TARBALL := https://mirrors.aliyun.com/gnu/gdb/gdb-$(gdb/VERSION).tar.xz

gdb/dir = $(BUILD)/gdb/gdb-$(gdb/VERSION)
include $(BASE)/../common/env.mk

define gdb/build :=
	+cd $(gdb/dir)
	$(info gdb/dir: $(gdb/dir))
	+mkdir -p build && cd build
	+$(CROSS_MAKE_ENV) ../configure aarch64-none-linux-gnu --host=aarch64-none-linux-gnu CFLAGS="-O2 " --build=x86_64-pc-linux-gnu --prefix=
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define gdb/install :=
	+$(CROSS_MAKE_ENV) '$(MAKE)' install -C '$(gdb/dir)/build' install_root='$(HOST)/sysroot'
endef
