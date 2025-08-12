class base_test extends uvm_test;
  `uvm_component_utils(base_test)

    dpram_env env;
    virtual port_if vif_a;
    virtual port_if vif_b;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
  
      virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this);
      vif_a.rst_n = 1;
      repeat(1) @(posedge vif_a.clk);
      vif_a.rst_n = 0; 
      repeat(4) @(posedge vif_a.clk);
      vif_a.rst_n = 1; 
      repeat(5) @(posedge vif_a.clk);
      phase.drop_objection(this);

    endtask

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = dpram_env::type_id::create(.name("env"), .parent(this));

        // Get and set virtual interfaces for each agent
        if(!uvm_config_db#(virtual port_if)::get(this, "", "port_a_if", vif_a)) begin
            `uvm_fatal("NOCONFIG", "No virtual interface found for vif_a")
        end
      uvm_config_db#(virtual port_if)::set(this, "env.agent_a.*", "vif", vif_a);

        if(!uvm_config_db#(virtual port_if)::get(this, "", "port_b_if", vif_b)) begin
            `uvm_fatal("NOCONFIG", "No virtual interface found for vif_b")
        end
        uvm_config_db#(virtual port_if)::set(this, "env.agent_b.*", "vif", vif_b);

    endfunction
  

  

//      function void start_of_simulation_phase(uvm_phase phase);
//         super.start_of_simulation_phase(phase);
//         if (uvm_report_enabled(UVM_HIGH)) begin
//             this.print();
//             factory.print();
//         end
//     endfunction

endclass



class dpram_test extends base_test;
    `uvm_component_utils(dpram_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
  
    virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
    endtask
  
  virtual task main_phase(uvm_phase phase);
        dpram_vseq vseq = dpram_vseq::type_id::create("vseq");
        phase.raise_objection(this);
        vseq.reg_model = env.reg_blk;
        vseq.start(env.v_sqr);
        phase.drop_objection(this);
  endtask

//     virtual task run_phase(uvm_phase phase);
//         dpram_vseq vseq = dpram_vseq::type_id::create("vseq");
//         phase.raise_objection(this);
//         vseq.start(env.v_sqr);
//         phase.drop_objection(this);
//     endtask

endclass

// class write_operation_porta_test extends base_test;
//     `uvm_component_utils(write_operation_porta_test)

//     function new(string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction
//     virtual task reset_phase(uvm_phase phase);
//         super.reset_phase(phase);
//     endtask

//     virtual task main_phase(uvm_phase phase);
//         dpram_vseq vseq = dpram_vseq::type_id::create("vseq");
//         phase.raise_objection(this);
//         vseq.start(env.v_sqr);
//         phase.drop_objection(this);
//     endtask

// endclass
