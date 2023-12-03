`timescale 1ns/100ps
module rng_tb; 
    reg clock = 0, clear = 0;
    wire[2:0] random_number;

    rng #(2) generator(.clk(clock), .rand(random_number), .reset(clear));
    
    always 
	#10 clock = ~clock;

    integer i;

    initial begin 
	for(i = 1; i < 100; i = i + 1) begin
	    $display("RNG = %d", random_number);
	    #20;
	end
	$finish;
    end

   initial begin
	$dumpfile("rng_tb.vcd");
	
	$dumpvars(0, rng_tb);
    end
endmodule
