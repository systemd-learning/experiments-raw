libbpf/VERSION :=
libbpf/TARBALL :=
linux/VERSION := 5.10.65-rt53-rebase
libbpf/dir = $(BUILD)/linux/linux-$(linux/VERSION)

define libbpf/install :=
	+cd $(libbpf/dir)/tools/lib/bpf
	+$(CROSS_MAKE_ENV) EXTRA_CFLAGS='$(CFLAGS) -O2 --sysroot=$(HOST)/sysroot ' $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)-  prefix=$(HOST)/sysroot/usr/ install
	if [ $(WITH_SAMPLES_BPF) -eq  1 ]; then
		+mkdir -p $(HOST)/sysroot/opt
		+cp -r $(libbpf/dir)/samples/bpf $(HOST)/sysroot/opt
	fi
endef


define libbpf/build :=
	+cd $(libbpf/dir)/tools/lib/bpf
	+$(CROSS_MAKE_ENV) EXTRA_CFLAGS='$(CFLAGS) -O2 --sysroot=$(HOST)/sysroot '  $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)-
	if [ $(WITH_SAMPLES_BPF) -eq  1 ]; then
		+cd $(libbpf/dir)
		+$(CROSS_MAKE_ENV) SYSROOT='$(HOST)/sysroot'  $(MAKE) M=samples/bpf ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_NAME)-
	fi
endef
