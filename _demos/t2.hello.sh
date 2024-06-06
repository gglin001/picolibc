###############################################################################

# TARGET="hello-world/printf.c"
TARGET="hello-world/hello-world.c"
SPECS="build-meson/picolibc.specs"
LDSCRIPT="_demos/riscv.ld"

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  # -ffreestanding
  # -Wl,--gc-sections -nostartfiles -nostdlib -nodefaultlibs
  -Wl,--gc-sections
  #
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
riscv64-unknown-elf-gcc -S -o $DIR/main.s "${args[@]}"
riscv64-unknown-elf-gcc -o $DIR/main -Wl,-Map=$DIR/map.map "${args[@]}"

#####

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  -d
  # -D
  # -g
  $DIR/main
)
riscv64-unknown-elf-objdump "${args[@]}" >$DIR/main.dasm

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
  -kernel $DIR/main
)
qemu-system-riscv64 "${args[@]}"

###############################################################################

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  -O binary
  $DIR/main
  $DIR/main.bin
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
  -kernel $DIR/main.bin
)
qemu-system-riscv64 "${args[@]}"

###############################################################################

TARGET="hello-world/hello-world.c"
SPECS="build-meson/picolibc.specs"
LDSCRIPT="_demos/riscv.ld"

DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  # -ffreestanding
  # -Wl,--gc-sections -nostartfiles -nostdlib -nodefaultlibs
  -Wl,--gc-sections
  #
  # -march=rv64im -mabi=lp64
  -march=rv64imd -mabi=lp64d
  -specs=$SPECS
  -mcmodel=medany
  # -g
  -O0
  # -v
  # --oslib=semihost
  --oslib=dummyhost
  -T$LDSCRIPT
  -o $DIR/main.dummyhost
  $TARGET
)
riscv64-unknown-elf-gcc "${args[@]}"
riscv64-unknown-elf-objdump -d $DIR/main.dummyhost >$DIR/main.dummyhost.dasm

#####

# need `--oslib=dummyhost`
# spike does not support semihost, check log for instructions
DIR="_demos/t2.hello" && mkdir -p $DIR
args=(
  --pc=0x80000000
  # -d
  -l
  --log $DIR/main.dummyhost.spike.log
  $DIR/main.dummyhost
)
spike "${args[@]}"

###############################################################################
