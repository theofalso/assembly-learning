
boot1_file = boot1
boot2_file = boot2
kernel_file = kernel
boot_disk = disk.img

KERNEL_DEPS = $(kernel_file).asm shell.asm drivers.asm data.asm

block_size = 512
disk_size = 100
nasm_flags = -f bin
qemu_flags = -fda
all: run
run: $(boot_disk)
	clear
	@qemu-system-i386 -audiodev pa,id=audio0 -machine pcspk-audiodev=audio0 $(qemu_flags) $(boot_disk)


build: $(boot_disk)

$(boot_disk): $(boot1_file).bin $(boot2_file).bin $(kernel_file).bin
	@dd if=/dev/zero of=$(boot_disk) bs=$(block_size) count=$(disk_size) status=noxfer
	@dd if=$(boot1_file).bin of=$(boot_disk) bs=$(block_size) count=1 conv=notrunc status=noxfer
	@dd if=$(boot2_file).bin of=$(boot_disk) bs=$(block_size) seek=1 count=1 conv=notrunc status=noxfer
	@dd if=$(kernel_file).bin of=$(boot_disk) bs=$(block_size) seek=2 count=20 conv=notrunc status=noxfer

$(boot1_file).bin: $(boot1_file).asm
	@nasm $(nasm_flags) $(boot1_file).asm -o $(boot1_file).bin

$(boot2_file).bin: $(boot2_file).asm
	@nasm $(nasm_flags) $(boot2_file).asm -o $(boot2_file).bin

$(kernel_file).bin: $(KERNEL_DEPS)
	@nasm $(nasm_flags) $(kernel_file).asm -o $(kernel_file).bin

clean:
	@rm -f *.bin $(boot_disk) *~
	clear