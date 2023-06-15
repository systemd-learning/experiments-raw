include $(BASE)/../common/env.mk

readline/VERSION := 8.2
readline/TARBALL := https://ftp.gnu.org/gnu/readline/readline-$(readline/VERSION).tar.gz
readline/dir = $(BUILD)/readline/readline-$(readline/VERSION)_build.$(LOCAL_BUILD)

define readline/build :=
	+cd $(readline/dir)
	+$(CROSS_MAKE_ENV) CROSS_COMPILE=$(CROSS_NAME)-  ./configure  --host=aarch64-none-linux --prefix="$(HOST)/sysroot/usr"
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define readline/install :=
	+cd $(readline/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install
endef
