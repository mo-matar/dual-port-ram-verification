class fill_memory_porta_write_portb_read_vseq extends dpram_vseq_base;
    `uvm_object_utils(fill_memory_porta_write_portb_read_vseq)
    int NoTrans;

    function new(string name="fill_memory_porta_write_portb_read_vseq");
        super.new(name);
    endfunction

    virtual task body();
        fill_mem_seq seq_a;
        read_all_mem_seq seq_b;

        super.body(); // Initialize sequencer handles
        
        seq_a = fill_mem_seq::type_id::create("seq_a");
        seq_b = read_all_mem_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
        seq_b.map = reg_model.portb_map;


        seq_a.start(porta_sqr);
        porta_sqr.stop_sequences();
        //wait random delay
        #(10 + $urandom_range(0, 20));
        seq_b.start(portb_sqr);

    endtask

endclass