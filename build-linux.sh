if [ ! -e images/KnightOS.flp ]
then
	echo ">>> Creating new KnightOS floppy image..."
	mkdosfs -C images/KnightOS.flp 1440 || exit
fi


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o src/bootloader.bin src/bootloader.asm || exit