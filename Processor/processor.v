/*
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
	output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	wire[63:0] readAB, dataAB, readOB, dataOB, readOD, dataOD, dataM; 
	wire[31:0] fetch, decode, execute, memory, write, alu_out, branch_target, multdiv_out, multdiv_data;
	wire[31:0] dataA, exe_dataB, exe_dataO, mem_dataB, mem_dataO, wrt_dataO, dataD, sign_extension, ra, curr_status;
	wire[31:0] target, immediate, product_in, product_write, multiplicand, multiplier, j1_branch, j1_or_j2;
	wire[31:0] exe_dataD, r_status, data_toWrite, post_fetch, post_decode, dataB, data_opA, data_opB, data_in;
	wire[31:0] bypassA, bypassB, multop_A, multop_B, bypass_mem;
	wire[15:0] new_pc, pc, pc1, pc2, plus_one, pc_plus_one;

	wire[4:0] opcode, rd, rs, rt, shift_amt, ALUop, dec_op, dec_alu, mem_op, mem_alu, wrt_op, wrt_alu; 
	wire[4:0] fetch_op, ovf_or_jal; 
	wire ie, oe, branch, overflow, custom_instruct, jump_instruct, isNotEqual, isLessThan, ctrl_writeVal, bypass_wmD;
	wire ctrl_MULT, ctrl_DIV, multdiv_rdy, exception, mult_op, mult_or_div, mult_instruct, div_instruct, overwrite; 
	wire start_multdiv, unstall, stall_logic, stall, started, fetch_multdiv, dec_MULT, dec_DIV, ie_stall, oe_stall;
	wire wrt_MULT, wrt_DIV, mem_MULT, mem_DIV, choose_data, j, jr, j1, j2, jal, wrt_jal, wrt_jr, bne, blt, fetch_sw;	
	wire wrt_bne, wrt_blt, wrt_addi, wrt_r_type, not_write, addi, r_type, sw, lw, wrt_sw, wrt_lw, should_extend;
	wire mem_sw, mem_lw, alu_exc, mem_exc, add_ovf, addi_ovf, sub_ovf, mult_ovf, div_ovf, any_exc, exe_md;
	wire wrt_setx, wrt_bex, write_toR, setx, bex, bex_true, ex, nop, bypass_mxA, bypass_mxB, bypass_wxA, bypass_wxB;
	wire hazard_stall, mxA_cond1, wxA_cond1, wxA_cond2, mxB_cond1, mxB_cond2, wxB_cond1, wxB_cond2, wxB_cond3;
	wire mxA_cond2, mxB_cond3, bypass_excA, bypass_excB, curr_add_ovf, curr_addi_ovf, curr_sub_ovf, curr_div_ovf;
	wire curr_mult_ovf, curr_setx, mem_addi, mxA_cs, wxA_cs, mxB_cs, wxB_cs, blt_true, bne_true, mxB_cond4, wxB_cond4;
	wire mult_logic, mem_blt, mxB_nb, mxA_cond3, wxA_cond3, wxA_cond4, mxB_cond5, wxB_cond5, wxB_cond6, rdy_md;
	wire wxA_notzero, mxA_notzero, mxB1_notzero, mxB2_notzero, wxB1_notzero, wxB2_notzero, mxA_cond4, mult_stall;
	wire mult_exc, dec_jr, h_stall1, h_stall2, h_stall3;
	
	assign ie = 1'b1;
	assign oe = 1'b1;


	// fetch stage
    
	assign plus_one = {15'b0, 1'b1};
	assign j1_or_j2 = j2 ? ra : branch_target;
	assign new_pc = branch ? j1_or_j2 : pc_plus_one; 

	assign address_imem = pc;
	assign fetch = q_imem;
	assign post_fetch = branch ? nop : fetch;

	cla_16 add_one_pc(.A(pc), .B(plus_one), .C0(1'b0), .S(pc_plus_one)); 

	neg_register #(16) pcr(.clock(clock), .input_enable(~stall_logic), .reset(reset), .in(new_pc), .out(pc));	
	neg_register fd(.clock(clock), .input_enable(~stall_logic), .reset(reset), .in(post_fetch), .out(decode));
	neg_register #(16) pcf(.clock(clock), .input_enable(~stall_logic), .reset(reset), .in(pc_plus_one), .out(pc1));
	

	// decode stage	
	assign mult_logic = |{lw, mem_lw} ? 1'b0 : multdiv_rdy ? 1'b0 : |({dec_MULT, dec_DIV, stall});
	assign stall_logic = |{lw, mem_lw} ? hazard_stall : mult_logic; 

	neg_register #(1) mst(.clock(clock), .input_enable(ie), .reset(reset), .in(mult_logic), .out(mult_stall));
	neg_register #(1) st(.clock(clock), .input_enable(ie), .reset(reset), .in(stall_logic), .out(stall));
	    
	assign fetch_op = decode[31:27];
	assign post_decode = |{branch, hazard_stall} ? nop : decode;

	assign r_type = &({~{fetch_op[4:0]}});
	assign ex = &({~{fetch_op[3], fetch_op[0]}, fetch_op[4], fetch_op[2:1]});

	assign rs = decode[21:17];	
	assign rt = r_type ?   decode[16:12] : 
		    ex 	   ?   32'd30	     : 
		    decode[26:22];	 

	assign ctrl_readRegA = rs;
	assign ctrl_readRegB = rt;

	assign readAB = {data_readRegA, data_readRegB};
	assign dec_jr = {~{decode[4:3], decode[2], decode[1:0]}};

	neg_register dx(.clock(clock), .input_enable(~mult_logic), .reset(reset), .in(post_decode), .out(execute));
	neg_register #(64) ab(.clock(clock), .input_enable(~mult_logic), .reset(reset), .in(readAB), .out(dataAB));
	neg_register #(16) pcd(.clock(clock), .input_enable(~mult_logic), .reset(reset), .in(pc1), .out(pc2));
    

	// execute stage	

	assign opcode = stall ? 5'b0 : execute[31:27];	
	assign shift_amt = execute[11:7];	
	assign ALUop = |{stall, addi, setx, bex} ? 5'b0 : |{blt, bne} ? 5'b00001 : execute[6:2];	
	assign nop = 32'b0;

	assign j = &({~{opcode[4:1]}, opcode[0]}); 
	assign jal = &({~{opcode[4:2]}, opcode[1:0]});	    

	assign j1 = |({j, jal, bex_true});
	assign jr = &({~{opcode[4:3], opcode[1:0]}, opcode[2]});
	assign j2 = jr;

	assign bne = &({~{opcode[4:2], opcode[0]}, opcode[1]});
	assign blt = &({~{opcode[4:3], opcode[0]}, opcode[2:1]});

	assign bex = &({~{opcode[3], opcode[0]}, opcode[4], opcode[2:1]});
	assign setx = &({~{opcode[3], opcode[1]}, opcode[4], opcode[2], opcode[0]});

	assign bne_true = &({isNotEqual, bne});
	assign blt_true = &({blt, isLessThan});
	assign bex_true = &({bex, isNotEqual});

	assign addi = &({~{opcode[4:3], opcode[1]}, opcode[2], opcode[0]});
	assign sw = &({~{opcode[4:3]}, opcode[2:0]});
	assign lw = &({~{opcode[4], opcode[2:0]}, opcode[3]});

	assign branch = |{j1, j2, bne_true, blt_true};

	assign sign_extension = j1 ? target : immediate; 
	assign should_extend = branch ? 1'b0 :|({addi, sw, lw, setx});

	assign dataA = dataAB[63:32];	
	assign dataB = dataAB[31:0];	

	assign readOB = jal ? {16'b0, pc2, 32'b0} : {alu_out, exe_dataB};
	assign j1_branch = j1 ? 32'b0 : {16'b0, pc2};
	assign ra = data_opB;

	assign dec_op = execute[31:27];
	assign dec_alu = execute[6:2];
 
	assign dec_MULT = &({~{dec_op[4:0], dec_alu[4:3], dec_alu[0]}, dec_alu[2:1]});
	assign dec_DIV = &({~{dec_op[4:0], dec_alu[4:3]}, dec_alu[2:0]});

	assign ie_stall = |{multdiv_rdy, ~stall};
	assign oe_stall = |{mult_op, ~stall};
    
	assign ctrl_MULT = &({~{opcode[4:0], ALUop[4:3], ALUop[0]}, ALUop[2:1]});
	assign ctrl_DIV = &({~{opcode[4:0], ALUop[4:3]}, ALUop[2:0]});

	assign exe_md = |{dec_MULT, dec_DIV}; 

	assign multop_A = mxA_cond3 ? mem_dataO : wxA_cond3 ? data_toWrite : dataA;
	assign multop_B = mxB_cond5 ? mem_dataO : wxB_cond5 ? data_toWrite : dataB;

	assign multiplicand = exe_md ? multop_A : 1'b1;
	assign multiplier = exe_md ? multop_B : 1'b1;
	
	assign mxA_cs = &{sw, ~mem_sw};
	assign wxA_cs = &{sw, ~wrt_sw};

	assign mxA_notzero = &{execute[21:17] != 5'b0, memory[26:22] != 5'b0};
	assign wxA_notzero = &{execute[21:17] != 5'b0, write[26:22] != 5'b0};

	assign mxA_cond1 = &{execute[21:17] == memory[26:22], mxA_notzero, ~sw};
	assign wxA_cond1 = &{execute[21:17] == write[26:22], wxA_notzero, ~sw};

	assign mxA_cond2 = &{execute[21:17] == memory[26:22], mxA_notzero, mxA_cs};
	assign wxA_cond2 = &{execute[21:17] == write[26:22], wxA_notzero, wxA_cs};

	assign mxA_cond3 = &{execute[21:17] == memory[26:22], mxA_notzero, exe_md};
	assign wxA_cond3 = &{execute[21:17] == write[26:22], wxA_notzero, exe_md};
	
	assign mxA_cond4 = &{execute[21:17] == memory[26:22], mxA_notzero, exe_md};
	assign wxA_cond4 = &{execute[21:17] == write[26:22], wxA_notzero, exe_md};

	assign bypass_mxA = |{mxA_cond1, mxA_cond2};
	assign bypass_wxA = |{wxA_cond1, wxA_cond2};
	
	assign mxB_cs = &{sw, ~mem_sw};
	assign wxB_cs = &{sw, ~wrt_sw};

	assign mxB_nb = &{~sw, ~mem_blt};

	assign mxB1_notzero = &{execute[16:12] != 5'b0, memory[26:22] != 5'b0};
	assign wxB1_notzero = &{execute[16:12] != 5'b0, write[26:22] != 5'b0};
	assign mxB2_notzero = &{execute[26:22] != 5'b0, memory[26:22] != 5'b0};
	assign wxB2_notzero = &{execute[26:22] != 5'b0, write[26:22] != 5'b0};

	assign mxB_cond1 = &{execute[16:12] == memory[26:22], mxB1_notzero, mxB_nb};
	assign wxB_cond1 = &{execute[16:12] == write[26:22], wxB1_notzero, ~sw};

	assign mxB_cond2 = &{execute[16:12] == memory[26:22], mxB1_notzero, mxB_cs};
	assign wxB_cond2 = &{execute[16:12] == write[26:22], wxB1_notzero, wxB_cs};

	assign mxB_cond3 = &{execute[26:22] == memory[26:22], mxB2_notzero, jr};
	assign wxB_cond3 = &{execute[26:22] == write[26:22], wxB2_notzero, jr};

	assign mxB_cond4 = &{execute[26:22] == memory[26:22], mxB2_notzero, blt || bne};
	assign wxB_cond4 = &{execute[26:22] == write[26:22], wxB2_notzero, blt || bne};

	assign mxB_cond5 = &{execute[16:12] == memory[26:22], mxB1_notzero, exe_md};
	assign wxB_cond5 = &{execute[16:12] == write[26:22], wxB1_notzero, exe_md};

	assign bypass_mxB = |{mxB_cond1, mxB_cond2, mxB_cond3, mxB_cond4};
	assign bypass_wxB = |{wxB_cond1, wxB_cond2, wxB_cond3, wxB_cond4};

	assign bypass_excA = &{alu_exc, execute[21:17] == 32'd30};
	assign bypass_excB = &{alu_exc, execute[16:12] == 32'd30};

	assign bypass_mem = {mem_MULT || mem_DIV} ? multdiv_data : mem_dataO;

	assign exe_dataB = bypass_excB ? curr_status : bypass_mxB ? bypass_mem : bypass_wxB ? data_writeReg : dataB;
	assign bypassA = bypass_excA ? curr_status : bypass_mxA ? bypass_mem : bypass_wxA ? data_writeReg : dataA;

	assign bypassB = should_extend ? sign_extension : exe_dataB;

	assign data_opA =  blt ? bypassB : bypassA; 
	assign data_opB =  blt ? bypassA : bypassB; 	

	assign fetch_sw = &({~{fetch_op[4:3]}, fetch_op[2:0]}); 
	assign h_stall1 = &{decode[26:22] == execute [26:22], dec_jr};
	assign h_stall2 = decode[21:17] == execute[26:22];
	assign h_stall3 = {decode[16:12] == execute[26:22] && ~fetch_sw};
	assign hazard_stall = &{lw, {h_stall1 || h_stall2 || h_stall3}};     
	assign curr_status = curr_add_ovf  	? 	 32'd1 : 
			  curr_addi_ovf 	?  	 32'd2 :
			  curr_sub_ovf  	? 	 32'd3 :
			  curr_mult_ovf 	? 	 32'd4 :
			  curr_div_ovf 	 	?	 32'd5 : 
			  curr_setx 	 	?    mem_dataO :
			  31'd0;

	assign curr_add_ovf = &({~{mem_op[4:0], mem_alu[4:0]}, alu_exc});	
	assign curr_addi_ovf = &({mem_addi, alu_exc});		
	assign curr_sub_ovf = &({~{mem_alu[4:1]}, mem_alu[0], alu_exc});
	assign curr_div_ovf = &({mem_DIV, exception});
	assign curr_setx = &({~{mem_op[3], mem_op[1]}, mem_op[4], mem_op[2], mem_op[0]}); 

	assign mem_addi = &({~{mem_op[4:3], mem_op[1]}, mem_op[2], mem_op[0]});
	assign mem_blt = &({~{mem_op[4:3], mem_op[0]}, mem_op[2:1]});

	sx_32 sign_extend(target, immediate, execute);

	alu alu_main(data_opA, data_opB, ALUop, shift_amt, alu_out, isNotEqual, isLessThan, overflow);
	cla branch_cla(.A(j1_branch), .B(sign_extension), .C0(1'b0), .P(), .G(), .S(branch_target), .overflow());
	multdiv mult_div(multiplicand, multiplier, ctrl_MULT, ctrl_DIV, clock, multdiv_out, exception, multdiv_rdy);	
	
	neg_register pw(.clock(clock), .input_enable(multdiv_rdy), .reset(reset), .in(product_in), .out(product_write));
	neg_register p(.clock(clock), .input_enable(multdiv_rdy), .reset(reset), .in(multdiv_out), .out(multdiv_data));

	neg_register mx(.clock(clock), .input_enable(~mult_stall), .reset(reset), .in(execute), .out(memory));
	neg_register #(64) ob(.clock(clock), .input_enable(~mult_stall), .reset(reset), .in(readOB), .out(dataOB));
	
	neg_register #(1) exe_ovf(.clock(clock), .input_enable(~mult_stall), .reset(reset), .in(overflow), .out(alu_exc));
	neg_register #(1) md(.clock(clock), .input_enable(ie), .reset(reset), .in(multdiv_rdy), .out(mult_op));
	neg_register #(1) mul_ovf(.clock(clock), .input_enable(multdiv_rdy), .reset(reset), .in(exception), .out(mult_exc));

	// memory stage
	assign mem_dataO = dataOB[63:32];
	assign mem_dataB = dataOB[31:0];

	assign address_dmem = mem_dataO;  

	assign bypass_wmD = &{memory[26:22] == write[26:22], memory[26:22] != 5'b0, write[26:22] != 5'b0};

	assign data_in = bypass_wmD ? data_writeReg : mem_dataB; 
	assign data = data_in;  

	assign mem_op = memory[31:27];
	assign mem_alu = memory[6:2];
 
	assign mem_MULT = &({~{mem_op[4:0], mem_alu[4:3], mem_alu[0]}, mem_alu[2:1]});
	assign mem_DIV = &({~{mem_op[4:0], mem_alu[4:3]}, mem_alu[2:0]});

    	assign mem_sw = &({~{mem_op[4:3]}, mem_op[2:0]});
	assign mem_lw = &({~{mem_op[4], mem_op[2:0]}, mem_op[3]});

	assign product_in = execute;
	assign mult_or_div = &({mult_op, |{mem_MULT, mem_DIV}});

	assign wren = mem_sw; 

	assign readOD = {mem_dataO, q_dmem};

	assign unstall = {~mult_stall || mult_op};
	
	neg_register mw(.clock(clock), .input_enable(unstall), .reset(reset), .in(memory), .out(write));

	neg_register #(64) od(.clock(clock), .input_enable(unstall), .reset(reset), .in(readOD), .out(dataOD));
	neg_register #(1) mem_ovf(.clock(clock), .input_enable(unstall), .reset(reset), .in(alu_exc), .out(mem_exc));

	// writeback stage		
	assign ctrl_writeEnable = not_write; 

	assign wrt_addi = &({~{wrt_op[4:3], wrt_op[1]}, wrt_op[2], wrt_op[0]});
	assign wrt_r_type = &({~wrt_op[4:0]});

	assign wrt_sw = &({~{wrt_op[4:3]}, wrt_op[2:0]});
	assign wrt_lw = &({~{wrt_op[4], wrt_op[2:0]}, wrt_op[3]});
	assign wrt_setx = &({~{wrt_op[3], wrt_op[1]}, wrt_op[4], wrt_op[2], wrt_op[0]});
	assign wrt_bex = &({~{wrt_op[3], wrt_op[0]}, wrt_op[4], wrt_op[2:1]});

	assign not_write = |({wrt_addi, wrt_r_type, wrt_jal, wrt_lw, wrt_setx}); 

	assign any_exc = |({add_ovf, addi_ovf, sub_ovf, mult_ovf, div_ovf});
	assign write_toR = |({any_exc, wrt_setx});
	assign ovf_or_jal = mult_op ? 5'd0 : write_toR ? 5'd30 : 5'd31;
	assign overwrite = |({wrt_jal, wrt_setx, any_exc, mult_or_div});

	assign rd = overwrite ? ovf_or_jal : write[26:22];	
 
	assign wrt_op = write[31:27];
	assign wrt_alu = write[6:2];

	assign wrt_jal = &({~{wrt_op[4:2]}, wrt_op[1:0]});	
	assign wrt_jr = &({~{wrt_op[4:3], wrt_op[1:0]}, wrt_op[2]});

	assign add_ovf = &({~{wrt_op[4:0], wrt_alu[4:0]}, mem_exc});
	assign addi_ovf = &({wrt_addi, mem_exc});	
	assign sub_ovf = &({~{wrt_alu[4:1]}, wrt_alu[0], mem_exc});
	assign mult_ovf = &({wrt_MULT, mult_exc});
	assign div_ovf = &({wrt_DIV, mult_exc});

	assign r_status = add_ovf  	? 	 32'd1 : 
		          addi_ovf 	?  	 32'd2 :
			  sub_ovf  	? 	 32'd3 :
			  mult_ovf 	? 	 32'd4 :
			  div_ovf 	?	 32'd5 : 
			  wrt_setx 	?    exe_dataO :
			  31'd0;

	assign wrt_MULT = &({~{wrt_op[4:0], wrt_alu[4:3], wrt_alu[0]}, wrt_alu[2:1]});
	assign wrt_DIV = &({~{wrt_op[4:0], wrt_alu[4:3]}, wrt_alu[2:0]});

	assign exe_dataO = dataOD[63:32];
	assign exe_dataD = dataOD[31:0];	
	
	assign choose_data = |{wrt_MULT, wrt_DIV}; 
	assign ctrl_writeReg = rd;
	assign ctrl_writeVal = |({wrt_sw, wrt_lw});

	assign dataM = ctrl_writeVal? exe_dataD : exe_dataO;
	assign data_toWrite = choose_data ? multdiv_data: dataM;
	assign data_writeReg = write_toR ? r_status : data_toWrite; 
	
	/* END CODE */

endmodule
