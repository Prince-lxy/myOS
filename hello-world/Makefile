CC = gcc
LD = ld
LDFILE = hello-world.ld
OBJCOPY = objcopy

all: hello-world.img

hello-world.o: hello-world.S
	$(CC) -c hello-world.S

hello-world.elf: hello-world.o
	$(LD) hello-world.o -o hello-world.elf -e 0x7c00 -T$(LDFILE)

hello-world.bin: hello-world.elf
	@$(OBJCOPY) -R .pdr -R .comment -R .note -S -O binary hello-world.elf hello-world.bin

hello-world.img : hello-world.bin
	@dd if=hello-world.bin of=hello-world.img bs=512 count=1
	@dd if=/dev/zero of=hello-world.img seek=1 bs=512 count=2879

clean:
	@rm -rf hello-world.o hello-world.elf hello-world.bin hello-world.img
