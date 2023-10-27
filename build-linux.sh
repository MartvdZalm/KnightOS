if [ ! -e images/KnightOS.flp ]
then
	echo ">>> Creating new KnightOS floppy image..."
	mkdosfs -C images/KnightOS.flp 1440
fi

echo ">>> Assembling bootloader..."
nasm -f bin -o src/bootloader.bin src/bootloader.asm

echo ">>> Adding bootloader to floppy image..."
dd if=src/bootloader.bin of=images/KnightOS.flp

echo '>>> Done!'