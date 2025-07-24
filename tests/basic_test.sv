class test;
    env e0;
    string test_name;
    
    function new(string test_name = "base_test");
        e0 = new();
        this.test_name = test_name;
    endfunction

    virtual task run();
        TestRegistry::set_int("NoOfTransactions", 1000);
        
        configure_test();
        
        fork
            e0.run();
        join_none
        #1000;
        //e0.report_coverage();
    endtask
    
    virtual task configure_test();

    endtask
endclass