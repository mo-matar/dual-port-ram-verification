class single_wr_rd_seq extends dpram_base_seq;
    `uvm_object_utils(single_wr_rd_seq)
    function new(string name="single_wr_rd_seq");
        super.new(name);
    endfunction

    virtual task body();
      super.body();
        if (!m_cfg_ext.randomize() with { transmit_delay == 0; }) begin
          `uvm_error(get_type_name(), "Randomize configuration extension failed")
          return;
        end
        `uvm_create(it);
        frontdoor_write(it);
        frontdoor_read(it);
    endtask

    virtual task frontdoor_write(ref dpram_item it);
      uvm_status_e status;
      if (!it.randomize() with { it.addr == current_addr; }) begin
        `uvm_error(get_type_name(), "Randomize write item failed")
        return;
      end
      current_addr = it.addr;
      write_data = it.data;
      `uvm_info("DPRAM_SEQ", $sformatf("FD Writing to addr=%0h, data=%0h", it.addr, it.data), UVM_MEDIUM)
      reg_model.mem.write(status, it.addr, it.data, .map(map), .extension(m_cfg_ext));
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
    endtask
endclass