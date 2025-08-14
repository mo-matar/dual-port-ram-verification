class read_operation_single_port_seq extends dpram_base_seq;
    `uvm_object_utils(read_operation_single_port_seq)
    function new(string name="read_operation_single_port_seq");
        super.new(name);
    endfunction

    virtual task body();
      super.body();

      repeat (NoTrans) begin
        `uvm_create(it);
        backdoor_write(it);
        frontdoor_read(it);
      end
    endtask
endclass