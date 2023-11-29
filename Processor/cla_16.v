module cla_16(A, B, C0, S);
    input [15:0] A, B;
    input C0;

    output [15:0] S;

    wire C0, C8, C16;
    wire [15:0] G, P; 

    block_8bit block1(A[7:0], B[7:0], C0, S[7:0], P[7:0], G[7:0], C8);      
    block_8bit block2(A[15:8], B[15:8], C8, S[15:8], P[15:8], G[15:8], C16);      
endmodule
