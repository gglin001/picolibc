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

#####

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  -d
  # -D
  # -g
  $DIR/a.out
)
riscv64-unknown-elf-objdump "${args[@]}" >$DIR/a.out.dasm

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

# spike does not support semihost, check log for instructions
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

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  -O binary
  $DIR/a.out
  $DIR/a.out.bin
)
riscv64-unknown-elf-objcopy "${args[@]}"

#####

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  -machine virt
  -cpu rv64
  -semihosting-config enable=on # semihost
  -nographic
  -bios none
  -monitor none
  -serial none
  -kernel $DIR/a.out.bin
)
qemu-system-riscv64 "${args[@]}"

###############################################################################
