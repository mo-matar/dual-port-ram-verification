class dpram_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(dpram_virtual_sequencer)

    // Sub-sequencer handles from each port's agent
    dpram_sequencer porta_sqr;
    dpram_sequencer portb_sqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        if (!uvm_config_db#(dpram_sequencer)::get(this, "", "porta_sqr", porta_sqr))
            `uvm_fatal("VSQR/CFG/NOPORTA", "No porta_sqr specified for this instance")

        if (!uvm_config_db#(dpram_sequencer)::get(this, "", "portb_sqr", portb_sqr))
            `uvm_fatal("VSQR/CFG/NOPORTB", "No portb_sqr specified for this instance")
    endfunction
endclass