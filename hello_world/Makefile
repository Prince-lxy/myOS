CC = gcc
LD = ld
LDFILE = hello_world.ld
OBJCOPY = objcopy

all: hello_world.img

hello_world.o: hello_world.S
	$(CC) -c hello_world.S

hello_world.elf: hello_world.o
	$(LD) hello_world.o -o hello_world.elf -e 0x7c00 -T$(LDFILE)

hello_world.bin: hello_world.elf
	@$(OBJCOPY) -R .pdr -R .comment -R .note -S -O binary hello_world.elf hello_world.bin

hello_world.img : hello_world.bin
	@dd if=hello_world.bin of=hello_world.img bs=512 count=1
	@dd if=/dev/zero of=hello_world.img seek=1 bs=512 count=2879

clean:
	@rm -rf hello_world.o hello_world.elf hello_world.bin hello_world.img
