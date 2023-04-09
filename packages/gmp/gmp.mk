gmp/VERSION := 6.2.1
gmp/TARBALL := https://mirrors.aliyun.com/gnu/gmp/gmp-$(gmp/VERSION).tar.xz

gmp/dir = $(BUILD)/gmp/gmp-$(gmp/VERSION)
include $(BASE)/../common/env.mk

define gmp/build :=
	+cd $(gmp/dir)
	$(info gmp/dir: $(gmp/dir))
	+mkdir -p build && cd build
	+$(CROSS_MAKE_ENV) ../configure aarch64-none-linux-gnu --host=aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j $(shell nproc)
endef

define gmp/install :=
	+cd $(gmp/dir) && cd build
	+$(CROSS_MAKE_ENV) DESTDIR=$(HOST)/sysroot/ '$(MAKE)' install
endef
