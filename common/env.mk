
CROSS_MAKE_ENV = \
	PATH=$(TOOLCHAIN)/bin:$(PATH)  \
	CC=$(TOOLCHAIN)/bin/$(CROSS_PREFIX)gcc  \
	CXX=$(TOOLCHAIN)/bin/$(CROSS_PREFIX)g++ \
	CFLAGS=" ${CFLAGS} -I$(HOST)/$(ROOT_PREFIX)/include --sysroot=$(HOST)/sysroot "  \
	CXXFLAGS=" ${CXXFLAGS} -I$(HOST)/$(ROOT_PREFIX)/include --sysroot=$(HOST)/sysroot "  \
	LD="$(TOOLCHAIN)/bin/$(CROSS_PREFIX)ld"  \
	LDFLAGS=' -L$(HOST)/$(ROOT_PREFIX) ' 

LOCAL_MAKE_ENV = PATH=$(PATH)
