module counter_32(clock, enable, reset, count);
    input clock, enable, reset;
    output [5:0] count; 
   
    wire [5:0] q, w, t;
    wire clock, enable, reset; 

    assign t[0] = enable;

    and AND_t0_Q0(t[1], t[0], q[0]); 
    and AND_t1_Q1(t[2], t[1], q[1]); 
    and AND_t2_Q2(t[3], t[2], q[2]); 
    and AND_t3_Q3(t[4], t[3], q[3]); 
    and AND_t4_Q4(t[5], t[4], q[4]); 

    genvar i;

    generate 
	for(i = 0; i < 6; i = i + 1) begin 
	    tff a_tff(.T(t[i]), .clk(clock), .en(enable), .r(reset), .Q(q[i]));   
	end

    endgenerate

    assign count = q;

endmodule
