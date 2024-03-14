# toolchain is built with
# `./configure --prefix=$RISCV --with-arch=rv64im --with-abi=lp64 --with-sim=spike --enable-llvm`

# TODO: `picolibc-cross.txt` come from project `crosstool-ng`, needs update

meson setup --reconfigure \
  --cross-file=picolibc-cross.txt \
  --prefix=$PWD/build-meson/install \
  -Dsemihost=false \
  build-meson

meson compile -C build-meson
meson install -C build-meson

# ===

pushd build-meson/install/lib/
riscv64-unknown-elf-objdump -d libc.a >libc.a.dasm
riscv64-unknown-elf-objdump -d -g libc.a >libc.a.g.dasm
riscv64-unknown-elf-objdump -d libcrt0-hosted.a >liblibcrt0-hostedc.a.dasm
riscv64-unknown-elf-objdump -d libcrt0-minimal.a >libcrt0-minimal.a.dasm
riscv64-unknown-elf-objdump -d libcrt0.a >libcrt0.a.dasm
riscv64-unknown-elf-objdump -d libg.a >libg.a.dasm
riscv64-unknown-elf-objdump -d libm.a >libm.a.dasm
riscv64-unknown-elf-objdump -d libdummyhost.a >libdummyhost.a.dasm
popd
