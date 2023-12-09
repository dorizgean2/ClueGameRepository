`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (
    input clk, 			// 100 MHz System Clock
    input reset, 		// Reset Signal
    input BTND, 
    input BTNU, 
    input BTNL, 
    input BTNR,
    input [4:0] SW,
    input [4:0] LED,
    output hSync, 		// H Sync Signal
    output vSync, 		// Veritcal Sync Signal
    output[3:0] VGA_R,  // Red Signal Bits
    output[3:0] VGA_G,  // Green Signal Bits
    output[3:0] VGA_B,  // Blue Signal Bits
    inout ps2_clk,
    inout ps2_data);
	
    wire clock; // 25MHz clock

	// Clock divider 100 MHz -> 25 MHz
	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clock = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end
	
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
	
	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "dice_roll_testing";
	
	wire need_BTND, need_BTNL, need_BTNU, need_BTNR, need_output;
	wire BTND_out, BTNU_out, BTNL_out, BTNR_out, BTN_out;
	wire [31:0] processor_out, from_VGA;
	
	reg [31:0] to_VGA = 0, data_in = 0, to_processor = 0;
	 
	assign need_BTNL =  &({memAddr == 32'd3000, mwe == 1'b0});
	assign need_BTNR =  &({memAddr == 32'd4000, mwe == 1'b0});
	assign need_BTNU =  &({memAddr == 32'd5000, mwe == 1'b0});
	assign need_BTND =  &({memAddr == 32'd6000, mwe == 1'b0});

	assign need_output = &({memAddr == 32'd2000, mwe == 1'b1});
	
	debounce_better_version debouncey1(.pb_1(BTND), .clk(clock), .pb_out(BTND_out));
	debounce_better_version debouncey2(.pb_1(BTNU), .clk(clock), .pb_out(BTNU_out));
	debounce_better_version debouncey3(.pb_1(BTNL), .clk(clock), .pb_out(BTNL_out));
	debounce_better_version debouncey4(.pb_1(BTNR), .clk(clock), .pb_out(BTNR_out));
	
	assign processor_out = need_output ? memDataIn : 32'b0;

	// Main VGA Control
	VGAController VGA(.clk(clock), .reset(reset), 
	
	    // FPGA Control
	    .BTND_in(BTND_out), .BTNU_in(BTNU_out), .BTNL_in(BTNL_out), .BTNR_in(BTNR_out), 
	    .LED(LED), .SW(SW), 
	   
	    // VGA Control
	    .hSync(hSync), .vSync(vSync),
	    .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
	    
	    // PS2 Controller
	    .ps2_clk(ps2_clk), .ps2_data(ps2_data),
	    
	    .from_processor(to_VGA), .to_processor(from_VGA));
	 
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
						
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(data_in)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));
		
	always @(posedge clock) begin
	   to_VGA = processor_out;
	   to_processor = from_VGA;
	   
	   if (need_BTND == 1'b1) 
	       data_in = BTND;
	   else if (need_BTNL == 1'b1) 
	       data_in = BTNL;
	   else if (need_BTNR == 1'b1) 
	       data_in = BTNR;
	   else if (need_BTNU == 1'b1) 
	       data_in = BTNU;
	   else 
	       data_in = memDataOut;
	end

endmodule
