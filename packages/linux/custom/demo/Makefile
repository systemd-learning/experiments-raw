obj-m += demo.o
KDIR ?= ../../linux-5.10.65-rt53-rebase

ifneq ($(KERNELRELEASE),)
# kbuild part of makefile
obj-m  := demo.o

else
# normal makefile

default:
	$(MAKE) -C $(KDIR) M=$$PWD

install:
	$(MAKE) -C $(KDIR) M=$$PWD  modules_install
endif
