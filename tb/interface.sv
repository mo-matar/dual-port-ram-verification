interface porta_if ();

logic clk;
logic rst;
logic [7:0] data_a;
logic [5:0] addr_a;
logic we_a;
logic valid_a;
logic ready_a;
logic [7:0] q_a;


endinterface

interface portb_if ();

logic clk;
logic rst;
logic [7:0] data_b;
logic [5:0] addr_b;
logic we_b;
logic valid_b;
logic ready_b;
logic [7:0] q_b;

endinterface
