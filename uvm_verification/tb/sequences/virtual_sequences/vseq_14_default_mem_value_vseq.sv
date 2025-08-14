class default_mem_value_vseq extends dpram_vseq_base;

    `uvm_object_utils(default_mem_value_vseq)

    function new(string name="default_mem_value_vseq");
        super.new(name);
    endfunction

    virtual task body();
        read_all_mem_seq seq_rd_mem;
        seq_rd_mem = read_all_mem_seq::type_id::create("seq_rd_mem");
        seq_rd_mem.reg_model = reg_model;
        seq_rd_mem.map = reg_model.porta_map;

        super.body();

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
            `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")



        seq_rd_mem.start(porta_sqr);
    endtask


endclass