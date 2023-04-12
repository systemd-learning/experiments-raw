include $(BASE)/../common/env.mk

linux/VERSION := 5.10.65-rt53-rebase
linux/TARBALL := https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git/snapshot/linux-stable-rt-$(linux/VERSION).tar.gz
linux/dir = $(BUILD)/linux/linux-$(linux/VERSION)

define linux/prepare :=
	+cd $(linux/dir)
	+source $(WORK)/../../packages/linux/helper.sh && do_patch
endef

define linux/build :=
	+cd $(linux/dir)
	+$(MAKE) ARCH=$(ARCH) $(KCFG)
	if [ $(INITRD) -eq  1 ]; then
		sed -i 's/# CONFIG_BLK_DEV_RAM is not set/CONFIG_BLK_DEV_RAM=y/' .config
		sed -i '/CONFIG_BLK_DEV_RAM=y/a\CONFIG_BLK_DEV_RAM_COUNT=16'  .config
		sed -i '/CONFIG_BLK_DEV_RAM=y/a\CONFIG_BLK_DEV_RAM_SIZE=4096' .config
	fi

	+$(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- $(IMG) modules dtbs -j 8
	+cd tools && $(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- perf -j 8
endef

define linux/install :=
	+cd $(linux/dir)/
	+cp arch/$(ARCH)/boot/$(IMG) $(HOST)/
	+cp arch/$(ARCH)/boot/dts/$(DTB) $(HOST)/
	+$(CROSS_ENV_RAW) make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- INSTALL_MOD_PATH=$(HOST)/sysroot/usr INSTALL_MOD_STRIP=1 modules_install
	+$(CROSS_ENV_RAW) make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- INSTALL_HDR_PATH=$(HOST)/sysroot/usr headers_install
	+cd tools && $(CROSS_ENV_RAW) make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- prefix=$(HOST)/sysroot/usr/ perf_install
endef

