class simultaneous_read_different_address_vseq extends dpram_vseq_base;
    `uvm_object_utils(simultaneous_read_different_address_vseq)
    int NoTrans;

    function new(string name="simultaneous_read_different_address_vseq");
        super.new(name);
    endfunction

    virtual task body();
        fill_mem_seq seq_fill;
        b2b_read_seq seq_a;
        b2b_read_seq seq_b;

        super.body(); // Initialize sequencer handles

        seq_a = b2b_read_seq::type_id::create("seq_a");
        seq_b = b2b_read_seq::type_id::create("seq_b");
        seq_fill = fill_mem_seq::type_id::create("seq_fill");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_fill.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
        seq_b.map = reg_model.portb_map;
        seq_fill.map = reg_model.porta_map;
        seq_a.is_dependant_on_write = 0;
        seq_b.is_dependant_on_write = 0;

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
            `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")


        seq_fill.start(porta_sqr);

        repeat(NoTrans) begin

        fork
            begin
                #40;
                seq_a.start(porta_sqr);
            end
            begin
                #40;
                seq_b.start(portb_sqr);
            end
        join

        end

    endtask

endclass