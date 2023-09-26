nasm src/main.asm -f bin -o bin/main.bin
copy bin\main.bin bin\main_floppy.img
trunc bin/main_floppy.img 1474560