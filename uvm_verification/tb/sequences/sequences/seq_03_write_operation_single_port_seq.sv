class write_operation_single_port_seq extends dpram_base_seq;
    `uvm_object_utils(write_operation_single_port_seq)
    function new(string name="write_operation_single_port_seq");
        super.new(name);
    endfunction

    virtual task body();

      super.body();

      repeat (NoTrans) begin
        `uvm_create(it);
        frontdoor_write(it);
        #1;
        backdoor_read(it);
      end
    endtask
endclass
