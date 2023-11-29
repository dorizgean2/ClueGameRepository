module regfile (
    clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, 
    data_writeReg, data_readRegA, data_readRegB
);

    input clock, ctrl_writeEnable, ctrl_reset;
    input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    input [31:0] data_writeReg;

    output [31:0] data_readRegA, data_readRegB;

    // add your code here
    wire [31:0]  write_reg, read_regA, read_regB;

    decoder32 write_select(write_reg, ctrl_writeReg, ctrl_writeEnable);

    decoder32 read1_select(read_regA, ctrl_readRegA, 1'b1);
    decoder32 read2_select(read_regB, ctrl_readRegB, 1'b1);
 
    assign data_readRegA = read_regA[0] ? 32'b0 : 32'bz;
    assign data_readRegB = read_regB[0] ? 32'b0 : 32'bz;

    genvar i;
    generate 
	for(i = 1; i < 32; i = i + 1) begin 
	    wire [31:0] reg_output; 
	    register reg_one(clock, write_reg[i], read_regA[i], ctrl_reset, data_writeReg, reg_output); 

	    assign data_readRegA = read_regA[i] ? reg_output : 32'bz;
	    assign data_readRegB = read_regB[i] ? reg_output : 32'bz;
	end

    endgenerate

endmodule
