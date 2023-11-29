module DFFtri(d, clk, clr,  in_enable, out_enable, out);
    input d, clk, clr, in_enable, out_enable;
    output out;

    wire q, clrn;    

    not NOT_clear(clrn, clr);

    dffe_ref a_dff(.q(q), .d(d), .clk(clk), .en(in_enable), .clr(clrn));   
    assign out = out_enable ? q : 1'bz;
endmodule
