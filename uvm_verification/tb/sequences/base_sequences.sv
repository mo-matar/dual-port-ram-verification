// Basic DPRAM sequences
class dpram_base_seq extends uvm_sequence#(dpram_item);
  `uvm_object_utils(dpram_base_seq)
    logic [`MEM_DEPTH-1:0] current_addr;
    logic [`DATA_WIDTH-1:0] read_data;
    logic [`DATA_WIDTH-1:0] write_data;
    int active = 1;
    dpram_reg_block reg_model;
    rand int NoTrans;
    uvm_reg_map map;
  dpram_mem_pool_t global_mem_pool;
    constraint NoTrans_c {
        NoTrans >= 10;
        NoTrans <= 20;
    }


    function new(string name="dpram_base_seq");
        super.new(name);
    endfunction

    /**********************************FD BD COMMON METHODS!*********************************************/
  
    virtual task frontdoor_write_read(ref dpram_item it);
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

    virtual task backdoor_write(ref dpram_item it);
      uvm_status_e status;
      if (!it.randomize()) begin
        `uvm_error(get_type_name(), "Randomize write item failed")
        return;
      end
      current_addr = it.addr;
      write_data = it.data;
      `uvm_info("DPRAM_SEQ", $sformatf("BD Writing to addr=%0h, data=%0h", it.addr, it.data), UVM_MEDIUM)
      global_mem_pool.add(it.addr, it.data);
      reg_model.mem.poke(status, it.addr, it.data);
      if (status != UVM_IS_OK) begin
        `uvm_error(get_type_name(), $sformatf("BD Write failed at addr=%0h", it.addr))
      end
    endtask

    virtual task frontdoor_read(ref dpram_item it);
      uvm_status_e status;
      if (!it.randomize() with {it.addr == current_addr; }) begin
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
endclass
class dpram_wr_rd_seq extends dpram_base_seq;
    `uvm_object_utils(dpram_wr_rd_seq)
    function new(string name="dpram_wr_rd_seq");
        super.new(name);
    endfunction

    virtual task body();
      dpram_item it;
      if (!active) return;
      dpram_adapter::delay = 4;
      repeat (3) begin
        `uvm_create(it);
        frontdoor_write_read(it);
      end
    endtask
endclass


class read_operation_porta_seq extends dpram_base_seq;
    `uvm_object_utils(read_operation_porta_seq)
    function new(string name="read_operation_porta_seq");
        super.new(name);
    endfunction

    virtual task body();
      dpram_item it;
            global_mem_pool = dpram_mem_pool_t::get_global_pool();

      if (!active) return;
      dpram_adapter::delay = 4;
      repeat (3) begin
        `uvm_create(it);
        backdoor_write(it);
        frontdoor_read(it);
      end
    endtask
endclass