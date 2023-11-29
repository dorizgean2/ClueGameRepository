module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here
    wire [63:0]  merge_first_cycle; 
    wire [31:0] not_data_operandA, not_data_operandB, cla_output1, cla_output2;
    wire [5:0] counter_out;
    wire ie, oe, reset, mult_or_div, add_or_sub, sub_or_add, operation, first_cycle, cleanup;
    wire overflow1, overflow2, check1, check2, divide_by_zero, e1, e2, e3, e4, e5, e6, ovf_ext;
 
    assign ie = 1'b1;
    assign oe = 1'b1; 
    
    assign not_data_operandA =  ~(data_operandA);
    assign not_data_operandB = ~(data_operandB);


    assign merge_first_cycle = first_cycle ? {32'b0, abs_A} : {32'b0, data_operandB}; 

    // multiplication module
    wire [63:0] product, new_product, unshifted_product, shifted_product, merge_cla_multiplier;
    wire [31:0] multiplicand; 
    wire implicit_zero, booth_bit, new_booth_bit, do_nothing_bit, mult_exception;
   
    assign multiplicand = add_or_sub ? not_data_operandA : data_operandA;  

    assign merge_cla_multiplier = ctrl_MULT ? merge_first_cycle : {cla_output1, product[31:0]}; 

    assign unshifted_product = do_nothing_bit ? product : merge_cla_multiplier;
    assign new_product = ctrl_MULT ? merge_first_cycle : shifted_product;

    register #(64) product_reg(clock, ie, oe, 1'b0, new_product, product); 
    register #(1) booth_reg(clock, ie, oe, 1'b0, new_booth_bit, booth_bit); 

    sra_64 shift_right(.out(shifted_product), .in(unshifted_product));

    cla carry_look_multiplication(.A(multiplicand), .B(product[63:32]), .C0(add_or_sub), .P(), .G(), 
				    .S(cla_output1), .overflow(overflow1));  
 
    // division module
    wire [63:0] quotient, new_quotient, unshifted_quotient, shifted_quotient, div_result, final_result, merge_cla_quotient;
    wire [31:0] divisor, abs_A, abs_B, final_quotient, final_remainder; 
    wire negate_result, new_sub, sub, msb, div_exception, all_zerosA, all_zerosB;
    
    assign divisor = sub_or_add ? ~(abs_B) : abs_B; 
    assign msb = ctrl_DIV ? merge_first_cycle[63] : quotient[63];
    assign merge_cla_quotient = {cla_output2, quotient[31:1], ~shifted_quotient[63]};
    
    assign unshifted_quotient = first_cycle ? merge_first_cycle : merge_cla_quotient;     
    assign new_quotient = shifted_quotient;

    assign div_result = merge_cla_quotient;
    assign final_quotient = negate_result ? ~div_result[31:0] + 1'b1: div_result[31:0];
    assign final_remainder = data_operandA[31] ? ~div_result[63:32] + 1'b1 : div_result[63:32];
    assign final_result =  divide_by_zero ? 63'b0 : {final_remainder, final_quotient};  

    register #(64) quotient_reg(clock, ie, oe, 1'b0, new_quotient, quotient); 

    sll_64 shift_left(.out(shifted_quotient), .in(unshifted_quotient));

    cla carry_look_division(.A(divisor), .B(quotient[63:32]), .C0(sub_or_add), .P(), .G(), 
				.S(cla_output2), .overflow(overflow2));  
 
    // control    
    assign implicit_zero = 1'b0;
    assign new_booth_bit = ctrl_MULT ? implicit_zero : product[0]; 
 
    assign abs_A = data_operandA[31] ? not_data_operandA + 1'b1 : data_operandA; 
    assign abs_B = data_operandB[31] ? not_data_operandB + 1'b1 : data_operandB; 

    assign data_result = mult_or_div ? product[31:0] : final_result[31:0]; 
    assign data_resultRDY = counter_out[5];
    assign operation = reset ? ctrl_MULT : mult_or_div; 
    assign first_cycle = operation ? 1'b0 : &(~{counter_out[5:0]}); 

    counter_32 counter(.clock(clock), .enable(ie), .reset(reset), .count(counter_out));

    register #(1) multdiv_reg(clock, ie, oe, 1'b0, operation, mult_or_div); 
    register #(1) fix(clock, ie, oe, 1'b0, data_resultRDY, cleanup); 
    
    or reset_mult_div(reset, ctrl_MULT, ctrl_DIV, cleanup);  

    xor check_negatives(negate_result, data_operandA[31], data_operandB[31]); 
    not negate_sub(sub_or_add, msb);

    not negate_booth_bit(add_or_sub, booth_bit);  
    xnor XNOR_product_booth(do_nothing_bit, product[0], booth_bit); 

    // error-check module
    assign e3 = &{product[63:32]};
    assign e4 = ~(|{product[63:32]});
    assign ovf_ext = ~e3 & ~e4;

    assign divide_by_zero = ~(|{data_operandB[31:0]});

    and except1(e1, data_operandA[31], data_operandB[31], data_result[31]);
    and except2(e2, not_data_operandA[31], not_data_operandB[31], data_result[31]);    

    or mult_error(mult_exception, e1, e2, ovf_ext);
    or div_error(div_exception, divide_by_zero);

    and check_mult(check1, mult_exception, mult_or_div);
    and check_div(check2, div_exception, ~mult_or_div);
    
    or check_error(data_exception, check1, check2);
endmodule
