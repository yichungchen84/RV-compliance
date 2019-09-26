#!/usr/bin/perl

####Start Note
	# Quick Note:
	# This is designed for Linux
	# make sure the following files are executable
	# if no, please use "chmod a+x" to make them executable on your system
	# change the $root_path to the path where run_ct.pl is available
####Start Note

################################ USER SETUP (if need) ################################

####Set path to main directory
my $root_path = "/home/cheny/applications/RV-compliance"; # root path (optional, but recommended)
if ($root_path ne undef)
{
	$root_path = $root_path."/";
}
####Set path to main directory

####Set path to tool binary
my $verilator_path = ""; # verilator path (optional)
if ($verilator_path ne undef)
{
	$verilator_path = $verilator_path."/";
}
my $riscv_gnu_toolchain_path = ""; # RISC-V gnu toolchain path (optional)
if ($riscv_gnu_toolchain_path ne undef)
{
	$riscv_gnu_toolchain_path = $riscv_gnu_toolchain_path."/";
}
my $elf2hex_path = ""; # elf2hex path (optional)
if ($elf2hex_path ne undef)
{
	$elf2hex_path = $elf2hex_path."/";
}
####Set path to tool binary

####Tool Name
my $verilator_bin = $verilator_path."verilator"; #verilator binary
my $riscv_gnu_gcc_bin = $riscv_gnu_toolchain_path."riscv32-unknown-linux-gnu-gcc"; # riscv gcc binary
my $riscv_gnu_gcc_ld = $riscv_gnu_toolchain_path."riscv32-unknown-linux-gnu-ld"; # riscv ld binary
my $elf2hex_bin = $elf2hex_path."riscv32-unknown-linux-gnu-elf2hex"; # elf to hex binary
# my $riscv_gnu_objdump_bin = $riscv_gnu_toolchain_path."riscv32-unknown-linux-gnu-objdump"; #riscv objdump binary
# my $riscv_gnu_objcopy_bin = $riscv_gnu_toolchain_path."riscv32-unknown-linux-gnu-objcopy"; #riscv objcopy binary
####Tool Name

####Set input/output folder
my $v_source_dir_name = "v_src"; # verilog source folder (optional)
my $c_source_dir_name = "c_src"; # c source folder (optional)
####Set input/output folder

####Set required parameters
my $arch = "";
my $march = "rv32i"; # architecture of RISCV
my $mabi = "ilp32"; # ABi setup, default to 32bit "ilp32", 64bit "lp64"
my $v_source_top = "top"; # top module name
my $c_source_file = "testbench.cc"; # header of test suite header
my $compliance_result_dir_name = "result";
my $compliance_report_name = "report.txt";
my $bit_width = "32"; # bit width for elf2hex
####Set required parameters

####Set path to compliance suite
my $test_suite_dir_name = "riscv-test-suite"; # compliance suite (default)
my $test_src_dir_name = "src"; # compliance source (default)
my $test_ref_dir_name = "references"; # compliance references (default)
my $test_ref_type_name = "reference_output"; # file type name
my $test_suite_header_dir_name = "include"; # header of test suite header
my $test_suite_output_dir_name = "testbenchs"; # output folder name (optional)
####Set path to compliance suite

####Set path to compliance suite
my $test_suite_path = $root_path.$test_suite_dir_name; # compliance suite (default)
my $test_suite_header_path = $root_path.$test_suite_header_dir_name; # header of test suite header
my $test_suite_output_path = $root_path.$test_suite_output_dir_name; # header of test suite output
####Set path to compliance suite

####Set file to compliance suite
my $test_suite_link_script_name = "link.ld"; # header of test suite header
####Set file to compliance suite

####Set file to compliance suite
my $test_suite_link_script_path = $root_path.$test_suite_header_dir_name."/".$test_suite_link_script_name; # header of test suite header
####Set file to compliance suite

####RunStage
my $run_mode = 1; #default from v to compliance
	# 0: 
	# 1: complaince test
	# 10: generate hex
####RunStage

for (my $i = 0; $i < ($#ARGV + 1); $i++)
{
	if ($ARGV[$i] eq "-runRC")
	{
		$run_mode = 1;
		print "Run RISC-V compliance test.\n";
	}
	elsif ($ARGV[$i] eq "-runTB")
	{
		$run_mode = 10;
		print "Generating RISC-V memory files.\n";
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

		print "RISC-V architecture: $arch\n";
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
if ($run_mode == 1)
{
	my $suite_dir = "";
	my @vsrc_file_list;
	my @suite_file_list;
	my $elf2hex_mem_dir = "";

	if ($arch eq undef)
	{
		die "ERROR: undefine of architecture\n";
	}
	else
	{
		$suite_dir = $test_suite_path."/".$arch;

		unless (-d $suite_dir)
		{
			die "ERROR: unsupported architecture or wrong suite path\n";
		}

		$suite_dir = $suite_dir."/".$test_src_dir_name;

		unless (-d $suite_dir)
		{
			die "ERROR: cannot find $test_src_dir_name folder\n";
		}
	}

	opendir(my $temp_vsrc_dir, $v_source_dir_name) or die "can't opendir $v_source_dir_name: $!";
	@vsrc_file_list = grep {/^[^\.+]/} readdir($temp_vsrc_dir);
	closedir $temp_vsrc_dir;

	for (my $i = 0; $i < ($#vsrc_file_list + 1); $i++)
	{
		$vsrc_file_list[$i] = $v_source_dir_name."/".$vsrc_file_list[$i];
	}

	my $vsrc_file_str = join(" ", @vsrc_file_list);

	# $#array

	my $temp_c_source = $c_source_dir_name."/".$c_source_file;

	system("$verilator_bin --cc -Wno-lint --top-module $v_source_top $vsrc_file_str --exe $temp_c_source");
	system("make -j -C obj_dir -f V$v_source_top.mk V$v_source_top");

	opendir(my $temp_suite_dir, $suite_dir) or die "can't opendir $suite_dir: $!";
	@suite_file_list = grep {/^[^\.+]/} readdir($temp_suite_dir);
	closedir $temp_suite_dir;

	$elf2hex_mem_dir = $test_suite_output_path."/".$arch;

	unless (-d $compliance_result_dir_name)
	{
		mkdir($compliance_result_dir_name);
	}

	if (-e $compliance_report_name)
	{
		unlink($compliance_report_name) or die "Could not delete file $compliance_report_name!\n";
	}

	# open(my $temp_report, '>>', $compliance_report_name) or die "Could not open file '$compliance_report_name' $!";

	foreach my $local_file (@suite_file_list)
	{
		my @temp_file_name = split(/\.S/,$local_file);
		my $temp_case_name = $elf2hex_mem_dir."/".$temp_file_name[0]."\."."hex";
		if (-e $temp_case_name)
		{
			system("obj_dir/V$v_source_top +memdata_file=$temp_case_name -o $compliance_result_dir_name/$temp_file_name[0].txt");
		}
		else
		{
			print "cannot find: $temp_case_name\n";
		}

		# print $temp_report "case: $temp_file_name[0]\n";
		print "case: $temp_file_name[0]\n";

		# my $temp_msg = 
		system("diff $compliance_result_dir_name/$temp_file_name[0].txt $test_suite_path/$arch/$test_ref_dir_name/$temp_file_name[0].$test_ref_type_name");
		# print $temp_report $temp_msg;
	}

	# close $temp_report;

}
elsif ($run_mode == 10)
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
		$suite_dir = $test_suite_path."/".$arch;

		unless (-d $suite_dir)
		{
			die "ERROR: unsupported architecture or wrong suite path\n";
		}

		$suite_dir = $suite_dir."/".$test_src_dir_name;

		unless (-d $suite_dir)
		{
			die "ERROR: cannot find $test_src_dir_name folder\n";
		}
	}

	unless (-d $test_suite_output_path)
	{
		mkdir($test_suite_output_path);
	}

	$elf2hex_mem_dir = $test_suite_output_path."/".$arch;

	if (-d $elf2hex_mem_dir)
	{
		system("rm -rf $elf2hex_mem_dir");
	}

	mkdir ($elf2hex_mem_dir);

	opendir(my $temp_suite_dir, $suite_dir) or die "can't opendir $suite_dir: $!";
	@suite_file_list = grep {/^[^\.+]/} readdir($temp_suite_dir);
	closedir $temp_suite_dir;

	foreach my $local_file (@suite_file_list)
	{
		my @temp_file_name = split(/\.S/,$local_file);
		my $temp_case_name = $temp_file_name[0];
		my $o_case_name = $elf2hex_mem_dir."/".$temp_case_name."\."."o";
		my $b_case_name = $elf2hex_mem_dir."/".$temp_case_name;
		my $h_case_name = $elf2hex_mem_dir."/".$temp_case_name."\."."hex";
		my $temp_local_file = $suite_dir."/".$local_file;
		system("$riscv_gnu_gcc_bin -I$test_suite_header_path -march=$march -mabi=$mabi -c $temp_local_file -o $o_case_name");
		system("$riscv_gnu_gcc_ld -o $b_case_name $o_case_name -T $test_suite_link_script_path");
		system("$elf2hex_bin --bit-width $bit_width --input $b_case_name --output $h_case_name");
	}
}
else
{
	die "ERROR: illegal mode\n";
}

sub ArchAbiCheck {
	my @argv_array = @_;
	my $temp_arch = $argv_array[0];
	my $temp_abi = $argv_array[1];
}

sub helpManual
{
	print "required files: \n";
	print "--------------------------------------------\n";
	die "developed by Yi-Chung Chen, Tennessee State University and SUNY New Paltz, 2019\n";
}
