export SHELL := /bin/bash
export TOY_TOOLCHAIN = $(BASE)/toolchain
export TOY_DOWNLOAD := $(BASE)/../download
export TOY_WORK := $(BASE)/work
export TOY_OUT := $(TOY_WORK)/output
export TOY_STATE := $(TOY_WORK)/state
export BUILD := $(TOY_WORK)/build
export HOST := $(TOY_WORK)/host

CROSS_ENV_RAW = \
	PATH=$(TOY_TOOLCHAIN)/bin:$(PATH)  \
	CC=$(TOY_TOOLCHAIN)/bin/$(CROSS_NAME)-gcc  \
	CXX=$(TOY_TOOLCHAIN)/bin/$(CROSS_NAME)-g++ \
	LD="$(TOY_TOOLCHAIN)/bin/$(CROSS_NAME)-ld" \
	PKG_CONFIG_LIBDIR='$(HOST)/sysroot/usr/share/pkgconfig:$(HOST)/sysroot/usr/lib/pkgconfig'

CROSS_MAKE_ENV = \
	$(CROSS_ENV_RAW) \
	CFLAGS='$(CFLAGS) -O2 --sysroot=$(HOST)/sysroot '  \
	CXXFLAGS='$(CXXFLAGS) -O2 --sysroot=$(HOST)/sysroot '  \
	LDFLAGS=' --sysroot=$(HOST)/sysroot '

LOCAL_MAKE_ENV = PATH=$(PATH)

define init_work_space
	mkdir -p $(TOY_WORK)
	mkdir -p $(TOY_OUT)
	mkdir -p $(TOY_STATE)
	mkdir -p $(TOY_DOWNLOAD)
	mkdir -p $(BUILD)
	mkdir -p $(HOST)/sysroot

	cd $(HOST)/sysroot && \
        mkdir -p usr/lib && mkdir -p usr/lib64 && \
        mkdir -p usr/bin && mkdir -p usr/sbin && \
        rm -f lib64 lib && ln -s  usr/lib64 lib64 && ln -s  usr/lib lib && \
        rm -f bin sbin && ln -s  usr/bin bin && ln -s usr/sbin sbin && \
        cd -
endef
