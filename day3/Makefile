CFLAGS := -Wall -m32 -fno-pie
QEMU_FLAGS := 

ifdef DEBUG
CFLAGS += -g
QEMU_FLAGS += -s -S
endif

all: haribote.img

ipl.bin: ipl.asm
	nasm ipl.asm -f bin -o ipl.bin -l ipl.lst

asmhead.bin: asmhead.asm
	nasm asmhead.asm -f elf -o asmhead.bin -l asmhead.lst

func.bin: func.asm
	nasm func.asm -f elf -o func.bin -l func.lst

haribote.sys: asmhead.bin func.bin bootpack.o
	ld -m elf_i386 --oformat binary asmhead.bin func.bin bootpack.o -o haribote.sys -T haribote.ld 

haribote.img: ipl.bin haribote.sys
	dd if=/dev/zero of=haribote.img bs=512 count=2880
	dd if=ipl.bin of=haribote.img bs=512 count=1 conv=notrunc
	dd if=haribote.sys of=haribote.img bs=512 seek=33 conv=notrunc

.PHONY: run clean
run: haribote.img
	qemu-system-i386 -drive file=haribote.img,format=raw,index=0,if=floppy $(QEMU_FLAGS)

clean:
	rm -f *.bin *.lst *.sys *.img *.o
