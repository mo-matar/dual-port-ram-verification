class basic_write_read_single_port_vseq extends dpram_vseq_base;
    `uvm_object_utils(basic_write_read_single_port_vseq)

    function new(string name="basic_write_read_single_port_vseq");
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

        if(!uvm_config_db#(int)::get(null, "uvm_test_top", "portA_portB_alternate_op", portA_portB_alternate_op))
            `uvm_fatal("CONFIG_ERROR", "Failed to get portA_portB_alternate_op from config_db")

        if(portA_portB_alternate_op) begin
        if(!seq_a.randomize()) `uvm_error("RAND","FAILED");
        seq_a.start(porta_sqr);
        end else begin

        if(!seq_b.randomize()) `uvm_error("RAND","FAILED");
        seq_b.start(portb_sqr);

        end

        
    endtask
endclass