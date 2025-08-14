class simultaneous_write_read_same_address_vseq extends dpram_vseq_base;
    `uvm_object_utils(simultaneous_write_read_same_address_vseq)
    int NoTrans;
    int portA_portB_alternate_op;
    logic [`ADDR_WIDTH-1:0] same_tr_addr;

    function new(string name="simultaneous_write_read_same_address_vseq");
        super.new(name);
    endfunction

    virtual task body();
        basic_write_seq seq_a;
        basic_read_seq seq_b;

        super.body(); // Initialize sequencer handles

        seq_a = basic_write_seq::type_id::create("seq_a");
        seq_b = basic_read_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
        seq_b.map = reg_model.portb_map;
        seq_a.ral_check = 0;
        seq_b.ral_check = 0;

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
            `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")

        if(!uvm_config_db#(int)::get(null, "uvm_test_top", "portA_portB_alternate_op", portA_portB_alternate_op))
            `uvm_fatal("CONFIG_ERROR", "Failed to get portA_portB_alternate_op from config_db")

        repeat(NoTrans) begin
            same_tr_addr = $urandom_range(0, `MEM_DEPTH-1);
            seq_a.current_addr = same_tr_addr;
            seq_b.current_addr = same_tr_addr;
            #40;
            if(portA_portB_alternate_op) begin
                fork
                    begin
                        seq_a.start(porta_sqr);

                    end
                    begin
                        seq_b.start(portb_sqr);
                    end
                join
                end else begin
                fork
                    begin
                        seq_a.start(portb_sqr);

                    end
                    begin
                        seq_b.start(porta_sqr);
                    end
                join
            end

        end
    endtask

endclass