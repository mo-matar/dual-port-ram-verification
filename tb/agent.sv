class agent;
    generator gen;
    mailbox gen2drv;
    mailbox mon2scb;
    driver drv;
    monitor mon;
    virtual port_if vif;
    virtual port_if other_vif;
    string port_name;
  event reset_system;


    function void build();
        // connect interfaces
        $display("Building agent on %s...", port_name);
        drv.vif = vif;
        mon.vif = vif;
        mon.other_vif = other_vif;
        gen.vif = vif;

        // connect mailboxes
        gen.gen2drv = this.gen2drv;
        gen.reset_system = this.reset_system;
        mon.mon2scb = this.mon2scb;
        drv.gen2drv = this.gen2drv;
    endfunction

    function new(string port_name = "port_a");
              this.port_name = port_name;
      this.gen2drv = new(1);

        this.gen = new(port_name); 
        this.drv = new(port_name);
        this.mon = new(port_name);
    endfunction
    
    function void set_generator(generator g);
        g.reset_system = this.reset_system;
        this.gen = g;
        
    endfunction

    task run();
        $display("Running agent on %s...", port_name);
        gen.reset_system = this.reset_system;
        fork
           gen.run();
           drv.run();
           mon.run();
        join_any;
    endtask
endclass

