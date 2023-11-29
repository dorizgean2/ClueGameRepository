module sx_32(target, immediate, in);
    input [31:0] in;

    output [31:0] immediate, target;

    wire [31:0] sx_target, sx_immediate;
    
    genvar i;

    generate
	for (i = 31; i > 26; i = i - 1) begin
	    assign sx_target[i] = in[26];	
	end

	for (i = 31; i > 16; i = i - 1) begin
	   assign sx_immediate[i] = in[16]; 
	end
    endgenerate

    assign sx_target[26:0] = in[26:0];
    assign sx_immediate[16:0] = in[16:0];

    assign target = sx_target; 
    assign immediate = sx_immediate; 
endmodule
