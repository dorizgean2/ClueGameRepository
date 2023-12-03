module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, clk, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
    input clk;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;
   
    // add your code here: 
    wire [31:0] A, B, not_data_operandB, random_number;
    wire [31:0] cla_result, not_cla_result, shift_left_data, shift_right_data, A_or_B, A_and_B;
    wire one_hot, add_or_sub, compareA_B1, compareA_B2, isZero;

    nor nor_opcode(one_hot, ctrl_ALUopcode[4:1]);
    and sub_bit(add_or_sub, one_hot, ctrl_ALUopcode[0]);

    genvar i;
    generate 
	for(i = 0; i < 32;i = i + 1) begin 
	    not not_B(not_data_operandB[i], data_operandB[i]);
	end

    endgenerate

    assign A = data_operandA;

    mux_2 add_or_subB(B, add_or_sub, data_operandB, not_data_operandB); 

    // CLA_module 
    cla carry_look_ahead(A, B, add_or_sub, A_or_B, A_and_B, cla_result, overflow);  

    // RNG module
    rng rand(clk, 1'b0, random_number); 

    //check if A = B
    or is_equal_to_zero(isNotEqual, cla_result[0], cla_result[1], cla_result[2], cla_result[3], cla_result[4],
	cla_result[5], cla_result[6], cla_result[7], cla_result[8], cla_result[9], cla_result[10], cla_result[11],
	cla_result[12], cla_result[13], cla_result[14], cla_result[15], cla_result[16], cla_result[17], cla_result[18],
	cla_result[19], cla_result[20], cla_result[21], cla_result[22], cla_result[23], cla_result[24], cla_result[25],
	cla_result[26], cla_result[27], cla_result[28], cla_result[29], cla_result[30], cla_result[31]);    

    // Check if A < B
    wire [1:0] select_less;

    assign select_less = {data_operandB[31], A[31]};
    mux_4 #(1) less_than_mux(isLessThan, select_less, cla_result[31], 1'b1, 1'b0, cla_result[31]); 

    // Shift Left Logical Module
    sll_32 shift_left(shift_left_data, ctrl_shiftamt, data_operandA);

    // Shift Right Arithmetic Module
    sra_32 shift_right(shift_right_data, ctrl_shiftamt, data_operandA);

    mux_32 control_logic(data_result, ctrl_ALUopcode, 
			    cla_result, 	// add
			    cla_result, 	// sub
			    A_and_B,	 	// and
			    A_or_B, 		// or
			    shift_left_data,	// sll
			    shift_right_data,	// sra
			    0,
			    0,
			    random_number,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0,
			    0);

endmodule
