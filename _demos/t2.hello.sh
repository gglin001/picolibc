TARGET="hello-world/hello-world.c"
# TARGET="hello-world/printf.c"

OUTDIR="_demos/outdir"
SPECS="build-meson/picolibc.specs"
LDSCRIPT="_demos/riscv.ld"

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

mkdir -p $OUTDIR
riscv64-unknown-elf-gcc -S -o $OUTDIR/a.s "${args[@]}"
riscv64-unknown-elf-gcc -o $OUTDIR/a.out -Wl,-Map=$OUTDIR/map.map "${args[@]}"

riscv64-unknown-elf-objdump -d $OUTDIR/a.out >$OUTDIR/a.out.dasm
riscv64-unknown-elf-objdump -d -g $OUTDIR/a.out >$OUTDIR/a.out.g.dasm

# =============================================================================

# semihost
args=(
  -machine virt
  -cpu rv64
  -semihosting-config enable=on
  -nographic
  -bios none
  -monitor none
  -serial none
  -kernel $OUTDIR/a.out
)
qemu-system-riscv64 "${args[@]}"

# =============================================================================

# debug
args=(
  --pc=0x80000000
  -l
  _demos/outdir/a.out
)
spike -l --log _demo/log.log "${args[@]}"
# spike -l "${args[@]}" 2>_demo/log.log
# spike -d "${args[@]}"
# spike "${args[@]}"
