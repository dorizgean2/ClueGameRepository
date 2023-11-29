module sra_32(out, shift_amt, in);
    input [4:0] shift_amt;
    input [31:0] in;

    output [31:0] out;

    wire [31: 0] w1, w2, w3, w4, w5, w6, w7, w8, w9; 

    sra_16 shift_16(w1, in);
    mux_2 mux1(w2, shift_amt[4], in, w1);
    sra_8 shift_8(w3, w2);
    mux_2 mux2(w4, shift_amt[3], w2, w3);
    sra_4 shift_4(w5, w4);
    mux_2 mux3(w6, shift_amt[2], w4, w5);
    sra_2 shift_2(w7, w6);
    mux_2 mux4(w8, shift_amt[1], w6, w7);
    sra_1 shift_1(w9, w8);
    mux_2 mux5(out, shift_amt[0], w8, w9);
endmodule 

