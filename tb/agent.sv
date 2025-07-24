class agent;
    generator gen;
    mailbox gen2drv;
    mailbox mon2scb;
    driver drv;
    monitor mon;
    virtual port_if vif;


    function build();
        // connect interfaces
        gen.vif = vif;
        drv.vif = vif;
        mon.vif = vif;

        // connect mailboxes
        gen.gen2drv = this.gen2drv;
        mon.mon2scb = this.mon2scb;
        drv.gen2drv = this.gen2drv;
    endfunction

    function new();
        gen = new(); 
        drv = new();
        mon = new();
    endfunction
    
    // function void set_generator(generator g);
    //     gen = g;
    //     gen.set_mailbox(drv.gen2drv);
    // endfunction

    task run();
        fork
            gen.run();
            drv.run();
            mon.run();
        join_none
    endtask
endclass

