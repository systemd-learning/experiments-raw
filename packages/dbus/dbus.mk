include $(BASE)/../common/env.mk

dbus/VERSION := 1.15.4
dbus/TARBALL := https://dbus.freedesktop.org/releases/dbus/dbus-$(dbus/VERSION).tar.xz
dbus/dir = $(BUILD)/dbus/dbus-$(dbus/VERSION)_build.$(LOCAL_BUILD)

define dbus/build :=
	+cd $(dbus/dir)
	if [ $(LOCAL_BUILD) -eq  1 ]; then
		+$(CROSS_MAKE_ENV) ./configure aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu --target=aarch64-none-linux-gnu --prefix="/usr" --disable-selinux --disable-libaudit --without-x --enable-systemd --with-systemdsystemunitdir=/usr/lib/systemd/system
	else 
		+$(CROSS_MAKE_ENV) ./configure aarch64-none-linux-gnu --build=x86_64-pc-linux-gnu --host=aarch64-none-linux-gnu --target=aarch64-none-linux-gnu --prefix="/usr" --disable-selinux --disable-libaudit --without-x
	fi
	+source $(TOY_WORK)/../../packages/dbus/helper.sh && work_around_gio_glib_gobject $(dbus/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' -j 8
endef

define dbus/install :=
	+cd $(dbus/dir)
	+$(CROSS_MAKE_ENV) '$(MAKE)' install DESTDIR=$(HOST)/sysroot/
endef
