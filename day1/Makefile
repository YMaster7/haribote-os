hello_os.bin: hello_os.asm
	nasm hello_os.asm -o hello_os.bin

.PHONY: clean run
clean:
	rm -f hello_os.bin

run: hello_os.bin
	qemu-system-i386 -drive file=hello_os.bin,format=raw,index=0,if=floppy
