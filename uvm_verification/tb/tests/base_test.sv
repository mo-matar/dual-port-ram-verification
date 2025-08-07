class dpram_test extends uvm_test;
    `uvm_component_utils(dpram_test)

    dpram_env env;
    dpram_sequence seq;
    virtual port_if vif_a;
    virtual port_if vif_b;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = dpram_env::type_id::create(.name("env"), .parent(this));

            if(!uvm_config_db#(virtual alu_if)::get(this, "", "port_a_if", vif_a)) begin
            `uvm_fatal("NOCONFIG", "No virtual interface found for vif_a")
            end
            uvm_config_db#(virtual alu_if)::set(this, "env.agent_a.*", "vif", vif_a);

            if(!uvm_config_db#(virtual alu_if)::get(this, "", "port_b_if", vif_b)) begin
            `uvm_fatal("NOCONFIG", "No virtual interface found for vif_b")
            end
            uvm_config_db#(virtual alu_if)::set(this, "env.agent_b.*", "vif", vif_b);

        seq = dpram_sequence::type_id::create(.name("seq"), .parent(env.sequencer));
        seq.randomize();
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        seq.start(env.agent_a.sequencer);
        seq.start(env.agent_b.sequencer);
        #100;
        phase.drop_objection(this);
    endtask

endclass

    