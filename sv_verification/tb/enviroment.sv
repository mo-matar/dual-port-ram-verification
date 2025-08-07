class env;

  agent agent_a;
  agent agent_b;
  scoreboard sb;
//   mailbox gen2drv_a;
//   mailbox gen2drv_b;
  mailbox mon2scb_a;
  mailbox mon2scb_b;
  virtual port_if vif_a;
  virtual port_if vif_b;
  
  event reset_system;

  //!coverage collector???


  function void build();
    // connect interfaces
    $display("Building environment...");
    agent_a.vif = this.vif_a;
    agent_b.vif = this.vif_b;
    agent_a.other_vif = this.vif_b;
    agent_b.other_vif = this.vif_a;
    sb.vif_a = this.vif_a;
    sb.vif_b = this.vif_b;
    // connect mailboxes
    agent_b.mon2scb = this.mon2scb_b;
    agent_a.mon2scb = this.mon2scb_a;
    
    sb.mon2scb_a = this.mon2scb_a;
    sb.mon2scb_b = this.mon2scb_b;

    agent_a.build();
    agent_b.build();
    agent_a.reset_system = reset_system;
    agent_b.reset_system = reset_system;
    

    sb.mon2scb_a = mon2scb_a;
    sb.mon2scb_b = mon2scb_b;

  endfunction

  function new();

    this.agent_a = new("port_a");
    this.agent_b = new("port_b");
    this.mon2scb_a = new();
    this.mon2scb_b = new();
    

    this.sb = new();
  endfunction

 task final_report();
    $display("Final Report:");
    sb.scb_summary();
  endtask

  task run();
    $display("Running environment...");
    
    fork
      begin
        fork
          agent_a.run();
          agent_b.run();
         // #200 ->reset_system;
    	join
        
      end
      
      
      sb.run();
    join_any
  endtask
endclass