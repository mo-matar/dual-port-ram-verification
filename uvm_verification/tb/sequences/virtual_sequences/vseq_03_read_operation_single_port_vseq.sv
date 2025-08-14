class read_operation_single_port_vseq extends dpram_vseq_base;
    `uvm_object_utils(read_operation_single_port_vseq)

    function new(string name="read_operation_single_port_vseq");
        super.new(name);
    endfunction

    virtual task body();
        read_operation_single_port_seq seq_a;

        if(!uvm_config_db#(int)::get(null, "uvm_test_top", "portA_portB_alternate_op", portA_portB_alternate_op))
            `uvm_fatal("CONFIG_ERROR", "Failed to get portA_portB_alternate_op from config_db")


        seq_a = read_operation_single_port_seq::type_id::create("seq_a");
        seq_a.reg_model = reg_model;
        seq_a.map = (portA_portB_alternate_op) ? reg_model.porta_map : reg_model.portb_map;

        if(!seq_a.randomize()) `uvm_error("RAND","FAILED");

        if(portA_portB_alternate_op)
            seq_a.start(porta_sqr);
        else
            seq_a.start(portb_sqr);
    endtask
endclass