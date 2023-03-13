#!/bin/bash

set -eo pipefail
set -x

add_procfs_sysfs_devfs_rcS() {
        pushd $1/sysroot

        mkdir -p proc
        mkdir -p sys
        mkdir -p dev
        mkdir -p etc
        mkdir -p mnt

        cat >etc/fstab <<EOF
proc            /proc   proc    defaults    0   0
sys             /sys    sysfs   defaults    0   0
EOF

        mkdir -p etc/init.d/
        cat >etc/init.d/rcS <<EOF
#!/bin/sh

/bin/mount -a
EOF
        chmod +x etc/init.d/rcS

        cat >etc/inittab <<EOF
::sysinit:/etc/init.d/rcS
::respawn:-/bin/sh
::ctrlaltdel:/bin/umount -a -r
EOF
        popd
}

check_params() {
	if [ $# != 3 ] ; then
		echo "USAGE: $0 staging_dir output_dir outfile"
		exit 1;
	fi

	echo "staging dir: " $1
	echo "output dir: " $2
}

make_initramfs() {
	check_params $@
        add_procfs_sysfs_devfs_rcS $1
        pushd $1/sysroot
        find . | cpio -o -H newc | gzip -9 > $2/$3
        popd
}

make_initrd() {
	check_params $@
	add_procfs_sysfs_devfs_rcS $1

	dd if=/dev/zero of=$2/$3 bs=1024k count=4
	mkfs.ext2 -F -m0 $2/$3

	TMP=`mktemp -d ./tmpd.XXX`

	sudo mount -t ext2 -o loop $2/$3 ${TMP}
	sudo cp -r $1/sysroot/* ${TMP}
	sudo umount ${TMP}
}

