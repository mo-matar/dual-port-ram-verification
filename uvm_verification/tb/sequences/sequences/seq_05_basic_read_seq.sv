class basic_read_seq extends dpram_base_seq;
    `uvm_object_utils(basic_read_seq)
    function new(string name="basic_read_seq");
        super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_create(it);
      frontdoor_read(it);
    endtask

endclass