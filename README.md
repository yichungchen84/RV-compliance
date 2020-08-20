## Verilator-based RISC-V compliance test.

1. make sure you have verilator, risc-v gnu linux toolchain ready.
  (also needs "elf2hex" provided by SiFive)
2. open the run_ct.pl and change $root_path to the full path of current main folder.
3. "./run_ct.pl -runTB -arch rv32i" to create hex files.
4. navigate to example/picorv32 and then "../../run_ct.pl -runRC -arch rv32i" to run compliance test

RV32I - NOP, RF_width, and RF_size are 2019/2020 version due to errors in 2018/2019 version. 

for the installation of "elf2hex", please change the name and path of the configuration according to the latest riscv-toolchain
for example: "./configure --target=riscv64-unknown-linux-gnu --bindir=/opt/riscv/bin"
