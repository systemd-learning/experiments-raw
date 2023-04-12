SHELL := /bin/bash
DOWNLOAD := $(DOWNLOAD)
STATE := $(STATE)
ROOT_PREFIX ?= sysroot
LOCAL_BUILD ?= 0

.PHONY: all
-include $(BASE)/../packages/*/*.mk


depends = $(subst $(BASE),./,$(STATE))/dep.$1.$2.build_$(LOCAL_BUILD)

define depfile =
	mkdir -p '$(STATE)'
	$(info "depfile: $(BASE)/$(call depends,$1,$2)")
	touch '$(BASE)/$(call depends,$1,$2)'
endef

#############################################
# Dynamically declare dependencies between packages
#############################################
define declaredeps =
	$(eval .PHONY: $1)
	$(eval $1: $(call depends,$1,package))
	$(eval $(call depends,$1,package) : $(call depends,$1,install) ; $(call packagepkg,$1) )
	$(eval $(call depends,$1,install) : $(call depends,$1,build)   ; $(call installpkg,$1) )
	$(eval $(call depends,$1,build)   : $(call depends,$1,prepare) ; $(call buildpkg,$1)   )
	$(eval $(call depends,$1,prepare) : $(call depends,$1,download); $(call preparepkg,$1) )
	$(eval $(call depends,$1,download):                            ; $(call downloadpkg,$1))
endef

define declare_all =
	$(if $($1_done),,$(call declaredeps,$1) $(eval $1_done=1))
endef

.SHELLFLAGS = -e -c
.ONESHELL:


#############################################
# Macros for specific stages
#############################################
define downloadpkg =
	$(eval $(info "DOWNLOAD_PKG: $(LOCAL_BUILD) URL: $($1/TARBALL)"))
	mkdir -p '$(DOWNLOAD)'
	cd '$(DOWNLOAD)'
	if [ -n '$($1/TARBALL)' ]; then
		if [ ! -f $(notdir $($1/TARBALL)) ]; then
			wget '$($1/TARBALL)' -O- > '$(DOWNLOAD)/$(notdir $($1/TARBALL))'
		fi
	fi
	$(call depfile,$1,download)
endef

define preparepkg =
	$(eval $(info "PREPARE_PKG"))
	mkdir -p '$(BUILD)/$1'
	cd '$(BUILD)/$1'
	if [ -n '$($1/TARBALL)' ]; then
		mkdir -p $($1/dir)
		tar -xf '$(DOWNLOAD)/$(notdir $($1/TARBALL))' --strip-components=1  -C $($1/dir)
	fi
	$(call $1/prepare)
	$(call depfile,$1,prepare)
endef

define buildpkg =
	$(eval $(info "BUILD_PKG"))
	mkdir -p '$(HOST)'
	$(call $1/build)
	$(call depfile,$1,build)
endef

define installpkg =
	$(eval $(info "INSTALL_PKG"))
	$(call $1/install)
	$(call depfile,$1,install)
endef

define packagepkg =
	$(eval $(info "PACKAGE_PKG"))
	mkdir -p '$(OUTPUT)'
	$(call $1/package)
	$(call depfile,$1,package)
endef

#############################################
# Targets
#############################################
all: $(PACKAGES)

# Import dependencies between packages and package stages
$(foreach pkg,$(PACKAGES),$(call declare_all,$(pkg)))

clean:
	rm -rf '$(DOWNLOAD)' '$(STATE)' '$(STAGE)' '$(OUTPUT)' '$(BUILD)'

