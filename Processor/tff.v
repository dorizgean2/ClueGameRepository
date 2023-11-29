module tff(T, clk, en, r, Q);
    input T, en, clk, r;
    output Q; 
   
    wire r, notQ, Q, notT, en, T, w1, w2, w3; 

    not not_T(notT, T); 
    not not_Q(notQ, Q);

    and AND_notT_Q(w1, notT, Q);
    and AND_T_notQ(w2, T, notQ);

    or OR_w1_w2(w3, w1, w2);

    dffe_ref a_dff(.q(Q), .d(w3), .clk(clk), .en(en), .clr(r));   

endmodule 
