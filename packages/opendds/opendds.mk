include $(BASE)/../common/env.mk

opendds/VERSION := 3.24.1
opendds/TARBALL := https://github.com/OpenDDS/OpenDDS/releases/download/DDS-3.24.1/OpenDDS-3.24.1.tar.gz
opendds/dir = $(BUILD)/opendds/opendds-$(opendds/VERSION)_build.$(LOCAL_BUILD)

# 生成编译平台的opendds_idl，而不是arm64 
OPEN_VENDER_ENV = \
	ARCH= 

define opendds/build :=
	+cd $(opendds/dir)
	+$(info opendds/dir: $(opendds/dir))
	+$(OPEN_VENDER_ENV) ./configure --target=linux-cross --target-compiler='$(TOY_TOOLCHAIN)/bin/$(CROSS_NAME)-g++'
	+$(OPEN_VENDER_ENV) '$(MAKE)' -j $(shell nproc)
endef

define opendds/install :=
	+cd $(opendds/dir) 
	+mkdir -p $(HOST)/sysroot/opt
	+cp -d -r $(opendds/dir)/build/target   $(HOST)/sysroot/opt
	echo 'export DDS_ROOT=/opt/target' > profile
	echo 'export ACE_ROOT=$$$${DDS_ROOT}/ACE_wrappers' >> profile
	echo 'export LD_LIBRARY_PATH=$$$${LD_LIBRARY_PATH}:$$$${ACE_ROOT}/lib:$$$${DDS_ROOT}/lib' >> profile
	echo 'export PATH=$$$${PATH}:$$$${ACE_ROOT}/bin:$$$${DDS_ROOT}/bin' >> profile
	+cp profile $(HOST)/sysroot/etc/
endef