// Minimal virtual sequence base and a stub virtual sequence
class dpram_vseq_base extends uvm_sequence;
    `uvm_object_utils(dpram_vseq_base)
    `uvm_declare_p_sequencer(dpram_virtual_sequencer)

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
        super.body();
        // Run basic write/read on both ports

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