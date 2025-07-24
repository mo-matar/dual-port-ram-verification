interface port_if (input bit clk, input bit rst_n);

logic [`WIDTH-1:0] data;
logic [$clog2(`DEPTH)-1:0] addr;
logic we;
logic valid;
logic ready;
logic [`WIDTH-1:0] q;


endinterface
