class basic_read_write_single_port extends generator;

    int current_address;

    // Constructor
    function new(mailbox gen2drv);
        super.new(gen2drv);
        burst_n_size = 8;  
    endfunction

    // Override the default run task 
    virtual task run();
        no_transactions = TestRegistry::get_int("NoOfTransactions", 100);
        current_address = 0;  
        $display("[%0t] basic_read_write_single_port GEN: Starting test with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            configure_transaction(pkt);
        end
    endtask

    virtual task write_transaction();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b1;  // Force write operations
        }) begin
            $error("[%0t] basic_read_write_single_port GEN: Failed to randomize transaction", $time);
        end
        
        current_address = pkt.addr;
        gen2drv.put(pkt);
        $display("[%0t] basic_read_write_single_port GEN: Generated write transaction at address %0h", $time, current_address);
    endtask

    // virtual task random_delay();
    //     int delay_cycles = $urandom_range(1, 5);
    //     repeat (delay_cycles) @(posedge vif.clk);
    // endtask

    virtual task read_transaction();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b0; 
            pkt.addr == current_address;
        }) begin
            $error("[%0t] basic_read_write_single_port GEN: Failed to randomize read transaction", $time);
        end
        
        gen2drv.put(pkt);
        $display("[%0t] basic_read_write_single_port GEN: Generated read transaction at address %0h", $time, current_address);
    endtask

    virtual function void configure_transaction(transaction pkt);
        super.configure_transaction(pkt); 
            write_transaction();
            // random_delay();
            read_transaction(); 
        
    endfunction

    function void set_burst_n_size(int size);
        burst_n_size = size;
    endfunction

endclass
