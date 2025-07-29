class agent;
    generator gen;
    mailbox gen2drv;
    mailbox mon2scb;
    driver drv;
    monitor mon;
    virtual port_if vif;
    string port_name;


    function void build();
        // connect interfaces
        $display("Building agent on %s...", port_name);
        drv.vif = vif;
        mon.vif = vif;

        // connect mailboxes
        gen.gen2drv = this.gen2drv;
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
        this.gen = g;
    endfunction

    task run();
        $display("Running agent on %s...", port_name);
        fork
           gen.run();
           drv.run();
           mon.run();
        join_any;
    endtask
endclass

