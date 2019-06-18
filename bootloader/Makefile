CC=gcc
LD=ld
OBJCOPY=objcopy

CFLAGS=-c
TRIM_FLAGS=-R .pdr -R .comment -R.note -S -O binary

LDFILE_BOOTLOADER=bootloader.ld
LDFILE_KERNEL=kernel.ld
LDFLAGS_BOOTLOADER=-T$(LDFILE_BOOTLOADER)
LDFLAGS_KERNEL=-T$(LDFILE_KERNEL)

all: bootloader.img KERNEL.BIN
	@echo '#################################################################'
	@echo '# Compiling work finished, now you can use "sudo make copy" to'
	@echo '# copy KERNEL.BIN into bootloader.img'
	@echo '#################################################################'

bootloader.bin: bootloader.S
	$(CC) $(CFLAGS) bootloader.S
	$(LD) bootloader.o -o bootloader.elf $(LDFLAGS_BOOTLOADER)
	$(OBJCOPY) $(TRIM_FLAGS) bootloader.elf $@

KERNEL.BIN: kernel.S
	$(CC) $(CFLAGS) kernel.S
	$(LD) kernel.o -o kernel.elf $(LDFLAGS_KERNEL)
	$(OBJCOPY) $(TRIM_FLAGS) kernel.elf $@

bootloader.img: bootloader.bin
	@dd if=bootloader.bin of=bootloader.img bs=512 count=1
	@dd if=/dev/zero of=bootloader.img skip=1 seek=1 bs=512 count=2879

# You must have the authority to do mount, or you must use "su root" or
# "sudo" command to do "make copy"
copy: bootloader.img KERNEL.BIN
	@mkdir -p /tmp/floppy;\
	mount -o loop bootloader.img /tmp/floppy/ -o fat=12;\
	cp KERNEL.BIN /tmp/floppy/;\
	umount /tmp/floppy/;\
	rm -rf /tmp/floppy/;

clean: 
	@rm -f *.o *.elf *.bin *.BIN

distclean: clean
	@rm -f bootloader.img
