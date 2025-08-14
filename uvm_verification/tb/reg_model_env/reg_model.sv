class dut_mem extends uvm_mem;

    `uvm_object_utils(dut_mem)

    //constructor
    function new(string name = "dut_mem");
      super.new(name, `MEM_DEPTH, `DATA_WIDTH, "RW", UVM_NO_COVERAGE);
    endfunction

    //no need to use configure in memory

endclass


class dpram_reg_block extends uvm_reg_block;
    `uvm_object_utils(dpram_reg_block)

    dut_mem mem;
    uvm_reg_map porta_map;
    uvm_reg_map portb_map;

    //constructor
    function new(string name = "dpram_reg_block");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    function void build(); 
        // it is mandatory to specify backdoor in memory
      add_hdl_path("tb_dual_port_ram.dut", "RTL");

        mem = new("mem");
      mem.add_hdl_path_slice("mem_inst.mem", 0, `DATA_WIDTH);
        mem.configure(this);

        porta_map = create_map("reg_map", 0, 4, UVM_LITTLE_ENDIAN, 0);
        porta_map.add_mem(mem, 'h0);

        portb_map = create_map("portb_map", 0, 4, UVM_LITTLE_ENDIAN, 0);
        portb_map.add_mem(mem, 'h0);

//         porta_map.set_auto_predict(1);
//         portb_map.set_auto_predict(1);

        lock_model();

    endfunction




endclass



// class reg0 extends uvm_reg;
//     `uvm_object_utils(reg0)

//     //add the fields
//     // here we have a single reg field
//     rand uvm_reg_field f_reg0

//     //constructor
//     function new(string name = "reg0");
//         super.new(name, 32, UVM_NO_COVERAGE);// name, size, coverage
//     endfunction


//     function void build(); // this is a user defined function and it will be manually called
//         f_reg0 = uvm_reg_field::type_id::create("f_reg0");
//         f_reg0.configure(
//             .parent(this),
//             .size(32),
//             .lsb_pos(0),
//             .access("RW"),
//             .volatile(0),// if 1: field can be changed between consecutive accesses (like a sensor reg), if 0: field cannot be changed between consecutive accesses (memory reg)
//             .reset('h0),
//             .has_reset(1),
//             .is_rand(1), // this can be enabled to enable writing random values to a field
//             .individually_accessible(1)
//         );
//     endfunction
// endclass