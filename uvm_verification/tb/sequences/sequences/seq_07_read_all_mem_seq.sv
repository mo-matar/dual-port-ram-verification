class read_all_mem_seq extends dpram_base_seq;
    `uvm_object_utils(read_all_mem_seq)
    function new(string name="read_all_mem_seq");
        super.new(name);
    endfunction

    virtual task body();
      super.body();

    
      read_all_mem();
    endtask
endclass