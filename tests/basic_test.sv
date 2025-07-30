import project_pkg::*;

class test;
    env e0;
    event reset_system;
    string test_name;
    
    function new(string test_name = "base_test");
      $display("object created!!!");
        e0 = new();
        this.test_name = test_name;
            e0.reset_system = this.reset_system;

    endfunction

    virtual task run();
      $display("Running test!!");
      TestRegistry::set_int("NoOfTransactions",100);
        
        configure_test();
        e0.build();
        
        fork
            e0.run();
          join

      
        #100;
      e0.final_report();
        $finish;
        //e0.report_coverage();
    endtask

    virtual task final_report();
        e0.final_report();
    endtask
    
    virtual task configure_test();

    endtask
endclass