#!/bin/sh

set -e # halt on failure

BOARD_DIR="$(dirname $0)"

ROOTFS_IMG=$BINARIES_DIR/debian-rootfs.ext4
ROOTFS_TARBALL=$BINARIES_DIR/debian-rootfs.tar

WORK_DIR=$BASE_DIR/debian_rootfs_work

FAKEROOT=$HOST_DIR/usr/bin/fakeroot
# use wrapper script
GENEXT2FS=$BASE_DIR/../fs/ext2/genext2fs.sh

if [ ! -f $FAKEROOT ] ||
   [ ! -f $GENEXT2FS ]; then
        echo "makedisk and/or genfatfs missing."
        exit 1
fi

if [ ! -f $ROOTFS_TARBALL ]; then
        echo "debian rootfs tarball image missing."
        exit 1
fi

if [ "$FAKEROOTKEY" = "" ]; then
        echo "re-executing script inside fakeroot"
        $FAKEROOT "$0" "$@";
        exit
fi

PATH=$HOST_DIR/usr/bin/:$HOST_DIR/usr/sbin/:$PATH

# alright, on with it.
mkdir -p $WORK_DIR
cd $WORK_DIR
tar xf $ROOTFS_TARBALL
GEN=4 REV=1 $GENEXT2FS -d $WORK_DIR $ROOTFS_IMG

cd ..
rm -rf $WORK_DIR

set +x # verbose command output off
echo "Created $ROOTFS_IMG"
