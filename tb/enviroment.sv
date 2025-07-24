class env;

  agent agent_a;
  agent agent_b;
  scoreboard sb;
  mailbox gen2drv_a;
  mailbox gen2drv_b;
  mailbox mon2scb_a;
  mailbox mon2scb_b;
  virtual port_if vif_a;
  virtual port_if vif_b;

  //!coverage collector???


  function build();
    // connect interfaces
    agent_a.vif = vif_a;
    agent_b.vif = vif_b;

    agent_b.gen2drv = this.gen2drv_b;
    agent_a.gen2drv = this.gen2drv_a;
    agent_b.mon2scb = this.mon2scb_b;
    agent_a.mon2scb = this.mon2scb_a;

    agent_a.build();
    agent_b.build();

    //! will there be two mailboxes for the scoreboard?
    //YES
    sb.mon2scb_a = mon2scb_a;
    sb.mon2scb_b = mon2scb_b;

  endfunction

  function new();
    gen2drv_a = new();
    gen2drv_b = new();
    mon2scb_a = new();
    mon2scb_b = new();
    agent_a = new();
    agent_b = new();
    sb = new();
  endfunction


  task run();
    build();
    fork
      agent_a.run();
      agent_b.run();
      sb.run();
    join_any
  endtask
endclass