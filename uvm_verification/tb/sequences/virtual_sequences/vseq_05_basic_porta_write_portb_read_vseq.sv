class basic_porta_write_portb_read_vseq extends dpram_vseq_base;
    `uvm_object_utils(basic_porta_write_portb_read_vseq)
    int NoTrans;

    function new(string name="basic_porta_write_portb_read_vseq");
        super.new(name);
    endfunction

    virtual task body();
        basic_write_seq seq_a;
        basic_read_seq seq_b;

        seq_a = basic_write_seq::type_id::create("seq_a");
        seq_b = basic_read_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
      	seq_b.map = reg_model.portb_map;

    if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
      `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")


        repeat(NoTrans) begin
            seq_a.start(porta_sqr);
            seq_b.current_addr = seq_a.current_addr;
            seq_b.write_data = seq_a.write_data;
            seq_b.start(portb_sqr);
        end
    endtask


endclass
