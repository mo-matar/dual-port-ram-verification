// Basic DPRAM sequences


class dpram_wr_rd_seq extends uvm_sequence#(dpram_item);
    `uvm_object_utils(dpram_wr_rd_seq)
    logic [`MEM_DEPTH-1:0] current_addr;
    logic [`DATA_WIDTH-1:0] read_data;
    logic [`DATA_WIDTH-1:0] write_data;
    int active = 1;
    dpram_reg_block reg_model;
    rand int NoTrans;
    uvm_reg_map map;
    constraint NoTrans_c {
        NoTrans >= 10;
        NoTrans <= 20;
    }


    function new(string name="dpram_wr_rd_seq");
        super.new(name);
    endfunction

    // Modularized tasks for frontdoor and backdoor operations

    // Frontdoor write and read
    task frontdoor_write_read(ref dpram_item it);
      uvm_status_e status;
      if (!it.randomize()) begin
        `uvm_error(get_type_name(), "Randomize write item failed")
        return;
      end
      current_addr = it.addr;
      `uvm_info("DPRAM_SEQ", $sformatf("FD Writing to addr=%0h, data=%0h", it.addr, it.data), UVM_MEDIUM)
      reg_model.mem.write(status, it.addr, it.data, .map(map));
      write_data = it.data;

      if (!it.randomize() with { it.addr == current_addr; }) begin
        `uvm_error(get_type_name(), "Randomize read item failed")
        return;
      end
      `uvm_info("DPRAM_SEQ", $sformatf("FD Reading from addr=%0h", it.addr), UVM_MEDIUM)
      reg_model.mem.read(status, it.addr, read_data, .map(map));

      `uvm_info("DPRAM_SEQ", $sformatf("FD Read from addr=%0h, data=%0h", it.addr, read_data), UVM_MEDIUM)
      if (read_data != write_data) begin
        `uvm_error(get_type_name(), $sformatf("Read data mismatch at addr=%0h, read_data=%0h, expected_data=%0h", it.addr, read_data, write_data))
      end
    endtask

    // Backdoor write and read
//     task backdoor_write_read(ref dpram_item it);
//       uvm_status_e status;
//       if (!it.randomize()) begin
//         `uvm_error(get_type_name(), "Randomize write item failed")
//         return;
//       end
//       current_addr = it.addr;
//       write_data = it.data;
//       `uvm_info("DPRAM_SEQ", $sformatf("BD Writing to addr=%0h, data=%0h", it.addr, it.data), UVM_MEDIUM)
//       reg_model.mem.poke(status, it.addr, it.data);

//       `uvm_info("DPRAM_SEQ", $sformatf("BD Reading from addr=%0h", it.addr), UVM_MEDIUM)
//       if (!it.randomize()) begin
//         `uvm_error(get_type_name(), "Randomize write item failed")
//         return;
//       end
//       reg_model.mem.peek(status, current_addr, read_data);

//       `uvm_info("DPRAM_SEQ", $sformatf("BD Read from addr=%0h, data=%0h", current_addr, read_data), UVM_MEDIUM)
//       if (read_data != write_data) begin
//         `uvm_error(get_type_name(), $sformatf("Read data mismatch at addr=%0h, read_data=%0h, expected_data=%0h", it.addr, read_data, it.data))
//       end
//     endtask

    virtual task body();
      dpram_item it;
      if (!active) return;
//       `uvm_warning("33333333", $sformatf("33333333333333"))
      dpram_adapter::delay = 4;

      repeat (3) begin
        `uvm_create(it);
        frontdoor_write_read(it);
        //backdoor_write_read(it);
      end
    endtask
endclass
