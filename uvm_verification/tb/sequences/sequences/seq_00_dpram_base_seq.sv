class dpram_base_seq extends uvm_sequence#(dpram_item);
  `uvm_object_utils(dpram_base_seq)
    cfg_info m_cfg_ext; //Extension Object handle
    logic [`MEM_DEPTH-1:0] current_addr;
    logic [`DATA_WIDTH-1:0] read_data;
    logic [`DATA_WIDTH-1:0] write_data;
    int active = 1;
    dpram_reg_block reg_model;
    int NoTrans;
    uvm_reg_map map;
    dpram_item it;
  dpram_mem_pool_t global_mem_pool;
  int ral_check = 1;
  int is_dependant_on_write = 1;
  int is_illegal_addr = 0;


    function new(string name="dpram_base_seq");
        super.new(name);
    endfunction

    virtual task body();
      if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
      `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")
      global_mem_pool = dpram_mem_pool_t::get_global_pool();
       m_cfg_ext = new();
       m_cfg_ext.randomize();
    endtask

    /**********************************FD BD COMMON METHODS!*********************************************/
  
    virtual task frontdoor_write_read(ref dpram_item it);
      uvm_status_e status;
      if (!it.randomize()) begin
        `uvm_error(get_type_name(), "Randomize write item failed")
        return;
      end
      current_addr = it.addr;
      `uvm_info("DPRAM_SEQ", $sformatf("FD Writing to addr=%0h, data=%0h", it.addr, it.data), UVM_MEDIUM)
      reg_model.mem.write(status, it.addr, it.data, .map(map), .extension(m_cfg_ext));
      write_data = it.data;

      if (!it.randomize() with { it.addr == current_addr; }) begin
        `uvm_error(get_type_name(), "Randomize read item failed")
        return;
      end
      `uvm_info("DPRAM_SEQ", $sformatf("FD Reading from addr=%0h", it.addr), UVM_MEDIUM)
      reg_model.mem.read(status, it.addr, read_data, .map(map), .extension(m_cfg_ext));

      `uvm_info("DPRAM_SEQ", $sformatf("FD Read from addr=%0h, data=%0h", it.addr, read_data), UVM_MEDIUM)
      if(ral_check) begin
          if (read_data != write_data) begin
            `uvm_error(get_type_name(), $sformatf("Read data mismatch at addr=%0h, read_data=%0h, expected_data=%0h", it.addr, read_data, write_data))
          end
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
      if (!it.randomize()) begin
        `uvm_error(get_type_name(), "Randomize read item failed")
        return;
      end
        if(is_dependant_on_write)
          it.addr = current_addr;
      `uvm_info("DPRAM_SEQ", $sformatf("FD Reading from addr=%0h", it.addr), UVM_MEDIUM)
      reg_model.mem.read(status, it.addr, read_data, .map(map), .extension(m_cfg_ext));

      `uvm_info("DPRAM_SEQ", $sformatf("FD Read from addr=%0h, data=%0h", it.addr, read_data), UVM_MEDIUM)
      if(ral_check) begin
          if (read_data != write_data) begin
            `uvm_error(get_type_name(), $sformatf("Read data mismatch at addr=%0h, read_data=%0h, expected_data=%0h", it.addr, read_data, write_data))
          end
      end
    endtask

    virtual task backdoor_read(ref dpram_item it);
      uvm_status_e status;
            if (!it.randomize()) begin
        `uvm_error(get_type_name(), "Randomize read item failed")
        return;
      end
        if(is_dependant_on_write)
          it.addr = current_addr;
      `uvm_info("DPRAM_SEQ", $sformatf("BD Reading from addr=%0h", it.addr), UVM_MEDIUM)
      reg_model.mem.peek(status, it.addr, read_data);
      if (status != UVM_IS_OK) begin
        `uvm_error(get_type_name(), $sformatf("BD Read failed at addr=%0h", it.addr))
      end
      `uvm_info("DPRAM_SEQ", $sformatf("BD Read from addr=%0h, data=%0h", it.addr, read_data), UVM_MEDIUM)
      if(ral_check) begin
          if (read_data != write_data) begin
            `uvm_error(get_type_name(), $sformatf("Read data mismatch at addr=%0h, read_data=%0h, expected_data=%0h", it.addr, read_data, write_data))
          end
      end
    endtask

    virtual task frontdoor_write(ref dpram_item it);
      uvm_status_e status;
      if (!it.randomize()) begin
        `uvm_error(get_type_name(), "Randomize write item failed")
        return;
      end
      if(is_illegal_addr) begin
        it.addr = $urandom_range(`MEM_DEPTH, 65535); // Generate out of range address

      end
      current_addr = it.addr;
      write_data = it.data;
      `uvm_info("DPRAM_SEQ", $sformatf("FD Writing to addr=%0h, data=%0h", it.addr, it.data), UVM_MEDIUM)
      reg_model.mem.write(status, it.addr, it.data, .map(map), .extension(m_cfg_ext));
    endtask

    virtual task fill_mem();

        uvm_status_e status;
        current_addr = 0;

        repeat(`MEM_DEPTH)begin
          `uvm_create(it);

        if (!it.randomize() with { it.addr == current_addr; }) begin
          `uvm_error(get_type_name(), "Randomize write item failed")
          return;
        end
        current_addr++;
        `uvm_info("DPRAM_SEQ", $sformatf("FD Writing to addr=%0h, data=%0h", it.addr, it.data), UVM_MEDIUM)
        reg_model.mem.write(status, it.addr, it.data, .map(map), .extension(m_cfg_ext));

        end

      
    endtask

  virtual task read_all_mem();

    uvm_status_e status;
    current_addr = 0;

    repeat(`MEM_DEPTH) begin
      `uvm_create(it);
      if (!it.randomize() with { it.addr == current_addr; }) begin
        `uvm_error(get_type_name(), "Randomize read item failed")
        return;
      end
      `uvm_info("DPRAM_SEQ", $sformatf("FD Reading from addr=%0h", it.addr), UVM_MEDIUM)
      reg_model.mem.read(status, it.addr, read_data, .map(map), .extension(m_cfg_ext));

      `uvm_info("DPRAM_SEQ", $sformatf("FD Read from addr=%0h, data=%0h", it.addr, read_data), UVM_MEDIUM)
      // if (read_data != write_data) begin
      //   `uvm_error(get_type_name(), $sformatf("Read data mismatch at addr=%0h, read_data=%0h, expected_data=%0h", it.addr, read_data, write_data))
      // end
      current_addr++;
    end
  endtask

endclass