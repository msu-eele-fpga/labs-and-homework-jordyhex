ifneq ($(KERNELRELEASE),)

obj-m := led_patterns.o

else

KDIR ?= $(HOME)/linux-socfpga

default:
	$(MAKE) -C $(KDIR) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
endif
