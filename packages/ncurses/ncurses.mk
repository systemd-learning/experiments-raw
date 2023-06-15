include $(BASE)/../common/env.mk

ncurses/VERSION := 6.4
ncurses/TARBALL := https://ftp.gnu.org/gnu/ncurses/ncurses-$(ncurses/VERSION).tar.gz
ncurses/dir = $(BUILD)/ncurses/ncurses-$(ncurses/VERSION)_build.$(LOCAL_BUILD)

define ncurses/build :=
	+cd $(ncurses/dir)
	+$(CROSS_MAKE_ENV) CROSS_COMPILE=$(CROSS_NAME)-  ./configure --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu --target=aarch64-none-linux-gnu --prefix="/usr" -without-manpages --without-manpages --without-progs --without-tack --without-tests
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define ncurses/install :=
	+cd $(ncurses/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
