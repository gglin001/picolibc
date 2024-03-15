# toolchain is built with
# `./configure --prefix=$RISCV --with-arch=rv64im --with-abi=lp64 --with-sim=spike --enable-llvm`

# TODO: `picolibc-cross.txt` come from project `crosstool-ng`, needs update

args=(
  --reconfigure
  --cross-file=picolibc-cross.txt
  --prefix=$PWD/build-meson/install
  # -Dsemihost=false
  -Dsemihost=true
  # -Dnewlib-initfini-array=false
  -Dnewlib-initfini-array=true
  build-meson
)
meson setup "${args[@]}"

meson compile -C build-meson
meson install -C build-meson

# ===

pushd build-meson/install/lib/
riscv64-unknown-elf-objdump -d libc.a >libc.a.dasm
riscv64-unknown-elf-objdump -d libcrt0-hosted.a >liblibcrt0-hostedc.a.dasm
riscv64-unknown-elf-objdump -d libcrt0-minimal.a >libcrt0-minimal.a.dasm
riscv64-unknown-elf-objdump -d libcrt0-semihost.a >libcrt0-semihost.a.dasm
riscv64-unknown-elf-objdump -d libcrt0.a >libcrt0.a.dasm
riscv64-unknown-elf-objdump -d libdummyhost.a >libdummyhost.a.dasm
riscv64-unknown-elf-objdump -d -g libc.a >libc.a.g.dasm
popd
