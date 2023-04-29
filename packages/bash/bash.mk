include $(BASE)/../common/env.mk

bash/VERSION := 5.2
bash/TARBALL := https://ftp.gnu.org/gnu/bash/bash-$(bash/VERSION).tar.gz
bash/dir = $(BUILD)/bash/bash-$(bash/VERSION)_build.$(LOCAL_BUILD)

define bash/build :=
	+cd $(bash/dir)
	+$(CROSS_MAKE_ENV) ./configure aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu --target=aarch64-none-linux-gnu --prefix=/usr
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define bash/install :=
	+cd $(bash/dir)
	+'$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
