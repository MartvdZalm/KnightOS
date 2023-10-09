#!/bin/sh

if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'sudo' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e disk_images/KnightOS.flp ]
then
	echo ">>> Creating new KnightOS floppy image..."
	mkdosfs -C disk_images/KnightOS.flp 1440 || exit
fi


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm || exit


echo ">>> Assembling kernel..."

cd src
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit
cd ..


echo ">>> Assembling programs..."

cd programs

for i in *.asm
do
	nasm -O0 -w+orphan-labels -f bin $i -o `basename $i .asm`.bin || exit
done

cd ..


echo ">>> Adding bootloader to floppy image..."

dd status=noxfer conv=notrunc if=src/bootloader/bootloader.bin of=disk_images/KnightOS.flp || exit


echo ">>> Copying kernel and programs..."

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat disk_images/KnightOS.flp tmp-loop && cp src/kernel.bin tmp-loop/

cp programs/*.bin programs/*.txt tmp-loop

sleep 0.2

echo ">>> Unmounting loopback floppy..."

umount tmp-loop || exit

rm -rf tmp-loop

echo '>>> Done!'

