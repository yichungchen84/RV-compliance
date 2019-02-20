// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

`timescale 1 ns / 1 ps

module top #(
	parameter AXI_TEST = 0,
	parameter VERBOSE = 0
) (
	input clk,
	input resetn
);
	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire trap;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg  [31:0] mem_rdata;

	picorv32 #(
	) uut (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.trap        (trap       ),
		.mem_valid   (mem_valid  ),
		.mem_instr   (mem_instr  ),
		.mem_ready   (mem_ready  ),
		.mem_addr    (mem_addr   ),
		.mem_wdata   (mem_wdata  ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_rdata   (mem_rdata  )
	);

	reg [31:0] memory [0:(64*1024*1024)/4-1];

	reg [1023:0] memdata_file;

	initial begin
		if (!$value$plusargs("memdata_file=%s", memdata_file))
			memdata_file = "foo.hex";
		$readmemh(memdata_file, memory);
		$display("====== data: loaded ======");
	end

	always @(posedge clk) begin
		mem_ready <= 0;
		if (mem_valid && !mem_ready) begin
			// if (mem_addr < (1*1024/4) ) begin
				mem_ready <= 1;
				mem_rdata <= memory[mem_addr >> 2];
				if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
				if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
				if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
				if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
			// end
			/* add memory-mapped IO here */
		end
	end


	always @(posedge clk) begin
		if (trap == 1'b1) begin
			$finish;
		end
	end


	// always @(posedge clk) begin
	// 	if (mem_valid && mem_ready) begin
	// 		if (mem_instr)
	// 			$display("ifetch 0x%h: 0x%h", mem_addr, mem_rdata);
	// 		else if (mem_wstrb)
	// 			$display("write  0x%08x: 0x%08x (wstrb=%b)", mem_addr, mem_wdata, mem_wstrb);
	// 		else
	// 			$display("read   0x%08x: 0x%08x", mem_addr, mem_rdata);
	// 	end
	// end

	always @(posedge clk) begin
		if (mem_valid && mem_ready) begin
			if (mem_instr) begin
				if ((mem_addr >>2) > 32'h0000B204 ) begin
					$finish;
				end
			end
		end
	end

endmodule