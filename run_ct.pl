#!/usr/bin/perl

####Start Note
	# Quick Note:
	# This is designed for Linux
	# make sure the following files are executable
	# if no, please use "chmod a+x" to make them executable on your system
####Start Note

####temp
# verilator --cc -Wno-lint --top-module picorv32_wrapper testbench_ez.v picorv32.v --exe testbench.cc
# add obj_dir/picorv32_wrapper.h "verilated_heavy.h"
# make -j -C obj_dir -f Vpicorv32_wrapper.mk Vpicorv32_wrapper
####temp
################################ USER SETUP (if need) ################################

####Set path to tool binary
my $verilator_path = ""; # verilator path (optional)
my $riscv_gnu_toolchain_path = ""; # RISC-V gnu toolchain path (optional)
my $elf2hex_path = ""; # elf2hex path (optional)
####Set path to tool binary

####Tool Name
my $verilator_bin = "verilator"; #verilator binary
my $riscv_gnu_gcc_bin = "riscv64-unknown-linux-gnu-gcc"; # riscv gcc binary
my $elf2hex_bin = "riscv64-unknown-linux-gnu-elf2hex"; # elf to hex binary
my $riscv_gnu_objdump_bin = "riscv64-unknown-linux-gnu-objdump"; #riscv objdump binary
####Tool Name

####Set input/output folder
#my $source_path = "v_src/"; # verilog source folder (optional)
my $output_dir = "result"; # output folder name (optional)
####Set input/output folder

####Set required parameters
my $arch = "rv32i"; # architecture of RISCV
my $abi = "ilp32"; # ABi setup, default to 32bit "ilp32", 64bit "lp64"
my $v_source_top = "top"; # top module name
my $bit_width = "32"; # bit width for elf2hex
####Set required parameters

####Set path to compliance suite
my $test_suite = "riscv-test-suite"; # compliance suite (default)
my $test_suite_header = "include"; # header of test suite header
####Set path to compliance suite

####RunStage
my $run_mode = 0; #default from v to compliance
####RunStage

for (my $i = 0; $i < ($#ARGV + 1); $i++)
{
	if ($ARGV[$i] eq "-run")
	{
		$run_mode = 0;
		print "Run full flow of RISC-V compliance check\n";
	}
	elsif ($ARGV[$i] eq "-vlog")
	{
		$i++;
		if ($ARGV[$i] ne undef)
		{
			$v_source_top = $ARGV[$i];
		}

		print "under construction\n";
	}
	elsif ($ARGV[$i] eq "-arch")
	{
		$i++;
		if ($ARGV[$i] ne undef)
		{
			$arch = $ARGV[$i];
		}

		print "under construction\n";
	}
	elsif ($ARGV[$i] eq "-abi")
	{
		$i++;
		if ($ARGV[$i] ne undef)
		{
			$abi = $ARGV[$i];
		}

		print "under construction\n";
	}
	elsif (($ARGV[$i] eq "-h") || ($ARGV[$i] eq "-help"))
	{
		helpManual();
	}
	else
	{
		die "ERROR: illegal usage, -h/-help\n";
	}
}


####
# abi and arch check
####


####Flow Mode
if ($run_mode == 0)
{
	my $suite_dir = "";
	my @suite_file_list;
	my $elf2hex_mem_dir = "";

	if ($arch eq undef)
	{
		die "ERROR: undefine of architecture\n";
	}
	else
	{
		$suite_dir = "$test_suite/$arch";
		unless (-d $suite_dir)
		{
			die "ERROR: unsupported architecture or wrong suite path\n";
		}

		$suite_dir = "$suite_dir/src";
		unless (-d $suite_dir)
		{
			die "ERROR: cannot find src folder\n";
		}
	}

	if ($output_dir ne undef)
	{
		unless (-d $output_dir)
		{
			mkdir($output_dir);
		}

		$elf2hex_mem_dir = $output_dir."/".$arch;
	}
	else
	{
		$elf2hex_mem_dir = $arch;
	}

	print "path: $elf2hex_mem_dir\n";

	if (-d $elf2hex_mem_dir)
	{
		system("rm -rf $elf2hex_mem_dir");
	}

	mkdir ($elf2hex_mem_dir);

	opendir(my $temp_suite_dir, $suite_dir) or die "can't opendir $suite_dir: $!";
	@suite_file_list = grep {/^[^\.+]/} readdir($temp_suite_dir);
	closedir $temp_suite_dir;

	# print @suite_file_list;

	foreach my $local_file (@suite_file_list)
	{
		# print "name of file: $local_file\n";
		my @temp_file_name = split(/\./,$local_file);
		my $temp_case_name = $temp_file_name[0];
		my $o_case_name = $elf2hex_mem_dir."/".$temp_case_name."\."."o";
		my $h_case_name = $elf2hex_mem_dir."/".$temp_case_name."\."."hex";
		my $temp_local_file = $suite_dir."/".$local_file;
		# print "name of file: $temp_local_file\n";
		system("$riscv_gnu_gcc_bin -I$test_suite_header -march=$arch -mabi=$abi -c $temp_local_file -o $o_case_name");
		system("$elf2hex_bin --bit-width $bit_width --input $o_case_name --output $h_case_name");
		# last;

	}
}
else
{
	die "ERROR: illegal mode\n";
}
####Flow Mode

sub ArchAbiCheck {
	my @argv_array = @_;
	my $temp_arch = $argv_array[0];
	my $temp_abi = $argv_array[1];
}
