module sra_8(out, in);
    input [31:0] in;

    output [31:0] out;

    assign out[31] = in[31];
    assign out[30] = in[31];
    assign out[29] = in[31];
    assign out[28] = in[31];
    assign out[27] = in[31];
    assign out[26] = in[31];
    assign out[25] = in[31];
    assign out[24] = in[31];
    assign out[23] = in[31];
    assign out[22] = in[30];
    assign out[21] = in[29];
    assign out[20] = in[28];
    assign out[19] = in[27];
    assign out[18] = in[26];
    assign out[17] = in[25];
    assign out[16] = in[24];
    assign out[15] = in[23];
    assign out[14] = in[22];
    assign out[13] = in[21];
    assign out[12] = in[20];
    assign out[11] = in[19];
    assign out[10] = in[18];
    assign out[9] = in[17];
    assign out[8] = in[16];
    assign out[7] = in[15];
    assign out[6] = in[14];
    assign out[5] = in[13];
    assign out[4] = in[12];
    assign out[3] = in[11];
    assign out[2] = in[10];
    assign out[1] = in[9];
    assign out[0] = in[8];
endmodule
