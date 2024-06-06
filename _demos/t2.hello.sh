###############################################################################

# TARGET="hello-world/printf.c"
TARGET="hello-world/hello-world.c"
SPECS="build-meson/picolibc.specs"
LDSCRIPT="_demos/riscv.ld"

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  # -march=rv64im -mabi=lp64
  -march=rv64imd -mabi=lp64d
  -specs=$SPECS
  -mcmodel=medany
  # -g
  -O0
  # -v
  --oslib=semihost
  # --oslib=dummyhost
  -T$LDSCRIPT
  $TARGET
)
riscv64-unknown-elf-gcc -S -o $DIR/a.s "${args[@]}"
riscv64-unknown-elf-gcc -o $DIR/a.out -Wl,-Map=$DIR/map.map "${args[@]}"

riscv64-unknown-elf-objdump -d $DIR/a.out >$DIR/a.out.dasm
riscv64-unknown-elf-objdump -d -g $DIR/a.out >$DIR/a.out.g.dasm

###############################################################################

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  -machine virt
  -cpu rv64
  -semihosting-config enable=on # semihost
  -nographic
  -bios none
  -monitor none
  -serial none
  -kernel $DIR/a.out
)
qemu-system-riscv64 "${args[@]}"

###############################################################################

# spike does not support semihost, check log for insts
DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  --pc=0x80000000
  # -d
  -l
  --log $DIR/a.out.spike.log
  $DIR/a.out
)
spike "${args[@]}"

###############################################################################
