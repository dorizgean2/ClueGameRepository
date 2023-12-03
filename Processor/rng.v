module rng #(parameter WIDTH = 32) (clk, reset, rand);
    input clk, reset;
    output [WIDTH-1:0] rand;

    wire [WIDTH-1:0] Q;
    wire f; 

    xnor one_XNOR(f, Q[WIDTH-1], Q[0]); 	

    dffe_ref first_dff(.q(Q[0]), .d(f), .clk(clk), .en(1'b1), .clr(reset));    

    genvar i, j;
    generate
	for(i = 1; i < WIDTH; i = i + 1) begin 
	    dffe_ref a_dff(.q(Q[i]), .d(Q[i - 1]), .clk(clk), .en(1'b1), .clr(reset));   
	end
    endgenerate

    assign rand = Q;

endmodule 
