// Base configuration class for DPRAM testbench
class DpramBaseConfig;
  // General settings
  string test_name = "base_test";
  int test_duration = 1000;       // Number of cycles
  bit enable_coverage = 1;
  
  // Transaction parameters
  int transaction_delay = 0;      // Clock cycles between transactions
  bit enable_ready_check = 1;     // Check ready signal behavior
  
  // RAM parameters
  int address_width = 6;          // 6 bits (64 addresses)
  int data_width = 8;             // 8 bits data width
  
  // Interface controls
  bit port_a_enable = 1;
  bit port_b_enable = 1;
endclass

// Configuration for TC1.3: Memory Range Test
class MemoryRangeConfig extends DpramBaseConfig;
  function new();
    super.new();
    test_name = "memory_range_test";
    transaction_delay = 1;  // Minimal delay between transactions
  endfunction
endclass

// Configuration for TC2.3: Simultaneous Write to Same Address
class SimultaneousWriteConfig extends DpramBaseConfig;
  bit [5:0] collision_address = 6'h0F;  // Address where collision should occur
  
  function new();
    super.new();
    test_name = "simultaneous_write_test";
    transaction_delay = 0;  // No delay for simultaneous transactions
  endfunction
endclass

// Configuration for TC3.2: Medium Transaction Spacing
class MediumDelayConfig extends DpramBaseConfig;
  function new();
    super.new();
    test_name = "medium_delay_test";
    transaction_delay = 5;  // 5 clock cycles between transactions
  endfunction
endclass

// Configuration for TC3.3: Large Transaction Spacing
class LargeDelayConfig extends DpramBaseConfig;
  function new();
    super.new();
    test_name = "large_delay_test";
    transaction_delay = 100;  // 100 clock cycles between transactions
  endfunction
endclass

// Configuration for TC5.2: Reset During Transaction
class ResetTestConfig extends DpramBaseConfig;
  int reset_duration = 3;        // Duration of reset in clock cycles
  int reset_during_cycle = 1;    // When to apply reset during transaction
  
  function new();
    super.new();
    test_name = "reset_test";
  endfunction
endclass

// Configuration for TC6.1: Clock Frequency Variation
class ClockFreqConfig extends DpramBaseConfig;
  int initial_clock_period_ns = 10;   // 100MHz
  int second_clock_period_ns = 20;    // 50MHz
  int clock_switch_time = 500;        // When to switch clock frequency
  
  function new();
    super.new();
    test_name = "clock_freq_test";
    test_duration = 2000;  // Longer test to observe both frequencies
  endfunction
endclass

// Example of use in testbench
module tb_top;
  // Config objects
  DpramBaseConfig base_config;
  SimultaneousWriteConfig sim_write_config;
  
  // Testbench components
  Generator gen_a, gen_b;
  Driver drv_a, drv_b;
  
  initial begin
    // Select which configuration to use based on test scenario
    if ($test$plusargs("SIMULTANEOUS_WRITE")) begin
      sim_write_config = new();
      gen_a = new(sim_write_config);
      gen_b = new(sim_write_config);
      
      // Generate transactions to same address
      drv_a.drive_address = sim_write_config.collision_address;
      drv_b.drive_address = sim_write_config.collision_address;
    end
    else begin
      base_config = new();
      gen_a = new(base_config);
      gen_b = new(base_config);
    end
    
    // Start test
    fork
      gen_a.run();
      gen_b.run();
    join
  end
endmodule