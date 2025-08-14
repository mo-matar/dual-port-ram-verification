class dpram_vseq extends dpram_vseq_base;
    `uvm_object_utils(dpram_vseq)

    function new(string name="dpram_vseq");
        super.new(name);
    endfunction

    virtual task body();
        dpram_wr_rd_seq seq_a;
        dpram_wr_rd_seq seq_b;

        seq_a = dpram_wr_rd_seq::type_id::create("seq_a");
        seq_b = dpram_wr_rd_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
      	seq_b.map = reg_model.portb_map;
        super.body();
        // Run basic write/read on both ports
      `uvm_warning("2222222", $sformatf("2222222222222222"))


        fork
            begin
                if(!seq_a.randomize()) `uvm_error("RAND","FAILED");
                seq_a.start(porta_sqr);
                
            end
            begin
                if(!seq_b.randomize()) `uvm_error("RAND","FAILED");
                seq_b.start(portb_sqr);
                
            end
        join
    endtask
endclass
