// Minimal virtual sequence base and a stub virtual sequence
class dpram_vseq_base extends uvm_sequence;
    `uvm_object_utils(dpram_vseq_base)
    `uvm_declare_p_sequencer(dpram_virtual_sequencer)
    dpram_reg_block reg_model;


    // Sub-sequencer handles for convenience in derived sequences
    dpram_sequencer porta_sqr;
    dpram_sequencer portb_sqr;

    function new(string name="dpram_vseq_base");
        super.new(name);
    endfunction

    virtual task body();
        // Bind sub-sequencer handles from the virtual sequencer
        porta_sqr = p_sequencer.porta_sqr;
        portb_sqr = p_sequencer.portb_sqr;
    endtask
endclass

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


class read_operation_porta_vseq extends dpram_vseq_base;
    `uvm_object_utils(read_operation_porta_vseq)

    function new(string name="read_operation_porta_vseq");
        super.new(name);
    endfunction

    virtual task body();
        read_operation_porta_seq seq_a;

        seq_a = read_operation_porta_seq::type_id::create("seq_a");
        seq_a.reg_model = reg_model;
//       reg_model.print();
        seq_a.map = reg_model.porta_map;
//         super.body();
//         Run read on port A
        if(!seq_a.randomize()) `uvm_error("RAND","FAILED");
        seq_a.start(porta_sqr);
    endtask
endclass

class write_operation_porta_vseq extends dpram_vseq_base;
    `uvm_object_utils(write_operation_porta_vseq)

    function new(string name="write_operation_porta_vseq");
        super.new(name);
    endfunction

    virtual task body();
        write_operation_porta_seq seq_a;

        seq_a = write_operation_porta_seq::type_id::create("seq_a");
        seq_a.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;

        if(!seq_a.randomize()) `uvm_error("RAND","FAILED");
        seq_a.start(porta_sqr);
        

    endtask
endclass