
module tb_dual_port_ram;
  logic clk;
  logic rst_n; 
  event reset_system;
  event hold_reset;
  
  port_if port_a_if(clk, rst_n);
  port_if port_b_if(clk, rst_n);
  
  DP_MEM dut (
    .clk(clk),
    .rstn(rst_n), 
    .addr_a(port_a_if.addr),
    .wr_data_a(port_a_if.data),
    .op_a(port_a_if.we),
    
//     .clk_b(port_b_if.clk),
    .addr_b(port_b_if.addr),
    .wr_data_b(port_b_if.data),
    .op_b(port_b_if.we),
    .rd_data_a(port_a_if.q),
    .rd_data_b(port_b_if.q),

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
      string test_type;
      test t;
      string test_type_str;
      int NoOfTrans = 10;
      int DisableDisplay = 0;
      int porta_fill_portb_read = 1;
    int rst_delay;

      if ($value$plusargs("TEST=%s", test_type_str))
          test_type = test_type_str;
      else
          test_type = "default"; 
    
    if ($value$plusargs("NoOfTran=%d", NoOfTrans));

    
    
    if ($value$plusargs("DisableDisplay=%d", DisableDisplay));
    
    if ($value$plusargs("portA_fill_portB_read=%d", porta_fill_portb_read));

    
      TestRegistry::set_int("NoOfTransactions",NoOfTrans);
      TestRegistry::set_int("Disabledisplay",DisableDisplay);
          TestRegistry::set_int("portA_fill_portB_read",porta_fill_portb_read);


      
      t = test_factory::create_test(test_type);
            
      
      t.e0.vif_a = port_a_if;
      t.e0.vif_b = port_b_if;
      t.reset_system = reset_system;
      t.hold_reset = hold_reset;
    system_reset();
    rst_delay = $urandom_range(10, 30); // Random reset delay

    repeat(rst_delay) @(posedge clk);

    
      
      t.run();
      
      
    

  end
  initial forever begin
    @(reset_system);
        system_reset();
      
  end

  initial forever begin
    @(hold_reset);
    rst_n = 1'b0;
    repeat(2) @(posedge clk);
    @(hold_reset);
    rst_n = 1'b1;
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule
