class simultaneous_write_same_address_vseq extends dpram_vseq_base;
    `uvm_object_utils(simultaneous_write_same_address_vseq)
    int NoTrans;
    logic [`ADDR_WIDTH-1:0] same_tr_addr;

    function new(string name="simultaneous_write_same_address_vseq");
        super.new(name);
    endfunction

    virtual task body();
        single_wr_rd_seq seq_a;
        single_wr_rd_seq seq_b;

        super.body(); // Initialize sequencer handles

        seq_a = single_wr_rd_seq::type_id::create("seq_a");
        seq_b = single_wr_rd_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
        seq_b.map = reg_model.portb_map;

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
      `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")

        repeat(NoTrans) begin
            same_tr_addr = $urandom_range(0, `MEM_DEPTH-1);
            seq_a.current_addr = same_tr_addr;
            seq_b.current_addr = same_tr_addr;
            #40;
            fork
                begin
                    seq_a.start(porta_sqr);

                end
                begin
                    seq_b.start(portb_sqr);
                end
            join
        end
    endtask

endclass