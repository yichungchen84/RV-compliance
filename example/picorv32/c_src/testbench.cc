#include "Vtop.h"
#include "verilated.h"
#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
#include <fstream>

// #include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env)
{
	std::string output_file = "";
	Verilated::commandArgs(argc, argv);
	for (int i=0; i<argc; i++)
	{
		if (argv[i]== std::string("-o"))
		{
			i++;
			output_file = argv[i];
		}
	}

	std::stringstream tempOutput;

	Vtop* top = new Vtop;

	top->clk = 0;
	int t = 0;
	top->resetn = 0;
	while (!Verilated::gotFinish()) {
		if (t > 200)
			top->resetn = 1;
		top->clk = !top->clk;
		top->eval();
		if (top->clk) // only clk == 1 count 
		{
			if (top->top__DOT__mem_valid && top->top__DOT__mem_ready)
			{
			if (top->top__DOT__mem_wstrb)
				{
					//std::cout << std::setfill('0') << std::setw(8) << std::hex << top->top__DOT__mem_addr<<" ";
					tempOutput << std::setfill('0') << std::setw(8) << std::hex << top->top__DOT__mem_wdata<<std::endl;
				}
			}
		}

		t += 1;
	}
	// tfp->close();
	delete top;

	if(!output_file.empty())
	{
		std::ofstream tempOutputFile;
		tempOutputFile.open(output_file.c_str());
		tempOutputFile << tempOutput.str();
		tempOutputFile.close();
	}
	else
	{
		std::cout << tempOutput.str();
	}

	exit(0);
}

