###############################################################################

# toolchain is built with
# `./configure --prefix=$RISCV --with-arch=rv64gc --with-abi=lp64d --with-sim=spike --enable-llvm`

###############################################################################

meson --help
meson setup --help >_demos/meson.setup.help.log
meson configure --help >_demos/meson.configure.help.log

riscv64-unknown-elf-gcc --print-multi-lib

###############################################################################

# TODO: `picolibc-cross.txt` come from project `crosstool-ng`, needs update

args=(
  --reconfigure
  -Dmultilib-list="rv64imac/lp64,rv64imafdc/lp64d"
  --cross-file=$PWD/_demos/picolibc-cross.txt
  --prefix=$PWD/build-meson/install
  -Dsemihost=true
  -Dnewlib-initfini-array=true
  build-meson
)
meson setup "${args[@]}"

meson compile -C build-meson
meson install -C build-meson

###############################################################################

# pushd build-meson/install/lib/
# riscv64-unknown-elf-objdump -d libc.a >libc.a.dasm
# riscv64-unknown-elf-objdump -d libcrt0-hosted.a >liblibcrt0-hostedc.a.dasm
# riscv64-unknown-elf-objdump -d libcrt0-minimal.a >libcrt0-minimal.a.dasm
# riscv64-unknown-elf-objdump -d libcrt0-semihost.a >libcrt0-semihost.a.dasm
# riscv64-unknown-elf-objdump -d libcrt0.a >libcrt0.a.dasm
# riscv64-unknown-elf-objdump -d libdummyhost.a >libdummyhost.a.dasm
# # riscv64-unknown-elf-objdump -d -g libc.a >libc.a.g.dasm
# popd

###############################################################################
