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