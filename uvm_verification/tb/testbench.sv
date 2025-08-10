// Code your testbench here
// or browse Examples
`include "interface.sv"
`include "tb_pkg.sv"
module tb_dual_port_ram;
  bit clk;
  bit rst_n; 

  
  port_if port_a_if(clk, rst_n);
  port_if port_b_if(clk, rst_n);
  
  DP_MEM dut (
    .clk(clk),
    .rstn(rst_n), 
    .addr_a(port_a_if.addr),
    .wr_data_a(port_a_if.wr_data),
    .op_a(port_a_if.op),
    
//     .clk_b(port_b_if.clk),
    .addr_b(port_b_if.addr),
    .wr_data_b(port_b_if.wr_data),
    .op_b(port_b_if.op),
    .rd_data_a(port_a_if.rd_data),
    .rd_data_b(port_b_if.rd_data),

    .valid_a(port_a_if.valid),
    .valid_b(port_b_if.valid),
    .ready_a(port_a_if.ready),
    .ready_b(port_b_if.ready)
  );
  
  
  initial begin
    rst_n = 1'b1;
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  task system_reset;
            repeat(5) @(posedge clk);

    rst_n = 1;
    repeat(1) @(posedge clk);
    rst_n = 0; 
    repeat(5) @(posedge clk);
    rst_n = 1; 
        repeat(5) @(posedge clk);

  endtask
  
  initial begin
    uvm_config_db#(virtual port_if)::set(null, "uvm_test_top", "port_a_if", port_a_if);
    uvm_config_db#(virtual port_if)::set(null, "uvm_test_top", "port_b_if", port_b_if);
    run_test("dpram_test");
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule
