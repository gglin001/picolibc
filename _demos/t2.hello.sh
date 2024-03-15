TARGET="hello-world/hello-world.c"
# TARGET="hello-world/printf.c"

OUTDIR="_demos/outdir"
SPECS="build-meson/picolibc.specs"
LDSCRIPT="hello-world/riscv.ld"

args=(
  # -march=rv64imac -mabi=lp64
  -march=rv64im -mabi=lp64
  -specs=$SPECS
  -mcmodel=medany
  # -g
  -O0
  # -v
  --oslib=semihost
  -T$LDSCRIPT
  $TARGET
)

mkdir -p $OUTDIR
riscv64-unknown-elf-gcc -S -o $OUTDIR/a.s "${args[@]}"
riscv64-unknown-elf-gcc -o $OUTDIR/a.out -Wl,-Map=$OUTDIR/map.map "${args[@]}"

riscv64-unknown-elf-objdump -d $OUTDIR/a.out >$OUTDIR/a.out.dasm
riscv64-unknown-elf-objdump -d -g $OUTDIR/a.out >$OUTDIR/a.out.g.dasm

# =============================================================================

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
