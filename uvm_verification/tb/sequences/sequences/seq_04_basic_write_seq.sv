
class basic_write_seq extends dpram_base_seq;
    `uvm_object_utils(basic_write_seq)
    function new(string name="basic_write_seq");
        super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_create(it);
      frontdoor_write(it);
    endtask
endclass
