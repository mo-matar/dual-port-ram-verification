class cfg_info extends uvm_object;
    `uvm_object_utils(cfg_info)
    rand int unsigned transmit_delay; // Creates transaction to transaction delay
    constraint c_transmit_delay {
        transmit_delay >= 0; // Minimum back-to-back latency
        transmit_delay <= 5;
    }
    function new (string name = "");
    super.new(name);
    endfunction
endclass