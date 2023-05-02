#!/bin/bash

set -eo pipefail
set -x

init_host_sysroot() {
        pushd $1/sysroot
}

add_procfs_sysfs_devfs_rcS() {
        pushd $1/sysroot

        mkdir -p proc
        mkdir -p sys
        mkdir -p dev
        mkdir -p etc
        mkdir -p mnt
        mkdir -p tmp
        mkdir -p run

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

        cat >etc/passwd <<EOF
root:x:0:0:root:/root:/bin/sh
nobody:x:65534:65534:nobody:/home:/bin/false
EOF

        cat >etc/shadow <<EOF
root::::::::
nobody:*:::::::
EOF
	cd etc/ && ln -s ../proc/self/mounts mtab && cd -
        popd
}

check_params() {
	if [ $# != 3 ] ; then
		echo "USAGE: $0 host_dir output_dir outfile"
		exit 1;
	fi

	echo "host_dir: " $1
	echo "output_dir: " $2
	echo "output_file: " $3
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
	rm -fr ${TMP}
}

make_diskimg() {
	check_params $@
	add_procfs_sysfs_devfs_rcS $1
	HOST_DIR=$1
	OUT_DIR=$2
	OUT_FILE=$3

	rm -f ${OUT_DIR}/${OUT_FILE}
	dd if=/dev/zero of=${OUT_DIR}/${OUT_FILE} bs=1024k count=512
	mkfs.ext4 -L ROOT ${OUT_DIR}/${OUT_FILE}

	TMP=`mktemp -d ./tmpd.XXX`

	sudo mount -t ext4 -o loop  ${OUT_DIR}/${OUT_FILE} ${TMP}
	sudo cp -r $1/sysroot/* ${TMP}
	sudo umount ${TMP}
	rm -fr ${TMP}
}

set_root_password () {
	if [ $# != 2 ] ; then
		echo "USAGE: $0 output_dir password"
		exit 1
	fi

	local OUT=$1
	local PASSWD=$2
	local p=$(openssl passwd -1 -salt "salt" "${PASSWD}")
	sed -e "s/root:[^:]*:/root:${PASSWD}:/" -i ${OUT}/etc/shadow
}

copy_libs_from_toolchain() {
	if [ $# != 2 ] ; then
		echo "USAGE: $0 host_dir lib_file"
		exit 1
	fi

	FILES=`find ${1}/../../toolchain/ -name "${2}" 2>/dev/null`
	for F in ${FILES} ; do
		sudo cp -f ${F} $1/sysroot/lib/
	done
}

