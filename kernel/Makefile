### tools
ASM = nasm
CC = gcc
LD = ld
ASMFLAG = -f elf32
ASMFLAG_BOOT = -I boot/include/
CFLAG = -I include -m32 -fno-builtin
LDFLAG = -s -m elf_i386 -Ttext 0x30400

BOOTLOADER = boot/boot.bin boot/loader.bin
KERNEL = kernel/kernel.elf
OBJS = kernel/kernel.o kernel/start.o kernel/8259a.o lib/string.o lib/libports.o

### target
all: $(BOOTLOADER) $(KERNEL) floppy copy insert

### bootloader
boot/boot.bin: boot/boot.asm boot/include/fat12.inc boot/include/bootloader.inc
	$(ASM) $(ASMFLAG_BOOT) -o $@ $<

boot/loader.bin: boot/loader.asm boot/include/fat12.inc boot/include/pm.inc boot/include/bootloader.inc
	$(ASM) $(ASMFLAG_BOOT) -o $@ $<

### kernel
$(KERNEL): $(OBJS)
	$(LD) $(LDFLAG) -o $@ $^

kernel/kernel.o: kernel/kernel.asm
	$(ASM) $(ASMFLAG) -o $@ $^

kernel/start.o: kernel/start.c include/const.h include/type.h include/protect.h include/global.h include/string.h
	$(CC) $(CFLAG) -c -o $@ $<

kernel/8259a.o: kernel/8259a.c include/const.h include/type.h include/protect.h include/ports.h
	$(CC) $(CFLAG) -c -o $@ $<

### lib
lib/string.o: lib/string.asm
	$(ASM) $(ASMFLAG) -o $@ $^

lib/libports.o: lib/libports.asm
	$(ASM) $(ASMFLAG) -o $@ $^

### floppy
floppy: boot/boot.bin
	@echo "#######################################################################"
	@echo "# dd boot.bin to floppy.img"
	@echo "#######################################################################"
	@dd if=boot/boot.bin of=floppy.img bs=512 count=1
	@dd if=/dev/zero of=floppy.img seek=1 bs=512 count=2879	

copy: floppy.img boot/loader.bin $(KERNEL)
	@echo "#######################################################################"
	@echo "# copy boot/loader.bin $(KERNEL) to floppy.img"
	@echo "#######################################################################"
	@mkdir -p /tmp/floppy;\
	sudo mount -o loop floppy.img /tmp/floppy/ -o fat=12;\
	sudo cp boot/loader.bin $(KERNEL) /tmp/floppy/;\
	sudo umount /tmp/floppy/;\
	rm -rf /tmp/floppy/;

insert: floppy.img
	@echo "#######################################################################"
	@echo "# insert floppy.img to bochs-pc"
	@echo "#######################################################################"
	@cp floppy.img ../bochs-pc/floppya.img

clean:
	@rm floppy.img $(BOOTLOADER)  $(KERNEL) $(OBJS)
