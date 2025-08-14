class dpram_wr_rd_seq extends dpram_base_seq;
    `uvm_object_utils(dpram_wr_rd_seq)
    function new(string name="dpram_wr_rd_seq");
        super.new(name);
    endfunction

    virtual task body();
      super.body();
      repeat (NoTrans) begin
        `uvm_create(it);
        frontdoor_write_read(it);
      end
    endtask
endclass
