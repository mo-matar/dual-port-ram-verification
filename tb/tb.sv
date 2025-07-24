
module tb_dual_port_ram;
  logic clk;
  logic rst_n; 
  
  ram_if port_a_if(clk, rst_n);
  ram_if port_b_if(clk, rst_n);
  
  dual_port_ram dut (
    .clk_a(port_a_if.clk),
    .rst_n(rst_n), 
    .addr_a(port_a_if.addr),
    .data_a(port_a_if.data),
    .we_a(port_a_if.we),
    
    .clk_b(port_b_if.clk),
    .addr_b(port_b_if.addr),
    .data_b(port_b_if.data),
    .we_b(port_b_if.we),
    .q_a(port_a_if.q),
    .q_b(port_b_if.q)

    .valid_a(port_a_if.valid),
    .valid_b(port_b_if.valid),
    .ready_a(port_a_if.ready),
    .ready_b(port_b_if.ready)
  );
  
  port_agent agent_a;
  port_agent agent_b;
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  task system_reset;
    rst_n = 1;
    repeat(1) @(posedge clk);
    rst_n = 0;  // Assert reset
    repeat(5) @(posedge clk);
    rst_n = 1;  // De-assert reset
  endtask
  
  initial begin
      test_names_e test_type;
      test t;
      
      
      if ($value$plusargs("TEST=%s", test_type_str))
          test_type = test_names_e'(test_type_str);
      else
          test_type = basic_write_read_porta; // Default
      
      
      t = test_factory::create_test(test_type);
      
      
      t.e0.vif_a = vif_a;
      t.e0.vif_b = vif_b;
      
      
      t.run();
  end
endmodule
