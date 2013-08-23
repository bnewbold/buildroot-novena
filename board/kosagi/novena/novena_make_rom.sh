#!/bin/sh
# based on: https://github.com/sutajiokousagi/meta-kosagi/blob/novena/conf/machine/include/imx61.inc

set -e # halt on failure

BOARD_DIR="$(dirname $0)"

GENFATFS=$HOST_DIR/usr/bin/genfatfs
MAKEDISK=$HOST_DIR/usr/bin/makedisk

KERNEL_UIMAGE=$BINARIES_DIR/uImage
KERNEL_UIMAGE_RENAME=uImage-novena.bin
KERNEL_DTB=$BINARIES_DIR/imx6q-novena.dtb
KERNEL_DTB_RENAME=uImage-novena.dtb
UBOOT_BIN=$BINARIES_DIR/u-boot.imx
UBOOT_SCR=$BINARIES_DIR/boot.scr

ROOTFS_IMG=$BINARIES_DIR/rootfs.ext4

WORK_DIR=$BASE_DIR/makedisk
FATFS_BLOCKS=65536
BOOT_SIZE=32M
EXT_SIZE=400M 	# TODO: grab this from a BR2_something environment variable?
PADDING_SIZE=512k
FINAL_IMAGE=$BINARIES_DIR/novena-final-image.img

if [ ! -f $MAKEDISK ] ||
   [ ! -f $GENFATFS ]; then
        echo "makedisk and/or genfatfs missing."
        exit 1
fi

if [ ! -f $KERNEL_UIMAGE ] ||
   [ ! -f $KERNEL_DTB ]; then
        echo "Kernel files missing."
        exit 1
fi

if [ ! -f $UBOOT_BIN ] ||
   [ ! -f $UBOOT_SCR ]; then
        echo "u-boot files missing."
        exit 1
fi

if [ ! -f $ROOTFS_IMG ]; then
        echo "rootfs disk image missing."
        exit 1
fi


# alright, on with it.
echo "Partitioning and assembling final image file..."
set -x # verbose command output
mkdir -p $WORK_DIR/fat-boot
cp $UBOOT_BIN $WORK_DIR/fat-boot
cp $UBOOT_SCR $WORK_DIR/fat-boot
cp $KERNEL_UIMAGE $WORK_DIR/fat-boot/$KERNEL_UIMAGE_RENAME
cp $KERNEL_DTB $WORK_DIR/fat-boot/uImage-novena.dtb
$GENFATFS -d $WORK_DIR/fat-boot -b $FATFS_BLOCKS $WORK_DIR/boot-novena.vfat
$MAKEDISK -o $FINAL_IMAGE \
	-p $PADDING_SIZE \
	-a $BOOT_SIZE:0x0b:$WORK_DIR/boot-novena.vfat \
	-a $EXT_SIZE:0x83:$ROOTFS_IMG
dd if=$UBOOT_BIN of=$FINAL_IMAGE bs=512 conv=notrunc seek=2
rm -rf $WORK_DIR

set +x # verbose command output off
echo "Created final image file"
ls -lh $FINAL_IMAGE
echo "Compressing image..."
rm -f $FINAL_IMAGE.gz
gzip $FINAL_IMAGE
ls -lh $FINAL_IMAGE.gz
echo "Done, but you should probably run 'sync'."
