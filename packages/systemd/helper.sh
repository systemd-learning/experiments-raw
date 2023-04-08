#!/bin/bash

set -eo pipefail
set -x

gen_cross_conf() {
BUILDDIR=$1

        cat > ${BUILDDIR}/cross.conf <<EOF
[binaries]
c = '${TOOLCHAIN}/bin/${CROSS_NAME}-gcc'
cpp = '/bin/false'
ar = '${TOOLCHAIN}/bin/${CROSS_NAME}-ar'
strip = '${TOOLCHAIN}/bin/${CROSS_NAME}-strip'
cmake = '/bin/false'
fortran = '/bin/false'
pkgconfig = '${HOST}/bin/pkgconf'
g-ir-compiler = '/bin/false'
g-ir-scanner = '/bin/false'

[built-in options]
c_args = ['-D_LARGEFILE_SOURCE', '-D_LARGEFILE64_SOURCE', '-D_FILE_OFFSET_BITS=64', '-Os', '-g0', '-D_FORTIFY_SOURCE=1', '-I${HOST}/sysroot/include', '--sysroot=${HOST}/sysroot' ]
c_link_args = ['--sysroot=${HOST}/sysroot']
cpp_args = ['-D_LARGEFILE_SOURCE', '-D_LARGEFILE64_SOURCE', '-D_FILE_OFFSET_BITS=64', '-Os', '-g0', '-D_FORTIFY_SOURCE=1']
cpp_link_args = []
fortran_args = []
fortran_link_args = []
wrap_mode = 'nodownload'
cmake_prefix_path = '/bin/false'

[properties]
needs_exe_wrapper = true
root = '${HOST}/sysroot'
sys_root = '${HOST}/sysroot'
pkg_config_libdir = '${HOST}/sysroot/lib/pkgconfig'
pkg_config_static = 'false'
# enable meson build to pass a toolchain file to cmake
cmake_toolchain_file = '/bin/false'
cmake_defaults = false

[host_machine]
system = 'linux'
cpu_family = 'aarch64'
cpu = 'cortex-a57'
endian = 'little'
EOF
}

gen_initrd_files() {
touch ${HOST}/sysroot/etc/initrd-release

cat > ${HOST}/sysroot/usr/lib/systemd/system/initrd.service <<EOF
[Unit]
Description=Raw Shell
#Documentation=man:sulogin(8)
DefaultDependencies=no
Conflicts=shutdown.target
Before=shutdown.target

[Service]
Environment=HOME=/root
WorkingDirectory=-/root
ExecStart=-/bin/sh
Type=simple
StandardInput=tty-force
StandardOutput=inherit
StandardError=inherit
KillMode=process
IgnoreSIGPIPE=no
SendSIGHUP=yes
EOF

cat > ${HOST}/sysroot/usr/lib/systemd/system/initrd.target <<EOF
#  SPDX-License-Identifier: LGPL-2.1-or-later
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

[Unit]
Description=Initrd Default Target
Documentation=man:systemd.special(7)
OnFailure=emergency.target
OnFailureJobMode=replace-irreversibly
AssertPathExists=/etc/initrd-release
Requires=basic.target
Wants=initrd-root-fs.target initrd-root-device.target initrd-fs.target initrd-usr-fs.target initrd-parse-etc.service initrd.service
After=initrd-root-fs.target initrd-root-device.target initrd-fs.target initrd-usr-fs.target basic.target rescue.service rescue.target initrd.service
AllowIsolate=yes
EOF
}

config_initrd_as_default() {
	gen_initrd_files
	rm -f ${HOST}/sysroot/usr/lib/systemd/system/default.target
	ln -s ${HOST}/sysroot/usr/lib/systemd/system/initrd.target  ${HOST}/sysroot/usr/lib/systemd/system/default.target
}

work_around_shift-overflow() {
	sed -i  's/'-Werror=shift-overflow=2'/'-Werror=shift-overflow=1'/' ${BUILDDIR}/meson.build
}

