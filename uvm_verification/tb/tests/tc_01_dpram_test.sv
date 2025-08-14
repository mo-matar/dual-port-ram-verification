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