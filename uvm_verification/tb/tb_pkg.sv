`ifndef MEMORY_PKG_SV
`define MEMORY_PKG_SV

package tb_pkg;
    
    // Import UVM library
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    `include "sequence_item.sv"
    `include "config.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "agent.sv"
    `include "scoreboard.sv"
    `include "virtual_sequencer.sv"
    
    // Include RAL components
     `include "reg_model.sv"
     `include "adapter.sv"
    `include "env.sv"

//     `include "memory_reg_predictor.sv"
    
    // Include sequences
    `include "base_sequences.sv"
    `include "virtual_sequences.sv"
//     `include "memory_write_sequence.sv"
//     `include "memory_read_sequence.sv"
//     `include "memory_random_sequence.sv"
    
    // Include tests
    `include "base_test.sv"
//     `include "memory_basic_test.sv"
//     `include "memory_random_test.sv"
endpackage

`endif // MEMORY_PKG_SV
