SHELL := /bin/bash
libcap/VERSION := 2.65
libcap/TARBALL := https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-$(libcap/VERSION).tar.xz

libcap/dir = $(BUILD)/libcap/libcap-$(libcap/VERSION)_build.$(LOCAL_BUILD)
include $(BASE)/../common/env.mk

define libcap/build :=
	$(info "libcap/build: LOCAL_BUILD: $(LOCAL_BUILD)")
	$(info "libca/build: dir: $(libcap/dir)")
	+cd $(libcap/dir)
	if [ ! -z $(LOCAL_BUILD) ] && [ $(LOCAL_BUILD) -eq  1 ]; then
		echo "not implemented" && exit
	else
		+$(CROSS_MAKE_ENV) CROSS_COMPILE="$(CROSS_PREFIX)" PAM_CAP=no lib=lib BUILD_CC="/usr/bin/gcc" prefix="$(HOST)/sysroot"  make
	fi
endef

define libcap/install :=
	$(info "libcap/build: LOCAL_BUILD: $(LOCAL_BUILD)")
	$(info "libca/build: dir: $(libcap/dir)")
	+cd $(libcap/dir)
	if [ ! -z $(LOCAL_BUILD) ] && [ $(LOCAL_BUILD) -eq  1 ]; then
		echo "not implemented" && exit
	else
		+$(CROSS_MAKE_ENV) CROSS_COMPILE="$(CROSS_PREFIX)" PAM_CAP=no lib=lib DESTDIR="$(HOST)/sysroot" make install
	fi
endef
