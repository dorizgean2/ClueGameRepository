module cla(A, B, C0,  P, G, S, overflow);
    input [31:0] A, B;
    input C0;

    output [31:0] S, G, P;
    output overflow;

    wire C0, C8, C16, C24, C32;
    wire [31:0] G, P; 
    wire w1, w2, w3, w4, w5, w6, w7;

    block_8bit block1(A[7:0], B[7:0], C0, S[7:0], P[7:0], G[7:0], C8);      
    block_8bit block2(A[15:8], B[15:8], C8, S[15:8], P[15:8], G[15:8], C16);      
    block_8bit block3(A[23:16], B[23:16], C16, S[23:16], P[23:16], G[23:16], C24);      
    block_8bit block4(A[31:24], B[31:24], C24, S[31:24], P[31:24], G[31:24], C32);      

    xnor xnor_A_B(w1, A[31], B[31]);
    xor xnor_A_S(w2, A[31], S[31]);
    mux_2 #(1) checkA_B(overflow, w1, 1'b0, w2);

endmodule
