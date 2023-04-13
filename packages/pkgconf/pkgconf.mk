include $(BASE)/../common/env.mk

pkgconf/VERSION := 1.9.4
pkgconf/TARBALL := https://distfiles.dereferenced.org/pkgconf/pkgconf-$(pkgconf/VERSION).tar.gz
pkgconf/dir = $(BUILD)/pkgconf/pkgconf-$(pkgconf/VERSION)_build.$(LOCAL_BUILD)

define pkgconf/build :=
	+cd $(pkgconf/dir)
	+mkdir -p build && cd build
	if [ ! -z $(LOCAL_BUILD) ] && [ $(LOCAL_BUILD) -eq  1 ]; then
		$(info "local env: $(LOCAL_MAKE_ENV)")
		+$(LOCAL_MAKE_ENV) ../configure --prefix='$(HOST)'
		+$(LOCAL_MAKE_ENV) '$(MAKE)' -j 8
	else
		$(info "cross env: $(CROSS_MAKE_ENV)")
		+$(CROSS_MAKE_ENV) ../configure --prefix="$(HOST)/sysroot" --host=aarch64-unknown-linux CC='$(TOY_TOOLCHAIN)/bin/$(CROSS_NAME)-gcc' $(CROSS_CFLAGS) --with-sysroot="$(HOST)/sysroot"
		+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
	fi
endef

define pkgconf/install :=
	+cd $(pkgconf/dir)/build
	if [ ! -z $(LOCAL_BUILD) ] && [ $(LOCAL_BUILD) -eq  1 ]; then
		$(info "local env: $(LOCAL_MAKE_ENV)")
		+$(LOCAL_MAKE_ENV) '$(MAKE)' install
	else
		$(info "cross env: $(CROSS_MAKE_ENV)")
		+$(CROSS_MAKE_ENV) '$(MAKE)' install
	fi
endef
