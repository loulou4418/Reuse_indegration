module simpleproc(
    input clk, datain, nrst,
    inout address,
    output dataout);

    always @ (posedge clk) begin
        if(!nrst)
        dataout <= datain
        else
        dataout <= 0;
    end

endmodule;