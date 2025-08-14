class default_mem_value_test extends base_test;

  `uvm_component_utils(default_mem_value_test)

  function new(string name, uvm_component parent);
      super.new(name, parent);
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
  endtask

  virtual task main_phase(uvm_phase phase);
  
      default_mem_value_vseq vseq = default_mem_value_vseq::type_id::create("vseq");
      
      phase.raise_objection(this);
      vseq.reg_model = env.reg_blk;
      vseq.start(env.v_sqr);
      phase.drop_objection(this);
  endtask

  endclass

