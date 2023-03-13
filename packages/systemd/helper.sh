#!/bin/bash

set -eo pipefail
set -x

gen_cross_conf() {
BUILDDIR=$1

        cat > ${BUILDDIR}/cross.conf <<EOF
[binaries]
c = '${TOOLCHAIN}/bin/${CROSS_PREFIX}gcc'
cpp = '/bin/false'
ar = '${TOOLCHAIN}/bin/${CROSS_PREFIX}ar'
strip = '${TOOLCHAIN}/bin/${CROSS_PREFIX}strip'
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
