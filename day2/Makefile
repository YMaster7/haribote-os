hello_os.img: hello_os.bin
	dd if=/dev/zero of=hello_os.img bs=512 count=2880
	dd if=hello_os.bin of=hello_os.img bs=512 count=1 conv=notrunc

hello_os.bin: hello_os.asm
	nasm hello_os.asm -o hello_os.bin -l hello_os.lst

.PHONY: clean run
clean:
	rm -f hello_os.bin hello_os.lst hello_os.img

run: hello_os.img
	qemu-system-i386 -drive file=hello_os.img,format=raw,index=0,if=floppy
