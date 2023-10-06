#!/bin/sh

# This script assembles the KnightOS bootloader, kernel and programs
# with NASM, and then creates floppy and CD images (on Linux)

# Only the root user can mount the floppy disk image as a virtual
# drive (loopback mounting), in order to copy across the files

if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'sudo' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e images/KnightOS.flp ]
then
	echo ">>> Creating new KnightOS floppy image..."
	mkdosfs -C images/KnightOS.flp 1440 || exit
fi


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm || exit


echo ">>> Assembling KnightOS kernel..."

cd src
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit
cd ..

echo ">>> Adding bootloader to floppy image..."

dd status=noxfer conv=notrunc if=src/bootloader/bootloader.bin of=images/KnightOS.flp || exit


echo ">>> Copying KnightOS kernel and programs..."

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat images/KnightOS.flp tmp-loop && cp src/kernel.bin tmp-loop/

sleep 0.2


echo ">>> Unmounting loopback floppy..."

umount tmp-loop || exit

rm -rf tmp-loop

echo '>>> Done!'

