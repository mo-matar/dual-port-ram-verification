class B2B_transactions_both_ports_vseq extends dpram_vseq_base;
    `uvm_object_utils(B2B_transactions_both_ports_vseq)

    function new(string name="B2B_transactions_both_ports_vseq");
        super.new(name);
    endfunction

    virtual task body();
        b2b_write_seq seq_a_wr;
        b2b_read_seq seq_a_rd;
        b2b_write_seq seq_b_wr;
        b2b_read_seq seq_b_rd;
        read_all_mem_seq seq_rd_mem;

        super.body(); // Initialize sequencer handles

        seq_a_wr = b2b_write_seq::type_id::create("seq_a_wr");
        seq_a_rd = b2b_read_seq::type_id::create("seq_a_rd");
        seq_b_wr = b2b_write_seq::type_id::create("seq_b_wr");
        seq_b_rd = b2b_read_seq::type_id::create("seq_b_rd");
        seq_rd_mem = read_all_mem_seq::type_id::create("seq_rd_mem");
        seq_a_wr.reg_model = reg_model;
        seq_a_rd.reg_model = reg_model;
        seq_b_wr.reg_model = reg_model;
        seq_b_rd.reg_model = reg_model;
        seq_rd_mem.reg_model = reg_model;
        seq_a_wr.map = reg_model.porta_map;
        seq_a_rd.map = reg_model.porta_map;
        seq_b_wr.map = reg_model.portb_map;
        seq_b_rd.map = reg_model.portb_map;
        seq_rd_mem.map = reg_model.porta_map;
        seq_a_rd.is_dependant_on_write = 0;
        seq_b_rd.is_dependant_on_write = 0;

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
            `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")

        repeat(NoTrans) begin
            //random read or write transaction
            fork
                begin
                    if ($urandom_range(0, 1)) begin
                        seq_a_wr.start(porta_sqr);
                    end else begin
                        seq_a_rd.start(porta_sqr);
                    end
                    
                end

                begin
                    if ($urandom_range(0, 1)) begin
                        seq_b_wr.start(portb_sqr);
                    end else begin
                        seq_b_rd.start(portb_sqr);
                    end
                end


            join
                end



        `uvm_warning("B2B_transactions_both_ports_vseq", "NOW READ ALL MEM")

        seq_rd_mem.start(porta_sqr);

    endtask

endclass