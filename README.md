## Verilator-based RISC-V compliance test.

1. make sure you have verilator, risc-v gnu linux toolchain ready.
2. open the run_ct.pl and change $root_path to the full path of current main folder.
3. "./run_ct.pl -runTB -arch rv32i" to create hex files.
4. navigate to example/picorv32 and then "../../run_ct.pl -runRC -arch rv32i" to run compliance test
