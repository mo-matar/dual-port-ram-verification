class dpram_env extends uvm_env;
    `uvm_component_utils(dpram_env)

    dpram_agent agent_a;
    dpram_agent agent_b;
    dpram_scoreboard scoreboard;
    dpram_reg_block reg_block;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_a = dpram_agent::type_id::create(.name("agent_a"), .parent(this));
        agent_b = dpram_agent::type_id::create(.name("agent_b"), .parent(this));
        scoreboard = dpram_scoreboard::type_id::create(.name("scoreboard"), .parent(this));
        reg_block = dpram_reg_block::type_id::create(.name("reg_block"), .parent(this));
        reg_block.build();
        uvm_config_db#(dpram_reg_block)::set(null, "uvm_test_top.*", "reg_block", reg_block);
    endfunction 

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent_a.monitor.dpram_ap_a.connect(scoreboard.dpram_export_a);
        agent_b.monitor.dpram_ap_b.connect(scoreboard.dpram_export_b);
    endfunction

endclass





        

