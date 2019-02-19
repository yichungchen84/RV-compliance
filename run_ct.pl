#!/usr/bin/perl

####Start Note
	# Quick Note:
	# This is designed for Linux
	# make sure the following files are executable
	# bin/steadystate bin/heat bin/msh_gen
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

# ####required file name, you can pre-setup here
# my $msh_file_name = ""; #mesh name
# my $xml_file_name = ""; #xml name
# my $ptrace_file_name = ""; #ptrace name
# ####required file name, you can pre-setup here

# #### define configuration
# my $msh_configuration = ""; # you can refer possible option in Manual or -help/-h of bin/msh_gen
# # my $msh_configuration = "-ufixmesh -ufixstretch"; # recommended setup for cell-level
# my $heat_configuration = ""; # you can refer possible option in Manual or -help/-h of bin/heat
# my $die_configuration = "-bypass bypass.txt"; # you can refer possible option in Manual or -help/-h of bin/diexml
# #### define configuration

####RunStage
my $run_mode = 0; #default from v to compliance
	# 0: IC(.xml) -> MESH(.msh) -> MTA
	# 1: MESH(.msh) -> MTA
	# 2: Package(.xml) + Die(.xml) -> IC(.xml) -> MESH(.msh) -> MTA; no mesh check, auto refine, and gui
	# 3: Package(.xml) + Die(.xml) -> IC(.xml) -> MESH(.msh) -> MTA with CELLOPT; no mesh check, auto refine, and gui
	# 5: Hotspot(.lcf) -> IC(.xml)
	# 6: Die(.stk) -> Die(.xml)
####RunStage

# ####RunMPI
# my $mpi_core_number = 0; #default is 1 (no MPI parallel)
# ####RunMPI

# ####enableGUI
# my $gmsh_gui = 0; # 1 enable
# my $paraview_gui = 0; # 1 enable
# ####RunStage

# ####Setup MTA Thermal Simulation Mode
# my $mode = 1; #default is mode 1
# 	#mode1: fixed time step, fixed mesh
# 	#mode2: adaptive time step, fixed mesh
# 	#mode3: fixed time step, adaptive mesh
# 	#mode4: adaptive time step, adaptive mesh
# 	#mode5: not support
# ####Setup MTA Thermal Simulation Mode

# ####Configuration for runflow
# my $check_mesh = 50000; #check size of DOF if mesh is too small. default to 50000, disable is 0
# ####Configuration for runflow

# ####extra function - convert your project from Hotspot 3-D
# my $lcf_file_name = ""; #lcf name
# my $hotspot_config_file_name = "hotspot.config"; # default to hotspot default configuation name
# ####extra function - convert your project from Hotspot 3-D

# ####LCF HEAT configuration
# my $number_FIN_X = 21; # 21 fins in heatsink (you can change to number you like)
# my $number_FIN_Y = 1; # y direction number of fin is default to 1 (better no t change)
# my $length_FIN = 1e-3; # thickness of fin (you can change to number you like)
# my $width_FIN; # default to size of heat sink (better no t change)
# my $height_FIN = 5e-2; #height of fin (you can change to number you like)
# ####LCF HEAT configuration

# ####Parsing Stack - convert your project from DEF LEF
# my $stk_file_name = ""; #stk name
# ####Parsing Stack - convert your project from DEF LEF

# ####Parsing average power value - for cellopt of power density evaluation and smart hybird mode
# my $avg_file_name = ""; #.avg name
# ####Parsing average power value - for cellopt of power density evaluation and smart hybird mode

# ####Smart Rate configuration
# my $smart_rate = 0.1;
# ####Smart Rate configuration

# ################################ No Need To SETUP below ################################
# #### temp_data
# my $thermal_configuration = "";
# my $good_mesh = 0;
# #### temp_data

# ####Mode Configuration
# my $mode0_configuration = "-steady";
# my $mode1_configuration = "";
# my $mode2_configuration = "-ats";
# my $mode3_configuration = "-amr";
# my $mode4_configuration = "-amr -ats";
# ####Mode Configuration



# ####
# my $default_xml_file_name = "defaultXMLName.xml"; # set generated xml name
# my $default_opt_file_name = "defaultOPTName.opt"; # set generated opt name
# my $default_msh_file_name = "defaultMeshName.msh"; # set generated mesh name if no runtime definition
# ####

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
	# elsif ($ARGV[$i] eq "-vlog")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$v_source_top = $ARGV[$i];
	# 	}
		
	# 	print "under construction\n";
	# }
	# elsif ($ARGV[$i] eq "-runCELL")
	# {
	# 	$run_mode = 2;
	# 	$heat_configuration = "-output_simple output.rng";
	# 	print "RUN MTA: Package(.xml){Die(.xml)} -> IC(.xml) -> MESH(.msh) -> MTA\n";
	# 	print "Change output to simple mode. Please change this in perl script about arguments\n";
	# }
	# elsif ($ARGV[$i] eq "-runCELLOPT")
	# {
	# 	$run_mode = 3;
	# 	$heat_configuration = "-output_simple output.rng";
	# 	print "RUN MTA: Package(.xml){Die(.xml)} -> IC(.xml) -> MESH(.msh) -> MTA with cell homogenization\n";
	# 	print "Change output to simple mode. Please change this in perl script about arguments\n";
	# }
	# elsif ($ARGV[$i] eq "-lcf")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$lcf_file_name = $ARGV[$i];
	# 		$run_mode = 5;
	# 		print "READIN LCF: $ARGV[$i]\n";
	# 		print "please include .flp .config .lcf in the same directory.\n";
	# 		print "this command only generates .xml without running any simualtion.\n";
	# 		print "run MTA (-runXML) with .xml and .ptrace again to simulate thermal profile.\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: no .lcf file.\n";
	# 	}
	# }
	# elsif ($ARGV[$i] eq "-stack")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$stk_file_name = $ARGV[$i];
	# 		$run_mode = 6;
	# 		print "READIN STK: $ARGV[$i]\n";
	# 		print "please include .def .lef in the same directory.\n";
	# 		print "this command only generates die .xml without running any simualtion.\n";
	# 		print "run MTA (-runCELL) with .xml .ptrace and .avg again to simulate thermal profile.\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: no .stk file.\n";
	# 	}
	# }
	# elsif ($ARGV[$i] eq "-avgpower")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$avg_file_name = $ARGV[$i];
	# 		print "READIN AVG: $ARGV[$i]\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: no .avg file.\n";
	# 	}
	# }
	# elsif ($ARGV[$i] eq "-xml")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$xml_file_name = $ARGV[$i];
	# 		print "READIN/OUTPUT XML: $ARGV[$i]\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: no .xml file.\n";
	# 	}
	# }
	# elsif ($ARGV[$i] eq "-ptrace")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$ptrace_file_name = $ARGV[$i];
	# 		print "READIN PTRACE: $ARGV[$i]\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: no .ptrace file.\n";
	# 	}
	# }
	# elsif ($ARGV[$i] eq "-mesh")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$msh_file_name = $ARGV[$i];
	# 		print "READIN/OUTPUT MESH: $ARGV[$i]\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: no .msh file.\n";
	# 	}
	# }
	# elsif ($ARGV[$i] eq "-mode")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$mode = $ARGV[$i];
	# 		print "SET MTA in MODE $ARGV[$i]\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: mode number.\n";
	# 	}
	# }
	# elsif ($ARGV[$i] eq "-gmsh")
	# {
	# 	$gmsh_gui = 1;
	# 	print "ENABLE MESH VISUALIZATION\n";
	# }
	# elsif ($ARGV[$i] eq "-paraview")
	# {
	# 	$paraview_gui = 1;
	# 	print "ENABLE RESULT VISUALIZATION\n";
	# }
	# elsif ($ARGV[$i] eq "-mpi")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$mpi_core_number = $ARGV[$i];
	# 		print "RUN MPI in NP = $ARGV[$i]\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: MPI NP number.\n";
	# 	}
	# }
	# elsif ($ARGV[$i] eq "-folder")
	# {
	# 	$i++;
	# 	if ($ARGV[$i] ne undef)
	# 	{
	# 		$output_folder = $ARGV[$i];
	# 		print "Output folder: $ARGV[$i]\n";
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: no output folder name.\n";
	# 	}
	# }
	elsif (($ARGV[$i] eq "-h") || ($ARGV[$i] eq "-help"))
	{
		helpManual();
	}
	else
	{
		die "ERROR: illegal usage, -h/-help\n";
	}
}

# if ($mode == 0)
# {
# 	$thermal_configuration = $heat_configuration." ".$mode0_configuration;
# }
# elsif ($mode == 1)
# {
# 	$thermal_configuration = $heat_configuration." ".$mode1_configuration;
# }
# elsif ($mode == 2)
# {
# 	$thermal_configuration = $heat_configuration." ".$mode2_configuration;
# }
# elsif ($mode == 3)
# {
# 	$thermal_configuration = $heat_configuration." ".$mode3_configuration;
# }
# elsif ($mode == 4)
# {
# 	$thermal_configuration = $heat_configuration." ".$mode4_configuration;
# }
# elsif ($mode == 5)
# {
# 	$thermal_configuration = ""; #next project
# }
# else
# {
# 	die "ERROR: undefine of mode.\n";
# }

# ####Output folder
# if ($output_folder ne undef)
# {
# 	$thermal_configuration = $thermal_configuration." -folder $output_folder";
# }
# ####Output folder


# ####MPI SETUP
# if ($mpi_core_number > 0)
# {
# 	if (($mode == 3) || ($mode == 4))
# 	{
# 		print "WARNING: Current version does not support adaptive mesh refinement on multiple processors\n";
# 	}
# 	else
# 	{
# 		if ($mpi ne undef)
# 		{
# 			$mpi = $mpi."/"."mpirun -np ".$mpi_core_number;
# 		}
# 		else
# 		{
# 			$mpi = "mpirun -np ".$mpi_core_number;
# 		}
# 	}
# }
# ####MPI SETUP

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



	
	# if ($v_source_top eq undef)
	# {
	# 	die "ERROR: undefine of source file.\n";
	# }

	# if ($msh_file_name eq undef)
	# {
	# 	print "WARNING: undefine of .msh file\n";
	# 	print "Using default mesh name - defaultMeshName.msh.\n";
	# 	$msh_file_name = $default_msh_file_name;
	# }
	

	# if (-e $xml_file_name)
	# {
	# 	if (-e "$ptrace_file_name")
	# 	{
	# 		if (-e $output_folder)
	# 		{
	# 			system("rm $output_folder/solution*");
	# 		}
	# 		else
	# 		{
	# 			system("mkdir $output_folder");
	# 		}

	# 		my $mesh_folder = $output_folder;
	# 		if ($output_folder ne undef)
	# 		{
	# 			$mesh_folder = $output_folder."/"
	# 		}

	# 		print "Mesh Generation: ";
	# 		my $com_msh_file_name = $mesh_folder.$msh_file_name;

	# 		if (-e $com_msh_file_name)
	# 		{
	# 			system("rm $com_msh_file_name");
	# 		}
	# 		print "$mta_root/$mesh_generator_name -xml $xml_file_name -mesh $com_msh_file_name $msh_configuration\n";
	# 		system("$mta_root/$mesh_generator_name -xml $xml_file_name -mesh $com_msh_file_name $msh_configuration");

	# 		my $refine = 0;

	# 		if ($check_mesh != 0)
	# 		{
	# 			meshCheck($com_msh_file_name);
	# 			while ($good_mesh != 0)
	# 			{
	# 				print "Need a automatic MESH refinement (DOF > $check_mesh). Current DOF is $good_mesh\n";
	# 				$refine += 1;
	# 				print "Refine Mesh Generation: ";
	# 				print "$mta_root/$mesh_generator_name -xml $xml_file_name -mesh $com_msh_file_name $msh_configuration -refine $refine\n";
	# 				system("$mta_root/$mesh_generator_name -xml $xml_file_name -mesh $com_msh_file_name $msh_configuration -refine $refine");
	# 				meshCheck($com_msh_file_name);
	# 			}
	# 		}

	# 		if ($gmsh_gui == 1)
	# 		{
	# 			system("$gmsh_root/gmsh $com_msh_file_name &");
	# 		}

	# 		print "Thermal Simulation: ";
	# 		print "$mpi $mta_root/$heat_solver_name -xml $xml_file_name -mesh $com_msh_file_name -ptrace $ptrace_file_name $thermal_configuration\n";
	# 		system("$mpi $mta_root/$heat_solver_name -xml $xml_file_name -mesh $com_msh_file_name -ptrace $ptrace_file_name $thermal_configuration");
	# 		if ($paraview_gui == 1)
	# 		{
	# 			system("$paraview_root/paraview $output_folder/solution.pvd &");
	# 		}
	# 	}
	# 	else
	# 	{
	# 		die "ERROR: CANNOT OPEN $ptrace_file_name, no file\n";
	# 	}
	# }
	# else
	# {
	# 	die "ERROR: CANNOT OPEN $xml_file_name, no file\n";
	# }
}
# elsif ($run_mode == 1)
# {
# 	if ($xml_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .xml file.\n";
# 	}
# 	elsif ($ptrace_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .ptrace file.\n";
# 	}
# 	elsif ($msh_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .msh file.\n";
# 	}

# 	if (-e "$xml_file_name")
# 	{
# 		if (-e "$ptrace_file_name")
# 		{
# 			if (-e "$msh_file_name")
# 			{
# 				if ($check_mesh != 0)
# 				{
# 					meshCheck($msh_file_name);
# 					if ($good_mesh != 0)
# 					{
# 						print "Need a manual MESH refinement (DOF > $check_mesh). Current DOF is $good_mesh\n";
# 						exit 1;
# 					}
# 				}
# 				if ($gmsh_gui == 1)
# 				{
# 					system("$gmsh_root/gmsh $msh_file_name &");
# 				}
# 				if (-e $output_folder)
# 				{
# 					system("rm $output_folder/solution*");
# 				}
# 				else
# 				{
# 					system("mkdir $output_folder");
# 				}
# 				print "Thermal Simulation: ";
# 				print "$mpi $mta_root/$heat_solver_name -xml $xml_file_name -mesh $msh_file_name -ptrace $ptrace_file_name $thermal_configuration\n";
# 				system("$mpi $mta_root/$heat_solver_name -xml $xml_file_name -mesh $msh_file_name -ptrace $ptrace_file_name $thermal_configuration");
# 				if ($paraview_gui == 1)
# 				{
# 					system("$paraview_root/paraview $output_folder/solution.pvd &");
# 				}
# 			}
# 			else
# 			{
# 				die "ERROR: CANNOT OPEN $msh_file_name, no file\n";
# 			}
# 		}
# 		else
# 		{
# 			die "ERROR: CANNOT OPEN $ptrace_file_name, no file\n";
# 		}
# 	}
# 	else
# 	{
# 		die "ERROR: CANNOT OPEN $xml_file_name, no file\n";
# 	}
# }
# elsif ($run_mode == 2)
# {
# 	if ($xml_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .xml file.\n";
# 	}
# 	elsif ($ptrace_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .ptrace file.\n";
# 	}
# 	elsif ($msh_file_name eq undef)
# 	{
# 		print "WARNING: undefine of .msh file\n";
# 		print "Using default mesh name - defaultMeshName.msh.\n";
# 		$msh_file_name = $default_msh_file_name;
# 	}

# 	my $xml_out_file_name = $default_xml_file_name;
# 	print "Using default XML name - defaultXMLName.xml.\n";

# 	if (-e "$xml_file_name")
# 	{
# 		if (-e "$ptrace_file_name")
# 		{
# 			if (-e $output_folder)
# 			{
# 				system("rm $output_folder/solution*");
# 			}
# 			else
# 			{
# 				system("mkdir $output_folder");
# 			}

# 			my $xml_folder = $output_folder;
# 			if ($output_folder ne undef)
# 			{
# 				$xml_folder = $output_folder."/"
# 			}
# 			print "XML Generation: ";
# 			my $com_xml_file_name = $xml_folder.$xml_out_file_name;
# 			if (-e $com_xml_file_name)
# 			{
# 				system("rm $com_xml_file_name");
# 			}
# 			print "$mta_root/$package_generator_name -inxml $xml_file_name -outxml $com_xml_file_name\n";
# 			system("$mta_root/$package_generator_name -inxml $xml_file_name -outxml $com_xml_file_name");

# 			my $mesh_folder = $output_folder;
# 			if ($output_folder ne undef)
# 			{
# 				$mesh_folder = $output_folder."/"
# 			}
# 			print "Mesh Generation: ";
# 			my $com_msh_file_name = $mesh_folder.$msh_file_name;
# 			if (-e $com_msh_file_name)
# 			{
# 				system("rm $com_msh_file_name");
# 			}

# 			print "$mta_root/$mesh_generator_name -xml $com_xml_file_name -mesh $com_msh_file_name $msh_configuration\n";
# 			system("$mta_root/$mesh_generator_name -xml $com_xml_file_name -mesh $com_msh_file_name $msh_configuration");

# 			print "Thermal Simulation: ";
# 			print "$mpi $mta_root/$heat_solver_name -xml $com_xml_file_name -mesh $com_msh_file_name -ptrace $ptrace_file_name $thermal_configuration\n";
# 			system("$mpi $mta_root/$heat_solver_name -xml $com_xml_file_name -mesh $com_msh_file_name -ptrace $ptrace_file_name $thermal_configuration");
# 		}
# 		else
# 		{
# 			die "ERROR: CANNOT OPEN $ptrace_file_name, no file\n";
# 		}
# 	}
# 	else
# 	{
# 		die "ERROR: CANNOT OPEN $xml_file_name, no file\n";
# 	}
# }
# elsif ($run_mode == 3)
# {
# 	if ($xml_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .xml file.\n";
# 	}
# 	elsif ($ptrace_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .ptrace file.\n";
# 	}
# 	elsif ($avg_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .avg file (for smart hybrid homogenization).\n";
# 	}
# 	elsif ($msh_file_name eq undef)
# 	{
# 		print "WARNING: undefine of .msh file\n";
# 		print "Using default mesh name - defaultMeshName.msh.\n";
# 		$msh_file_name = $default_msh_file_name;
# 	}

# 	my $xml_out_file_name = $default_xml_file_name;
# 	print "Using default XML name - defaultXMLName.xml.\n";
# 	my $opt_file_name = $default_opt_file_name;
# 	print "Using default OPT name - defaultOPTName.opt.\n";

# 	if (-e "$xml_file_name")
# 	{
# 		if (-e "$ptrace_file_name")
# 		{
# 			if (-e "$avg_file_name")
# 			{
# 				if (-e $output_folder)
# 				{
# 					system("rm $output_folder/solution*");
# 				}
# 				else
# 				{
# 					system("mkdir $output_folder");
# 				}

# 				my $xml_folder = $output_folder;
# 				if ($output_folder ne undef)
# 				{
# 					$xml_folder = $output_folder."/"
# 				}
# 				print "XML Generation: ";
# 				my $com_xml_file_name = $xml_folder.$xml_out_file_name;
# 				if (-e $com_xml_file_name)
# 				{
# 					system("rm $com_xml_file_name");
# 				}
# 				print "$mta_root/$package_generator_name -inxml $xml_file_name -outxml $com_xml_file_name\n";
# 				system("$mta_root/$package_generator_name -inxml $xml_file_name -outxml $com_xml_file_name");

# 				my $mesh_folder = $output_folder;
# 				if ($output_folder ne undef)
# 				{
# 					$mesh_folder = $output_folder."/"
# 				}
# 				print "Mesh Generation: ";
# 				my $com_msh_file_name = $mesh_folder.$msh_file_name;
# 				if (-e $com_msh_file_name)
# 				{
# 					system("rm $com_msh_file_name");
# 				}

# 				my $opt_folder = $output_folder;
# 				if ($output_folder ne undef)
# 				{
# 					$opt_folder = $output_folder."/"
# 				}
# 				# print "Mesh Generation: ";
# 				my $com_opt_file_name = $opt_folder.$opt_file_name;
# 				if (-e $com_opt_file_name)
# 				{
# 					system("rm $com_opt_file_name");
# 				}

# 				print "$mta_root/$mesh_generator_name -xml $com_xml_file_name -mesh $com_msh_file_name -optoutput $com_opt_file_name -smartopt $avg_file_name -SMARTRATE $smart_rate $msh_configuration\n";
# 				system("$mta_root/$mesh_generator_name -xml $com_xml_file_name -mesh $com_msh_file_name -optoutput $com_opt_file_name -smartopt $avg_file_name -SMARTRATE $smart_rate $msh_configuration");

# 				print "Thermal Simulation: ";
# 				print "$mpi $mta_root/$heat_solver_name -xml $com_xml_file_name -mesh $com_msh_file_name -ptrace $ptrace_file_name -cellopt $com_opt_file_name $thermal_configuration\n";
# 				system("$mpi $mta_root/$heat_solver_name -xml $com_xml_file_name -mesh $com_msh_file_name -ptrace $ptrace_file_name -cellopt $com_opt_file_name $thermal_configuration");
# 			}
# 			else
# 			{
# 				die "ERROR: CANNOT OPEN $avg_file_name, no file\n";
# 			}
# 		}
# 		else
# 		{
# 			die "ERROR: CANNOT OPEN $ptrace_file_name, no file\n";
# 		}
# 	}
# 	else
# 	{
# 		die "ERROR: CANNOT OPEN $xml_file_name, no file\n";
# 	}
# }
# elsif ($run_mode == 5)
# {
# 	if ($xml_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .xml file.\n";
# 	}
# 	elsif ($lcf_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .lcf file.\n";
# 	}

# 	if (-e "$lcf_file_name")
# 	{
# 		lcfConverter($lcf_file_name, $xml_file_name, $hotspot_config_file_name);
# 	}
# 	else
# 	{
# 		die "ERROR: CANNOT OPEN $lcf_file_name, no file\n";
# 	}
# }
# elsif ($run_mode == 6)
# {
# 	if ($xml_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .xml file.\n";
# 	}
# 	elsif ($stk_file_name eq undef)
# 	{
# 		die "ERROR: undefine of .stk file.\n";
# 	}

# 	if (-e "$stk_file_name")
# 	{
# 		if (-e $output_folder)
# 		{
# 			system("rm $output_folder/solution*");
# 		}
# 		else
# 		{
# 			system("mkdir $output_folder");
# 		}

# 		my $die_folder = $output_folder;
# 		if ($output_folder ne undef)
# 		{
# 			$die_folder = $output_folder."/"
# 		}

# 		print "XML Generation (Die -> XML): ";
# 		my $com_xml_file_name = $die_folder.$xml_file_name;

# 		if (-e $com_xml_file_name)
# 		{
# 			system("rm $com_xml_file_name");
# 		}
# 		print "$mta_root/$die_generator_name -stack $stk_file_name -xml $com_xml_file_name $die_configuration\n";
# 		system("$mta_root/$die_generator_name -stack $stk_file_name -xml $com_xml_file_name $die_configuration");
# 	}
# 	else
# 	{
# 		die "ERROR: CANNOT OPEN $stk_file_name, no file\n";
# 	}
# }
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

# sub lcfConverter {

# 	my @argv_array = @_;
# 	my $lcf_file_name = $argv_array[0];
# 	my $xml_file_name = $argv_array[1];
# 	my $config_file_name = $argv_array[2];

# 	my @lcf_name_array = split(/\./,$lcf_file_name);

# 	my $endsign = "\n";
# 	my $spacesign = "\t";

# 	######
# 	my $xml_string = "<?xml version=\"1.0\" ?>" . $endsign;
# 	$xml_string = $xml_string . "<$lcf_name_array[0]>" . $endsign . $spacesign . "<component>" . $endsign;
# 	######

# 	my $lcf_read_count = 0;
# 	my @parameter_array;
# 	my $layer_ID = 0;

# 	open my $lcf_file,  '<', $lcf_file_name or die "cannot open file: $lcf_file_name: $!";
# 	while(<$lcf_file>)
# 	{
# 		chomp();

# 		if (($_ eq undef) || $_ =~ /^\#.*/)
# 		{
# 			$lcf_read_count = 0;
# 		}
# 		else
# 		{

# 			my @getline = split(/\s+/,$_);
# 			if ($lcf_read_count == 0)
# 			{
# 				$layer_ID = $getline[0];
# 				$parameter_array[$layer_ID][$lcf_read_count] = $layer_ID;
# 			}
# 			else
# 			{
# 				$parameter_array[$layer_ID][$lcf_read_count] = $getline[0];
# 			}

# 			$lcf_read_count = $lcf_read_count + 1;
# 			if ($lcf_read_count > 6)
# 			{
# 				$lcf_read_count = 0;
# 			}
# 		}
# 	}
# 	close $lcf_file;

# 	open my $config_file,  '<', $config_file_name or die "cannot open file: $config_file_name: $!";
# 	####
# 	my $t_chip;
# 	my $k_chip;
# 	my $p_chip;

# 	my $c_convec;
# 	my $r_convec;
# 	my $s_sink;
# 	my $t_sink;
# 	my $k_sink;
# 	my $p_sink;

# 	my $s_spreader;
# 	my $t_spreader;
# 	my $k_spreader;
# 	my $p_spreader;

# 	my $t_interface;
# 	my $k_interface;
# 	my $p_interface;

# 	my $ambient;
# 	my $init_temp;
# 	my $sampling_intvl;

# 	####
# 	while(<$config_file>)
# 	{
# 		chomp();

# 		if (($_ eq undef) || $_ =~ /^\#.*/)
# 		{
# 			#$lcf_read_count = 0;
# 		}
# 		else
# 		{
# 			my @getline = split(/\s+/,$_);
# 			if ($getline[1] eq "-t_chip")
# 			{
# 				$t_chip = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-k_chip")
# 			{
# 				$k_chip = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-p_chip")
# 			{
# 				$p_chip = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-t_sink")
# 			{
# 				$t_sink = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-k_sink")
# 			{
# 				$k_sink = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-p_sink")
# 			{
# 				$p_sink = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-s_sink")
# 			{
# 				$s_sink = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-r_convec")
# 			{
# 				$r_convec = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-t_spreader")
# 			{
# 				$t_spreader = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-k_spreader")
# 			{
# 				$k_spreader = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-p_spreader")
# 			{
# 				$p_spreader = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-s_spreader")
# 			{
# 				$s_spreader = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-t_interface")
# 			{
# 				$t_interface = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-k_interface")
# 			{
# 				$k_interface = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-p_interface")
# 			{
# 				$p_interface = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-ambient")
# 			{
# 				$ambient = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-init_temp")
# 			{
# 				$init_temp = $getline[2];
# 			}
# 			elsif ($getline[1] eq "-sampling_intvl")
# 			{
# 				$sampling_intvl = $getline[2];
# 			}
# 		}
# 	}
# 	close $config_file;

# 	my $base_xaxis = 1000000.0;
# 	my $base_yaxis = 1000000.0;
# 	my $base_xaxis_far = 0.0;
# 	my $base_yaxis_far = 0.0;
# 	my $base_zaxis = 0.0;
# 	my $base_length = 0.0;
# 	my $base_width = 0.0;
# 	my $base_height = 0.0;
# 	my $specificheat_temp_local_base = 0.0;
# 	my $thermal_conductivity_temp_local_base = 0.0;
# 	my $base_thermal_conductivity = 0.0;
# 	my $base_specificheat = 0.0;

# 	my $zaxis_local_base = 0.0;

# 	for (my $i = 0; $i < ($#parameter_array + 1); $i++)
# 	{
# 		my $thermal_resistivity_local_base = 0.0;
# 		my $specific_heat_local_base = 0.0;
# 		my $xaxis_local_base = 1000000.0;
# 		my $yaxis_local_base = 1000000.0;
# 		my $xaxis_local_base_far = 0.0;
# 		my $yaxis_local_base_far = 0.0;
# 		my $height_local_base = 0.0;

# 		my $active_sign = 0;

# 		for (my $j = 0; $j < ($#{$parameter_array[$i]} + 1); $j++)
# 		{

# 			if ($j == 2)
# 			{
# 				if ($parameter_array[$i][$j] eq "Y")
# 				{
# 					$active_sign = 1;
# 				}
# 			}
# 			if ($j == 3)
# 			{
# 				$specific_heat_local_base = $parameter_array[$i][$j];
# 			}
# 			elsif ($j == 4)
# 			{
# 				$thermal_resistivity_local_base = $parameter_array[$i][$j];
# 			}
# 			elsif ($j == 5)
# 			{
# 				$height_local_base = $parameter_array[$i][$j];
# 			}
# 			elsif ($j == 6)
# 			{
# 				my $layer_name = "layer". $i;
# 				$xml_string = $xml_string . $spacesign . $spacesign . "<$layer_name>". $endsign;
# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<component>" . $endsign;
# 				##################
# 				open my $temp_file,  '<', $parameter_array[$i][$j] or die "cannot open file: $parameter_array[$i][$j]: $!";
# 				while(<$temp_file>)
# 				{
# 					chomp();

# 					if (($_ eq undef) || $_ =~ /^\#.*/)
# 					{
# 						$lcf_read_count = 0;
# 					}
# 					else
# 					{
# 						my @getline = split(/\s+/,$_);
# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 						if ($active_sign == 0)
# 						{
# 							$xml_string = $xml_string . "<" . $layer_name . "_" . $getline[0] . ">". $endsign;
# 						}
# 						else
# 						{
# 							$xml_string = $xml_string . "<" . $getline[0] . ">". $endsign;
# 						}

# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<position>". $endsign;

# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<x>$getline[3]<\/x>". $endsign;
# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<y>$getline[4]<\/y>". $endsign;
# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<z>$zaxis_local_base<\/z>". $endsign;
# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<length>$getline[1]<\/length>". $endsign;
# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<width>$getline[2]<\/width>". $endsign;
# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<height>$height_local_base<\/height>". $endsign;

# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<\/position>". $endsign;

# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<parameter>". $endsign;

# 						my $local_thermal_conductivity = 0.0;
# 						if ($getline[6] ne undef)
# 						{
# 							$local_thermal_conductivity = 1 / $getline[6];
# 						}
# 						else
# 						{
# 							$local_thermal_conductivity = 1 / $thermal_resistivity_local_base;
# 						}
# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<ThermalConductivity>$local_thermal_conductivity<\/ThermalConductivity>". $endsign;

# 						my $local_specific_heat = 0.0;
# 						if ($getline[5] ne undef)
# 						{
# 							$local_specific_heat = $getline[5];
# 						}
# 						else
# 						{
# 							$local_specific_heat = $specific_heat_local_base;
# 						}

# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<VolumetricHeatCapacity>$local_specific_heat<\/VolumetricHeatCapacity>". $endsign;

# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign . $spacesign;
# 						$xml_string = $xml_string . "<\/parameter>". $endsign;

# 						$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 						if ($active_sign == 0)
# 						{
# 							$xml_string = $xml_string . "<\/" . $layer_name. "_" . $getline[0] . ">". $endsign;
# 						}
# 						else
# 						{
# 							$xml_string = $xml_string . "<\/" . $getline[0] . ">". $endsign;
# 						}

# 						######
# 						if ($xaxis_local_base >= $getline[3])
# 						{
# 							$xaxis_local_base = $getline[3];
# 						}
# 						if ($yaxis_local_base >= $getline[4])
# 						{
# 							$yaxis_local_base = $getline[4];
# 						}

# 						if ($xaxis_local_base_far <= ($getline[3] + $getline[1]))
# 						{
# 							$xaxis_local_base_far = $getline[3] + $getline[1];
# 						}
# 						if ($yaxis_local_base_far <= ($getline[4] + $getline[2]))
# 						{
# 							$yaxis_local_base_far = $getline[4] + $getline[2];
# 						}
# 						######
# 						if ($base_xaxis_far <= $xaxis_local_base_far)
# 						{
# 							$base_xaxis_far = $xaxis_local_base_far;
# 						}
# 						if ($base_yaxis_far <= $yaxis_local_base_far)
# 						{
# 							$base_yaxis_far = $yaxis_local_base_far;
# 						}
# 					}
# 				}
# 				close $temp_file;

# 				my $length_local_base = $xaxis_local_base_far - $xaxis_local_base;
# 				my $width_local_base = $yaxis_local_base_far - $yaxis_local_base;

# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<\/component>". $endsign;

# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<position>". $endsign;

# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<x>$xaxis_local_base<\/x>". $endsign;
# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<y>$yaxis_local_base<\/y>". $endsign;
# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<z>$zaxis_local_base<\/z>". $endsign;
# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<length>$length_local_base<\/length>". $endsign;
# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<width>$width_local_base<\/width>". $endsign;
# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<height>$height_local_base<\/height>". $endsign;

# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<\/position>". $endsign;

# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<parameter>". $endsign;

# 				my $thermal_conductivity_local_base = 1 / $thermal_resistivity_local_base;

# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<ThermalConductivity>$thermal_conductivity_local_base<\/ThermalConductivity>". $endsign;
# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<VolumetricHeatCapacity>$specific_heat_local_base<\/VolumetricHeatCapacity>". $endsign;

# 				$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 				$xml_string = $xml_string . "<\/parameter>". $endsign;

# 				$xml_string = $xml_string . $spacesign . $spacesign . "<\/$layer_name>". $endsign;
# 				$zaxis_local_base = $zaxis_local_base + $height_local_base;

# 				$base_height = $zaxis_local_base;
# 				if ($base_xaxis >= $xaxis_local_base)
# 				{
# 					$base_xaxis = $xaxis_local_base;
# 				}
# 				if ($base_yaxis >= $yaxis_local_base)
# 				{
# 					$base_yaxis = $yaxis_local_base;
# 				}
# 				$base_length = $base_xaxis_far - $base_xaxis;
# 				$base_width = $base_yaxis_far - $base_yaxis;

# 				$specificheat_temp_local_base = $specificheat_temp_local_base + $specific_heat_local_base * $height_local_base;
# 				$thermal_conductivity_temp_local_base = $thermal_conductivity_temp_local_base + $thermal_conductivity_local_base * $height_local_base;
# 			}
# 		}
# 	}

# ####Heat sink
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<HeatSink type=\"HeatSink\">". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<component><\/component>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<parameter>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<ThermalConductivity>$k_sink<\/ThermalConductivity>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<VolumetricHeatCapacity>$p_sink<\/VolumetricHeatCapacity>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/parameter>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<position>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkX = $base_xaxis + ($base_length/2) - ($s_sink/2);
# 	$xml_string = $xml_string . "<xCuboid>$tempHeatSinkX<\/xCuboid>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkY = $base_yaxis + ($base_width/2) - ($s_sink/2);
# 	$xml_string = $xml_string . "<yCuboid>$tempHeatSinkY<\/yCuboid>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkZ = $base_zaxis + $base_height + $t_spreader + $t_interface;
# 	$xml_string = $xml_string . "<zCuboid>$tempHeatSinkZ<\/zCuboid>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkLength = $s_sink;
# 	$xml_string = $xml_string . "<lengthCuboid>$tempHeatSinkLength<\/lengthCuboid>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkWidth = $s_sink;
# 	$xml_string = $xml_string . "<widthCuboid>$tempHeatSinkWidth<\/widthCuboid>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<heightCuboid>$t_sink<\/heightCuboid>". $endsign;

# 	####
# 	$width_FIN = $tempHeatSinkWidth; #default to width of heatsink
# 	####

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<lengthFin>$length_FIN<\/lengthFin>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<widthFin>$width_FIN<\/widthFin>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<heightFin>$height_FIN<\/heightFin>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkStartFinX = $tempHeatSinkX + ($length_FIN * 0.5);
# 	$xml_string = $xml_string . "<xstartFin>$tempHeatSinkStartFinX<\/xstartFin>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkStartFinY = $tempHeatSinkY + ($width_FIN * 0.5);
# 	$xml_string = $xml_string . "<ystartFin>$tempHeatSinkStartFinY<\/ystartFin>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<xnumberFin>$number_FIN_X<\/xnumberFin>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<ynumberFin>$number_FIN_Y<\/ynumberFin>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkEndFinX = $tempHeatSinkX + $tempHeatSinkLength - ($length_FIN * 0.5);
# 	$xml_string = $xml_string . "<xendFin>$tempHeatSinkEndFinX<\/xendFin>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSinkEndFinY = $tempHeatSinkY + ($width_FIN * 0.5);
# 	$xml_string = $xml_string . "<yendFin>$tempHeatSinkEndFinY<\/yendFin>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/position>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/HeatSink>". $endsign;
# ###Heat sink

# ####Heat spreader
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<HeatSpreader>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<component><\/component>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<parameter>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<ThermalConductivity>$k_spreader<\/ThermalConductivity>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<VolumetricHeatCapacity>$p_spreader<\/VolumetricHeatCapacity>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/parameter>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<position>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSpreaderX = $base_xaxis + ($base_length/2) - ($s_spreader/2);
# 	$xml_string = $xml_string . "<x>$tempHeatSpreaderX<\/x>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSpreaderY = $base_yaxis + ($base_width/2)  - ($s_spreader/2);
# 	$xml_string = $xml_string . "<y>$tempHeatSpreaderY<\/y>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSpreaderZ = $base_zaxis + $base_height + $t_interface;
# 	$xml_string = $xml_string . "<z>$tempHeatSpreaderZ<\/z>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSpreaderLength = $s_spreader;
# 	$xml_string = $xml_string . "<length>$tempHeatSpreaderLength<\/length>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempHeatSpreaderWidth = $s_spreader;
# 	$xml_string = $xml_string . "<width>$tempHeatSpreaderWidth<\/width>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<height>$t_spreader<\/height>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/position>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/HeatSpreader>". $endsign;
# ###Heat spreader

# ####TIM
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<TIM_package>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<component><\/component>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<parameter>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<ThermalConductivity>$k_interface<\/ThermalConductivity>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<VolumetricHeatCapacity>$p_interface<\/VolumetricHeatCapacity>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/parameter>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<position>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<x>$base_xaxis<\/x>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<y>$base_yaxis<\/y>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	my $tempTIMPackageZ = $base_zaxis + $base_height;
# 	$xml_string = $xml_string . "<z>$tempTIMPackageZ<\/z>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<length>$base_length<\/length>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<width>$base_width<\/width>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<height>$t_interface<\/height>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/position>". $endsign;

# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<\/TIM_package>". $endsign;
# ###TIM

# 	$xml_string = $xml_string . $spacesign . "<\/component>". $endsign;
# 	$xml_string = $xml_string . $spacesign . "<position>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<x>$base_xaxis<\/x>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<y>$base_yaxis<\/y>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<z>$base_zaxis<\/z>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<length>$base_length<\/length>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<width>$base_width<\/width>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<height>$base_height<\/height>". $endsign;
# 	$xml_string = $xml_string . $spacesign . "<\/position>". $endsign;
# 	$xml_string = $xml_string . $spacesign . "<parameter>". $endsign;

# 	$base_thermal_conductivity = $thermal_conductivity_temp_local_base / $base_height;
# 	$base_specificheat = $specificheat_temp_local_base / $base_height;

# 	my $tempHeatTransferCoefficient = 1/($r_convec*(2*$s_sink + 2* $s_spreader + $base_width)*(2*$s_sink + 2* $s_spreader + $base_length));
# 	my $temp_ambient;
# 	if ($ambient == $init_temp)
# 	{
# 		$temp_ambient = $ambient - 0.05;
# 	}
# 	else
# 	{
# 		$temp_ambient = $ambient;
# 	}

# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<ThermalConductivity>$base_thermal_conductivity<\/ThermalConductivity>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<VolumetricHeatCapacity>$base_specificheat<\/VolumetricHeatCapacity>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<HeatTransferCoefficient>$tempHeatTransferCoefficient<\/HeatTransferCoefficient>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<AmbientTemperature>$temp_ambient<\/AmbientTemperature>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<InitialTemperature>$init_temp<\/InitialTemperature>". $endsign;
# 	$xml_string = $xml_string . $spacesign . $spacesign;
# 	$xml_string = $xml_string . "<TimeStep>$sampling_intvl<\/TimeStep>". $endsign;
# 	$xml_string = $xml_string . $spacesign . "<\/parameter>". $endsign;
# 	$xml_string = $xml_string . "<\/$lcf_name_array[0]>" . $endsign;

# 	#print $xml_string;
# 	open my $xml_file,  '>', $xml_file_name or die "cannot open file: $xml_file_name: $!";
# 	print $xml_file $xml_string;
# 	close $xml_file;
# }

# sub meshCheck
# {
# 	my $enable_check = 0;
# 	my @argv_array = @_;
# 	my $temp_msh_file_name = $argv_array[0];
# 	open my $msh_file,  '<', $temp_msh_file_name or die "cannot open file: $temp_msh_file_name: $!";

# 	while(<$msh_file>)
# 	{
# 		chomp();

# 		my @getline = split(/\s+/,$_);
# 		if($getline[0] eq "\$Nodes")
# 		{
# 			$enable_check = 1;
# 		}
# 		elsif ($enable_check == 1)
# 		{
# 			my $dof_size = $getline[0];
# 			if ($dof_size >= $check_mesh)
# 			{
# 				$good_mesh = 0;
# 			}
# 			else
# 			{
# 				$good_mesh = $dof_size;
# 			}
# 			last;
# 		}
# 	}
# 	close $msh_file;
# }

sub helpManual
{
	print "required files: \n";
	print "-xml <.xml> : .xml is structure description file\n";
	print "-ptrace <.ptrace> : .ptrace is power trace file\n";
	print "============================================\n";
	print "optional running sequence: \n";
	print "-runXML : run simulation from IC(.xml) -> MESH(.msh) -> MTA\n";
	print "    -xml <.xml> is required\n";
	print "    -mesh is optional\n";
	print "-runMESH : run simualtion from MESH(.msh) -> MTA\n";
	print "    -mesh <.msh> is required\n";
	print "-runCELL : run simualtion from Package(.xml) + Die(.xml) -> IC(.xml) -> MESH(.msh) -> MTA\n";
	print "    -xml <.xml>(package) is required\n";
	print "--------------------------------------------\n";
	print "optional parameter:\n";
	print "-mesh <.msh> : .msh is computational mesh file\n";
	print "-mode <0-4> : operation mode of MTA\n";
	print "    0 Steady state analysis\n";
	print "    1 Transient analysis: Fixed time step, fixed MESH\n";
	print "    2 Transient analysis: Adaptive time step, fixed MESH\n";
	print "    3 Transient analysis: Fixed time step, adaptive MESH\n";
	print "    4 Transient analysis: Adaptive time step, adaptive MESH\n";
	print "-gmsh : visualize MESH (need to setup root path in run_flow.pl)\n";
	print "    rememeber to assign path to gmsh in runflow.pl\n";
	print "-paraview : visualize result (need to setup root path in run_flow.pl)\n";
	print "    rememeber to assign path to paraview in runflow.pl\n";
	print "-mpi <n>: running MPI with n cores\n";
	print "		 please make sure you have installed mpi on the system\n";
	print "-folder <>: output to a folder (both result and mesh)\n";
	print "-lcf <.lcf> : create .xml structure description from Hotspot 3-D\n";
	print "    -xml is required\n";
	print "    only generate .xml without running MTA\n";
	print "-stack <.stk> : create .xml(Die) structure description from DEF LEF\n";
	print "    -xml is required\n";
	print "    only generate .xml without running MTA\n";
	print "-avgpower <.avg> : load a avergae power file for cell-level homogenization\n";
	print "--------------------------------------------\n";
	die "developed by Yi-Chung Chen, Scott Ladenheim, Milan Mihajlovic, and Vasilis F. Pavlidis\nSchool of Computer Science, University of Manchester\n";
}
