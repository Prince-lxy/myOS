all: boot.bin LOADER.BIN KERNEL.ELF image

boot.bin: boot.asm fat12.inc
	nasm -o $@ $<

LOADER.BIN: loader.asm fat12.inc pm.inc
	nasm -o $@ $<

KERNEL.ELF: kernel.asm
	nasm -f elf32 -o kernel.o $^
	ld -s -m elf_i386 -Ttext 0x30400 -o $@ kernel.o

image: boot.bin
	@echo "#######################################################################"
	@echo "# dd boot.bin to boot.img"
	@echo "#######################################################################"
	@dd if=boot.bin of=boot.img bs=512 count=1
	@dd if=/dev/zero of=boot.img seek=1 bs=512 count=2879	

copy: boot.img LOADER.BIN KERNEL.ELF
	@echo "#######################################################################"
	@echo "# copy LOADER.BIN to boot.img"
	@echo "#######################################################################"
	@mkdir -p /tmp/floppy;\
	sudo mount -o loop boot.img /tmp/floppy/ -o fat=12;\
	sudo cp LOADER.BIN KERNEL.ELF /tmp/floppy/;\
	sudo umount /tmp/floppy/;\
	rm -rf /tmp/floppy/;

insert: boot.img
	@echo "#######################################################################"
	@echo "# insert boot.img to bochs-pc"
	@echo "#######################################################################"
	@cp boot.img ../bochs-pc/floppya.img

clean:
	@rm boot.img boot.bin LOADER.BIN KERNEL.ELF kernel.o
