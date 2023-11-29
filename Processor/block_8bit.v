module block_8bit(x, y, c0, s, p, g, c8);
    input [7:0] x, y;
    input c0;
    output [7:0] s, p, g;
    output c8;

    wire G, P;
    wire [7:0] c;
    wire [36:0] w;

    // block level1;
    or 	OR_x0_y0(p[0], x[0], y[0]);
    and AND_x0_y0(g[0], x[0], y[0]);
    
    or 	OR_x1_y1(p[1], x[1], y[1]);
    and AND_x1_y1(g[1], x[1], y[1]);

    or 	OR_x2_y2(p[2], x[2], y[2]);
    and AND_x2_y2(g[2], x[2], y[2]);

    or 	OR_x3_y3(p[3], x[3], y[3]);
    and AND_x3_y3(g[3], x[3], y[3]);

    or 	OR_x4_y4(p[4], x[4], y[4]);
    and AND_x4_y4(g[4], x[4], y[4]);

    or 	OR_x5_y5(p[5], x[5], y[5]);
    and AND_x5_y5(g[5], x[5], y[5]);

    or 	OR_x6_y6(p[6], x[6], y[6]);
    and AND_x6_y6(g[6], x[6], y[6]);

    or 	OR_x7_y7(p[7], x[7], y[7]);
    and AND_x7_y7(g[7], x[7], y[7]);

    // block level2;
    xor xOR_y0_c0_x0(s[0], c0, x[0], y[0]);
    and AND_p0_c0(w[0], c0, p[0]);

    xor xOR_y1_c1_x1(s[1], c[1], x[1], y[1]);
    and AND_p1_p0_c0(w[1], p[1], p[0], c0);
    and AND_p1_g0(w[2], p[1], g[0]);

    xor xOR_y2_c2_x2(s[2], c[2], x[2], y[2]);
    and AND_p2_p1_p0_c0(w[3], p[2], p[1], p[0], c0);
    and AND_p2_p1_g0(w[4], p[2], p[1], g[0]);
    and AND_p2_g1(w[5], p[2], g[1]);

    xor xOR_y3_c3_x3(s[3], c[3], x[3], y[3]);
    and AND_p3_p2_p1_p0_c0(w[6], p[3], p[2], p[1], p[0], c0);
    and AND_p3_p2_p1_g0(w[7], p[3], p[2], p[1], g[0]);
    and AND_p3_p2_g1(w[8], p[3], p[2], g[1]);
    and AND_p3_g2(w[9], p[3], g[2]);
 
    xor xOR_y4_c4_x4(s[4], c[4], x[4], y[4]);
    and AND_p4_p3_p2_p1_p0_c0(w[10], p[4], p[3], p[2], p[1], p[0], c0);
    and AND_p4_p3_p2_p1_g0(w[11], p[4], p[3], p[2], p[1], g[0]);
    and AND_p4_p3_p2_g1(w[12], p[4], p[3], p[2], g[1]);
    and AND_p4_p3_g2(w[13], p[4], p[3], g[2]);
    and AND_p4_g3(w[14], p[4], g[3]);  

    xor xOR_y5_c5_x5(s[5], c[5], x[5], y[5]);
    and AND_p5_p4_p3_p2_p1_p0_c0(w[15], p[5], p[4], p[3], p[2], p[1], p[0], c0);
    and AND_p5_p4_p3_p2_p1_g0(w[16], p[5], p[4], p[3], p[2], p[1], g[0]);
    and AND_p5_p4_p3_p2_g1(w[17], p[5], p[4], p[3], p[2], g[1]);
    and AND_p5_p4_p3_g2(w[18], p[5], p[4], p[3], g[2]);
    and AND_p5_p4_g3(w[19], p[5], p[4], g[3]);
    and AND_p5_g4(w[20], p[5], g[4]);
 
    xor xOR_y6_c6_x6(s[6], c[6], x[6], y[6]);
    and AND_p6_p5_p4_p3_p2_p1_p0_c0(w[21], p[6], p[5], p[4], p[3], p[2], p[1], p[0], c0);
    and AND_p6_p5_p4_p3_p2_p1_g0(w[22], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and AND_p6_p5_p4_p3_p2_g1(w[23], p[6], p[5], p[4], p[3], p[2], g[1]);
    and AND_p6_p5_p4_p3_g2(w[24], p[6], p[5], p[4], p[3], g[2]);
    and AND_p6_p5_p4_g3(w[25], p[6], p[5], p[4], g[3]);
    and AND_p6_p5_g4(w[26], p[6], p[5], g[4]);
    and AND_p6_g5(w[27], p[6], g[5]);
 
    xor xOR_y7_c7_x7(s[7], c[7], x[7], y[7]);
    and AND_p7_p6_p5_p4_p3_p2_p1_p0_c0(w[28], p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0], c0);
    and AND_p7_p6_p5_p4_p3_p2_p1_g0(w[29], p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and AND_p7_p6_p5_p4_p3_p2_g1(w[30], p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and AND_p7_p6_p5_p4_p3_g2(w[31], p[7], p[6], p[5], p[4], p[3], g[2]);
    and AND_p7_p6_p5_p4_g3(w[32], p[7], p[6], p[5], p[4], g[3]);
    and AND_p7_p6_p5_g4(w[33], p[7], p[6], p[5], g[4]);
    and AND_p7_p6_g5(w[34], p[7], p[6], g[5]); 
    and AND_p7_g6(w[35], p[7], g[6]);

    // block level3;
    or OR_g0_w0(c[1], w[0], g[0]);
    or OR_g1_w1_w2(c[2], g[1], w[1],w[2]);
    or OR_g2_w3_w4_w5(c[3], g[2], w[3], w[4], w[5]);
    or OR_g3_w6_w7_w8_w9(c[4], g[3], w[6], w[7], w[8], w[9]);
    or OR_g4_w10_w11_w12_w13_w14(c[5], g[4], w[10], w[11], w[12], w[13], w[14]);
    or OR_g5_w15_w16_w17_w18_w19_w20(c[6], g[5], w[15], w[16], w[17], w[18], w[19], w[20]);
    or OR_g6_w21_w22_w23_w24_w25_w26_w27(c[7], g[6], w[21], w[22], w[23], w[24], w[25], w[26], w[27]);

    // computing c8;
    or OR_g7_w28_w29_w30_w31_w32_w33_w34_w35(G, g[7], w[29], w[30], w[31], w[32], w[33], w[34], w[35]);
    and AND_p7_p6_p5_p4_p3_p2_p1_p0(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
    and AND_P_c0(w[36], P, c0);

    or OR_G_P_and_c0(c8, w[36], G);
endmodule 
