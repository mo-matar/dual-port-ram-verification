
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

    // function build(mailbox gen2drv, mailbox mon2scb);
    //     gen.gen2drv = gen2drv;
    //     drv.gen2drv = gen2drv;
    //     mon.mon2scb = mon2scb;
    // endfunction

    task run();
        fork
            gen.run();
            drv.run();
            mon.run();
        join_none
    endtask
endclass
