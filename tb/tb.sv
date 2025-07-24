
// Top-level testbench
module tb_dual_port_ram;
  // Clock and reset
  logic clk;
  logic rst_n;  // Active-low reset signal
  
  // Interfaces for both ports
  ram_if port_a_if(clk, rst_n);
  ram_if port_b_if(clk, rst_n);
  
  // DUT instantiation
  dual_port_ram dut (
    .clk_a(port_a_if.clk),
    .rst_n(rst_n),  // Single reset for entire RAM
    .addr_a(port_a_if.addr),
    .data_a(port_a_if.data),
    .we_a(port_a_if.we),
    
    .clk_b(port_b_if.clk),
    // No separate reset for port B
    .addr_b(port_b_if.addr),
    .data_b(port_b_if.data),
    .we_b(port_b_if.we)
  );
  
  // Test agents
  port_agent agent_a;
  port_agent agent_b;
  
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  // Reset control - system level
  task system_reset;
    rst_n = 0;  // Assert reset
    repeat(5) @(posedge clk);
    rst_n = 1;  // De-assert reset
  endtask
  
  // Test sequence
  initial begin
    // Initialize agents
    agent_a = new("Agent_A", port_a_if);
    agent_b = new("Agent_B", port_b_if);
    
    // Apply system reset
    system_reset();
    
    // Now start transactions on both ports
    fork
      agent_a.start();
      agent_b.start();
    join_none
    
    // Test continues...
  end
endmodule



// instantiate the DUT wrapper here
