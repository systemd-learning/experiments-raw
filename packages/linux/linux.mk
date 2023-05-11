include $(BASE)/../common/env.mk

linux/VERSION := 5.10.65-rt53-rebase
linux/TARBALL := https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git/snapshot/linux-stable-rt-$(linux/VERSION).tar.gz
linux/dir = $(BUILD)/linux/linux-$(linux/VERSION)

define linux/prepare :=
	+cd $(linux/dir)
	+source $(TOY_WORK)/../../packages/linux/helper.sh && do_patch && do_cfg && do_custom
endef

define linux/install :=
	+cd $(linux/dir)/
	+cp arch/$(ARCH)/boot/$(IMG) $(HOST)/
	+cp arch/$(ARCH)/boot/dts/$(DTB) $(HOST)/
	+$(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- INSTALL_MOD_PATH=$(HOST)/sysroot/usr INSTALL_MOD_STRIP=1 modules_install
	+$(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- INSTALL_HDR_PATH=$(HOST)/sysroot/usr headers_install
	if [ $(WITH_PERF) -eq  1 ]; then
		+cd tools && $(CROSS_MAKE_ENV) EXTRA_CFLAGS='$(CFLAGS) -O2 --sysroot=$(HOST)/sysroot ' $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- prefix=$(HOST)/sysroot/usr/ perf_install
	fi
	if [ $(WITH_CUSTOM_KO) -eq  1 ]; then
		+cd $(linux/dir)/../custom/
		+$(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- INSTALL_MOD_PATH=$(HOST)/sysroot/usr install
	fi
	if [ $(WITH_LIB_BPF) -eq  1 ]; then
		+cd $(linux/dir)/tools/lib/bpf
		+$(CROSS_MAKE_ENV) EXTRA_CFLAGS='$(CFLAGS) -O2 --sysroot=$(HOST)/sysroot ' $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)-  prefix=$(HOST)/sysroot/usr/ install
	fi
	if [ $(WITH_SAMPLES_BPF) -eq  1 ]; then
		+mkdir -p $(HOST)/sysroot/opt
		+cp -r $(linux/dir)/samples/bpf $(HOST)/sysroot/opt
	fi
endef


define linux/build :=
	+cd $(linux/dir)
	+$(MAKE) ARCH=$(ARCH) defconfig
	if [ $(INITRD) -eq  1 ]; then
		sed -i 's/# CONFIG_BLK_DEV_RAM is not set/CONFIG_BLK_DEV_RAM=y/' .config
		sed -i '/CONFIG_BLK_DEV_RAM=y/a\CONFIG_BLK_DEV_RAM_COUNT=16'  .config
		sed -i '/CONFIG_BLK_DEV_RAM=y/a\CONFIG_BLK_DEV_RAM_SIZE=4096' .config
	fi
	if [ $(WITH_LIB_BPF) -eq  1 ]; then
		sed -i 's/# CONFIG_BPF_SYSCALL is not set/CONFIG_BPF_SYSCALL=y/' .config
		sed -i 's/# CONFIG_TASKS_TRACE_RCU is not set/CONFIG_TASKS_TRACE_RCU=y/' .config
		sed -i 's/# CONFIG_BPF_EVENTS is not set/CONFIG_BPF_EVENTS=y/' .config
	fi
	+$(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- $(IMG) modules dtbs -j 8
	if [ $(WITH_PERF) -eq  1 ]; then
		+$(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- tools/perf
	fi
	if [ $(WITH_CUSTOM_KO) -eq  1 ]; then
		+cd $(linux/dir)/../custom/
		+$(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)-
	fi
	if [ $(WITH_LIB_BPF) -eq  1 ]; then
		+cd $(linux/dir)/tools/lib/bpf
		+$(CROSS_MAKE_ENV) EXTRA_CFLAGS='$(CFLAGS) -O2 --sysroot=$(HOST)/sysroot '  $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)-
	fi
	if [ $(WITH_SAMPLES_BPF) -eq  1 ]; then
		+cd $(linux/dir)
		+$(CROSS_ENV_RAW) $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)- INSTALL_HDR_PATH=$(HOST)/sysroot/usr headers_install
		+$(CROSS_MAKE_ENV) SYSROOT='$(HOST)/sysroot'  $(MAKE) M=samples/bpf ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)-
	fi
endef
