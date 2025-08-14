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