all: pm.bin

pm.bin: pm.asm
	nasm -o $@ $^

image:
	@echo "#######################################################################"
	@echo "# dd pm.bin to pm.img"
	@echo "#######################################################################"
	@dd if=pm.bin of=pm.img bs=512 count=1
	@dd if=/dev/zero of=pm.img seek=1 bs=512 count=2879	

copy:
	@echo "#######################################################################"
	@echo "# copy pm.img to bochs-pc"
	@echo "#######################################################################"
	@cp pm.img ../bochs-pc/floppya.img

clean:
	@rm pm.bin pm.img
