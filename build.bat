:: bootloader
nasm src/bootloader/boot.asm -f bin -o bin/bootloader.bin

:: kernel
nasm src/kernel/main.asm -f bin -o bin/kernel.bin

:: floppy img
copy bin\bootloader.bin bin\main_floppy.img
type bin\kernel.bin >> bin\main_floppy.img