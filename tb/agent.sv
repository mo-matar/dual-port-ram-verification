class agent;
    generator gen;
    driver drv;
    monitor mon;
    virtual port_if vif;

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
    endtask
endclass
