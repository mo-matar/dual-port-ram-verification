class dpram_env extends uvm_env;
    `uvm_component_utils(dpram_env)

    dpram_agent agent_a;
    dpram_agent agent_b;
    // Add virtual sequencer instance
    dpram_virtual_sequencer v_sqr;
    dpram_scoreboard scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_a = dpram_agent::type_id::create(.name("agent_a"), .parent(this));
        agent_b = dpram_agent::type_id::create(.name("agent_b"), .parent(this));
        scoreboard = dpram_scoreboard::type_id::create(.name("scoreboard"), .parent(this));
        // Create virtual sequencer
        v_sqr = dpram_virtual_sequencer::type_id::create(.name("v_sqr"), .parent(this));
    endfunction 

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent_a.monitor.analysis_port.connect(scoreboard.m_analysis_imp_a);
        agent_b.monitor.analysis_port.connect(scoreboard.m_analysis_imp_b);
        
        uvm_config_db#(dpram_sequencer)::set(this, "*", "porta_sqr", agent_a.sequencer);
        uvm_config_db#(dpram_sequencer)::set(this, "*", "portb_sqr", agent_b.sequencer);
    endfunction

endclass







