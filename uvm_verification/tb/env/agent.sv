typedef uvm_sequencer #(dpram_item) dpram_sequencer;

class dpram_agent extends uvm_agent;
    `uvm_component_utils(dpram_agent)

    dpram_sequencer sequencer;
    dpram_monitor monitor;
    dpram_driver driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = dpram_sequencer::type_id::create(.name("sequencer"), .parent(this));
        driver = dpram_driver::type_id::create(.name("driver"), .parent(this));
        monitor = dpram_monitor::type_id::create(.name("monitor"), .parent(this));
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.dpram_ap.connect(sequencer.dpram_ap);
    endfunction

endclass


    
