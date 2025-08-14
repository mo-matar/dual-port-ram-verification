class B2B_transactions_single_port_vseq extends dpram_vseq_base;
    `uvm_object_utils(B2B_transactions_single_port_vseq)

    function new(string name="B2B_transactions_single_port_vseq");
        super.new(name);
    endfunction

    virtual task body();
        b2b_write_seq seq_wr;
        b2b_read_seq seq_rd;
        read_all_mem_seq seq_rd_mem;

        super.body(); // Initialize sequencer handles
        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
            `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")
        if(!uvm_config_db#(int)::get(null, "uvm_test_top", "portA_portB_alternate_op", portA_portB_alternate_op))
            `uvm_fatal("CONFIG_ERROR", "Failed to get portA_portB_alternate_op from config_db")

        seq_wr = b2b_write_seq::type_id::create("seq_wr");
        seq_rd = b2b_read_seq::type_id::create("seq_rd");
        seq_rd_mem = read_all_mem_seq::type_id::create("seq_rd_mem");
        seq_wr.reg_model = reg_model;
        seq_rd.reg_model = reg_model;
        seq_rd_mem.reg_model = reg_model;

        seq_wr.map = (portA_portB_alternate_op) ? reg_model.porta_map : reg_model.portb_map;
        seq_rd.map = (portA_portB_alternate_op) ? reg_model.porta_map : reg_model.portb_map;
        seq_rd_mem.map = reg_model.porta_map;
        seq_rd.is_dependant_on_write = 0;



        repeat(NoTrans) begin
            //random read or write transaction
        if(portA_portB_alternate_op) begin
                if ($urandom_range(0, 1)) begin
                    seq_wr.start(porta_sqr);
                end else begin
                    seq_rd.start(porta_sqr);
                end
        end
        else begin
            if ($urandom_range(0, 1)) begin
                seq_wr.start(portb_sqr);
            end else begin
                seq_rd.start(portb_sqr);
            end
        end

        end

        seq_rd_mem.start(porta_sqr);

    endtask

endclass
