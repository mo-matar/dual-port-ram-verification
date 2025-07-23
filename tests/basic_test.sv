class test;
    env e0;

    function new();
        e0 = new();
    endfunction

    virtual task run();
        TestRegistry::set_int("NoOfTransactions", 1000);

        fork
            e0.run();
        join_none
        #1000;
        e0.report_coverage();
    endtask
endclass