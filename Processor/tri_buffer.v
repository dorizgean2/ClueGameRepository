module tri_buffer #(parameter WIDTH = 32) (out, in, oe);
    input oe;
    input [WIDTH-1:0] in; 
    output [WIDTH-1:0] out;

    wire [WIDTH-1:0] in;
    wire [WIDTH-1:0] out;

    assign out = oe ? in : 1'bz;
endmodule 
