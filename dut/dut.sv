
`define DATA_WIDTH 32
`define ADDR_WIDTH 16
`define MEM_DEPTH  49152

`define START_ADDR 0

module MEM(
  input clk,
  input rstn,
  input valid,
  input op,
  input [`DATA_WIDTH-1:0] wr_data,
  input [`ADDR_WIDTH-1:0] addr,
  output reg [`DATA_WIDTH-1:0] rd_data
);
  
  
endmodule

module DP_MEM(
  input clk,
  input rstn,
  input valid_a,
  input op_a,
  input [`DATA_WIDTH-1:0] wr_data_a,
  input [`ADDR_WIDTH-1:0] addr_a,
  output [`DATA_WIDTH-1:0] rd_data_a,
  output ready_a,
  input valid_b,
  input op_b,
  input [`DATA_WIDTH-1:0] wr_data_b,
  input [`ADDR_WIDTH-1:0] addr_b,
  output [`DATA_WIDTH-1:0] rd_data_b,
  output ready_b
);
  

endmodule
