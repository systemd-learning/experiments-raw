include $(BASE)/../common/env.mk

gdb/VERSION := 11.2
gdb/TARBALL := https://mirrors.aliyun.com/gnu/gdb/gdb-$(gdb/VERSION).tar.xz
gdb/dir = $(BUILD)/gdb/gdb-$(gdb/VERSION)

define gdb/build :=
	+cd $(gdb/dir)
	$(info gdb/dir: $(gdb/dir))
	+mkdir -p build && cd build
	+$(CROSS_MAKE_ENV) ../configure --host=aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu  --enable-languages=c,c++
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define gdb/install :=
	+cd $(gdb/dir) && cd build
	+$(CROSS_MAKE_ENV) DESTDIR=$(HOST)/sysroot/ '$(MAKE)' install
	+cd $(TOY_TOOLCHAIN)/aarch64-none-linux-gnu/lib64/ && cp libstdc++.so.6 libstdc++.so libstdc++.so.6.0.29 libgcc_s.so.1 libgcc_s.so $(HOST)/sysroot/lib64/
endef
