class b2b_write_seq extends dpram_base_seq;
    `uvm_object_utils(b2b_write_seq)
    function new(string name="b2b_write_seq");
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
    endtask
endclass
