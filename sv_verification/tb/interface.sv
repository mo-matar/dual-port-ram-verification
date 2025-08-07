interface port_if (input bit clk, input bit rst_n);

  logic [`WIDTH-1:0] data=0;
logic [`ADDR_WIDTH-1:0] addr;
logic we=0;
logic valid=0;
logic ready;
logic [`WIDTH-1:0] q;
bit arbiter_b;

always_ff @(posedge clk) begin
       arbiter_b <= ~arbiter_b;
    end


endinterface
