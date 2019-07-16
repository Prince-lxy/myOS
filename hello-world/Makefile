all: hello-world.bin

hello-world.bin: hello-world.asm
	nasm -o $@ $^

image:
	@echo "#######################################################################"
	@echo "# dd hello-world.bin to hello-world.img"
	@echo "#######################################################################"
	@dd if=hello-world.bin of=hello-world.img bs=512 count=1
	@dd if=/dev/zero of=hello-world.img seek=1 bs=512 count=2879	

copy:
	@echo "#######################################################################"
	@echo "# copy hello-world.img to bochs-pc"
	@echo "#######################################################################"
	@cp hello-world.img ../bochs-pc/floppya.img

clean:
	@rm hello-world.bin
