export SHELL := /bin/bash
export DOWNLOAD := $(BASE)/../download
export TOOLCHAIN = $(BASE)/toolchain
export WORK := $(BASE)/work
export OUTPUT := $(WORK)/output
export BUILD := $(WORK)/build
export HOST := $(WORK)/host
export STATE := $(WORK)/state

CROSS_ENV_RAW = \
	PATH=$(TOOLCHAIN)/bin:$(PATH)  \
	CC=$(TOOLCHAIN)/bin/$(CROSS_NAME)-gcc  \
	CXX=$(TOOLCHAIN)/bin/$(CROSS_NAME)-g++ \
	LD="$(TOOLCHAIN)/bin/$(CROSS_NAME)-ld"

CROSS_MAKE_ENV = \
	$(CROSS_ENV_RAW) \
	CFLAGS='$(CFLAGS) -O2 --sysroot=$(HOST)/sysroot '  \
	CXXFLAGS='$(CXXFLAGS) -O2 --sysroot=$(HOST)/sysroot '  \
	LDFLAGS=' --sysroot=$(HOST)/sysroot '

LOCAL_MAKE_ENV = PATH=$(PATH)

define init_work_space
	mkdir -p $(WORK)
	mkdir -p $(OUTPUT)
	mkdir -p $(BUILD)
	mkdir -p $(HOST)/sysroot
	mkdir -p $(STATE)

	cd $(HOST)/sysroot && \
        mkdir -p usr/lib && mkdir -p usr/lib64 && \
        mkdir -p usr/bin && mkdir -p usr/sbin && \
        rm -f lib64 lib && ln -s  usr/lib64 lib64 && ln -s  usr/lib lib && \
        rm -f bin sbin && ln -s  usr/bin bin && ln -s usr/sbin sbin && \
        cd -
endef
