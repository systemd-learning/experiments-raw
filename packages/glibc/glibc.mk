SHELL := /bin/bash
glibc/VERSION := 2.37
glibc/TARBALL := https://mirrors.aliyun.com/gnu/glibc/glibc-$(glibc/VERSION).tar.gz

glibc/dir = $(BUILD)/glibc/glibc-$(glibc/VERSION)
include $(BASE)/../common/env.mk

define glibc/build :=
	+cd $(glibc/dir)
	$(info glibc/dir: $(glibc/dir))
	+mkdir -p build && cd build
	if [ "$(ARCH)" ==  "arm" ]; then
		+$(CROSS_MAKE_ENV) ../configure arm-none-linux-gnu --host=arm-none-linux-gnu CFLAGS="-O2 " --build=x86_64-pc-linux-gnu --prefix=/usr  --enable-add-ons
	else
		+$(CROSS_MAKE_ENV) ../configure aarch64-none-linux-gnu --host=aarch64-none-linux-gnu CFLAGS="-O2 " --build=x86_64-pc-linux-gnu --prefix=/usr  --enable-add-ons
	fi
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define glibc/install :=
	+$(CROSS_MAKE_ENV) '$(MAKE)' install -C '$(glibc/dir)/build' install_root='$(HOST)/sysroot'
endef
