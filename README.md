# Allwinner-V3s-BROM

This repository contains the Allwinner V3s Boot ROM Reverse Engineering work.

The Allwinner V3s SoC starts by executing a piece of code stored in masked ROM known as "BROM" (for Boot ROM).

It is located at address 0xffff0000 and its size is 32KB (0x8000).

## Get the Tools

### Dump tool

In order to dump its contents, you need first to clone the sunxi-tools repository using:

```git clone https://github.com/linux-sunxi/sunxi-tools.git```

Then follow the [building instructions](https://github.com/linux-sunxi/sunxi-tools.git), basically:

	cd sunxi-tools
	make

(We don't need to target tools).

### Disassembly tool

In order to turn the dump into something readable, you will need linux machine and download an ARM cross-toolchain, such as the one contained in the FunKey SDK from:

https://github.com/FunKey-Project/FunKey-OS/releases/download/FunKey-OS-2.0.0/FunKey-sdk-2.0.0.tar.gz

In order to install it, type:

	sudo tar zxvf FunKey-sdk-2.0.0.tar.gz -C /opt

## Dump the ROM
In order to dump the ROM, type:

	sudo ./sunxi-fel read 0xffff0000 0x8000 path_to_your/brom

## Disassemble the ROM
In order to disassemble the ROM into readable ARM instructions, type:

	/opt/FunKey-sdk-2.0.0/bin/arm-funkey-linux-musleabihf-objdump -D -bbinary -marm --adjust-vma=0xffff0000 path_to_your/brom >path_to_your/brom.s

