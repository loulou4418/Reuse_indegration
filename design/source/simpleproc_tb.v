module tb;

    reg tb_clk;
    reg tb_nrst;
    reg tb_datain;
    reg tb_dataout;
    reg tb_address;

    simpleproc simpleproc0 (.clk (tb_clk),
    .nrst (tb_nrst),
    .datain (tb_datain),
    .dataout (tb_dataout),
    .address (tb_address));

    initial begin
        tb_nrst <= 1'b0;
        datain <= 1'b0;
        tb_clk <= 1'b0;
        tb_clk <= 0'b0;

        datain <= 0'b0;
        tb_clk <= 1'b0;
        tb_clk <= 0'b0;

endmodule;