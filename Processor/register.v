module register #(parameter WIDTH = 32) (clock, input_enable, output_enable, reset, in, out);
    input [WIDTH-1:0] in;
    input clock, input_enable, output_enable, reset;

    output [WIDTH-1:0] out;

    wire [WIDTH-1:0] in;
    wire [WIDTH-1:0] out;
    wire reset, clrn, input_enable, output_enable, clock, w1;

    genvar i;

    generate 
	for(i = 0; i < WIDTH; i = i + 1) begin 
	    dffe_ref a_dff(.q(out[i]), .d(in[i]), .clk(clock), .en(input_enable), .clr(reset));   
	end

    endgenerate

endmodule
