interface port_if (input bit clk);
    bit rst_n;
    logic [`DATA_WIDTH-1:0] wr_data;
    logic [`DATA_WIDTH-1:0] rd_data;
    logic [`ADDR_WIDTH-1:0] addr;
    logic op=0;
    logic valid=0;
    logic ready;
    bit arbiter_b;

  always_ff @(posedge clk) begin
        arbiter_b <= ~arbiter_b;
    end


endinterface
