class dpram_vseq_base extends uvm_sequence;
    `uvm_object_utils(dpram_vseq_base)
    `uvm_declare_p_sequencer(dpram_virtual_sequencer)
    dpram_reg_block reg_model;
  int NoTrans;
  int portA_portB_alternate_op;


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
