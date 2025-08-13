class base_test extends uvm_test;
  `uvm_component_utils(base_test)

    dpram_env env;
    virtual port_if vif_a;
    virtual port_if vif_b;
    int reset_delay;
    int ral_check = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
  
      virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this);
      vif_a.rst_n = 1;
      //random reset delay instead of static
      reset_delay = $urandom_range(5, 11);
        repeat(4) @(posedge vif_a.clk);
      vif_a.rst_n = 0; 
      repeat(reset_delay) @(posedge vif_a.clk);
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

endclass


class read_operation_porta_test extends base_test;
    `uvm_component_utils(read_operation_porta_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
    endtask

    virtual task main_phase(uvm_phase phase);
        read_operation_porta_vseq vseq = read_operation_porta_vseq::type_id::create("vseq");
        phase.raise_objection(this);
        vseq.reg_model = env.reg_blk;
        vseq.start(env.v_sqr);
        phase.drop_objection(this);
    endtask

endclass



class write_operation_porta_test extends base_test;
    `uvm_component_utils(write_operation_porta_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
    endtask

    virtual task main_phase(uvm_phase phase);
        write_operation_porta_vseq vseq = write_operation_porta_vseq::type_id::create("vseq");
        phase.raise_objection(this);
        vseq.reg_model = env.reg_blk;
        vseq.start(env.v_sqr);
        phase.drop_objection(this);
    endtask

endclass

class basic_porta_write_portb_read_test extends base_test;

  `uvm_component_utils(basic_porta_write_portb_read_test)

  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
  endtask

  virtual task main_phase(uvm_phase phase);
      basic_porta_write_portb_read_vseq vseq = basic_porta_write_portb_read_vseq::type_id::create("vseq");
      phase.raise_objection(this);
      vseq.reg_model = env.reg_blk;
      vseq.start(env.v_sqr);
      phase.drop_objection(this);
  endtask

endclass

class fill_memory_porta_write_portb_read_test extends base_test;

  `uvm_component_utils(fill_memory_porta_write_portb_read_test)

  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
  endtask

  virtual task main_phase(uvm_phase phase);
      fill_memory_porta_write_portb_read_vseq vseq = fill_memory_porta_write_portb_read_vseq::type_id::create("vseq");
      phase.raise_objection(this);
      vseq.reg_model = env.reg_blk;
      vseq.start(env.v_sqr);
      phase.drop_objection(this);
  endtask

endclass

class simultaneous_write_different_address_test extends base_test;

  `uvm_component_utils(simultaneous_write_different_address_test)

  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
  endtask

  virtual task main_phase(uvm_phase phase);
      simultaneous_write_different_address_vseq vseq = simultaneous_write_different_address_vseq::type_id::create("vseq");
      phase.raise_objection(this);
      vseq.reg_model = env.reg_blk;
      vseq.start(env.v_sqr);
      phase.drop_objection(this);
  endtask

endclass


class simultaneous_write_same_address_test extends base_test;

  `uvm_component_utils(simultaneous_write_same_address_test)

  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
  endtask

  virtual task main_phase(uvm_phase phase);
      simultaneous_write_same_address_vseq vseq = simultaneous_write_same_address_vseq::type_id::create("vseq");
      phase.raise_objection(this);
      vseq.reg_model = env.reg_blk;
      vseq.start(env.v_sqr);
      phase.drop_objection(this);
  endtask

endclass


class simultaneous_write_read_same_address_test extends base_test;

  `uvm_component_utils(simultaneous_write_read_same_address_test)

  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
  endtask

  virtual task main_phase(uvm_phase phase);
      simultaneous_write_read_same_address_vseq vseq = simultaneous_write_read_same_address_vseq::type_id::create("vseq");
      phase.raise_objection(this);
      vseq.reg_model = env.reg_blk;
      vseq.start(env.v_sqr);
      phase.drop_objection(this);
  endtask

endclass

