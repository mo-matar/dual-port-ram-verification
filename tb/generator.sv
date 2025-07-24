class generator;

    mailbox gen2drv;
    event gen_done;
    int no_transactions;
    transaction pkt;
    virtual port_if vif;
    int current_address;
    bit active;

    // Constructor
    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction


    
    virtual task run();
        if(!active) return;

        no_transactions = TestRegistry::get_int("NoOfTransactions", 100);
        current_address = 0;  
        $display("[%0t] GEN: Starting test with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            write_transaction();
            read_transaction();
            // configure_transaction(pkt);
        end
    endtask

    virtual task write_transaction();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b1;  // Force write operations
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
        
        current_address = pkt.addr;
        gen2drv.put(pkt);
        $display("[%0t] GEN: Generated write transaction at address %0h", $time, current_address);
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
            $error("[%0t] GEN: Failed to randomize read transaction", $time);
        end
        
        gen2drv.put(pkt);
        $display("[%0t] GEN: Generated read transaction at address %0h", $time, current_address);
    endtask

    virtual function void configure_transaction(transaction pkt);
        super.configure_transaction(pkt); 
            write_transaction();
            // random_delay();
            read_transaction(); 
        
    endfunction

endclass


// class generator;
//     mailbox gen2drv;
//     bit active;
    
//     function new();
//         active = 1; // By default, generator is active
//     endfunction
    
//     virtual task run();
//         if(!active) return;
//         // Base generation logic to be overridden by child classes
//     endtask
    
//     // Common utility functions that all generators might use
//     virtual function void set_mailbox(mailbox gen2drv);
//         this.gen2drv = gen2drv;
//     endfunction
// endclass

// class specific_generator extends generator;
//     event gen_done;
//     int no_transactions;
//     transaction pkt;
//     virtual port_if vif;
//     int current_address;

//     // Constructor
//     function new(mailbox gen2drv);
//         super.new();
//         this.gen2drv = gen2drv;
//     endfunction

//     virtual task run();
//         no_transactions = TestRegistry::get_int("NoOfTransactions", 100);
//         current_address = 0;  
//         $display("[%0t] GEN: Starting test with %0d transactions", $time, no_transactions);

//         repeat(no_transactions) begin
//             write_transaction();
//             read_transaction();
//             // configure_transaction(pkt);
//         end
//     endtask

//     virtual task write_transaction();
//         pkt = new();
        
//         if (!pkt.randomize() with {
//             pkt.we == 1'b1;  // Force write operations
//         }) begin
//             $error("[%0t] GEN: Failed to randomize transaction", $time);
//         end
        
//         current_address = pkt.addr;
//         gen2drv.put(pkt);
//         $display("[%0t] GEN: Generated write transaction at address %0h", $time, current_address);
//     endtask

//     // virtual task random_delay();
//     //     int delay_cycles = $urandom_range(1, 5);
//     //     repeat (delay_cycles) @(posedge vif.clk);
//     // endtask

//     virtual task read_transaction();
//         pkt = new();
        
//         if (!pkt.randomize() with {
//             pkt.we == 1'b0; 
//             pkt.addr == current_address;
//         }) begin
//             $error("[%0t] GEN: Failed to randomize read transaction", $time);
//         end
        
//         gen2drv.put(pkt);
//         $display("[%0t] GEN: Generated read transaction at address %0h", $time, current_address);
//     endtask

//     virtual function void configure_transaction(transaction pkt);
//         super.configure_transaction(pkt); 
//             write_transaction();
//             // random_delay();
//             read_transaction(); 
        
//     endfunction
// endclass


// class generator;

//     mailbox gen2drv;
//     event gen_done;
//     int no_transactions;
//     transaction pkt;
//     virtual port_if vif;
//     int current_address;

//     // Configuration parameters
//     typedef enum {WRITE_ONLY, READ_ONLY, WRITE_READ, RANDOM} transaction_type_e;
//     transaction_type_e transaction_type;
//     bit active;
//     int num_transactions;
//     int address_range_start;
//     int address_range_end;
    
//     // Constructor
//     function new(mailbox gen2drv);
//         this.gen2drv = gen2drv;
//     endfunction


    
//     virtual task run();
//         if (!active) return;
        
//         case(transaction_type)
//             WRITE_ONLY: generate_write_transactions();
//             READ_ONLY: generate_read_transactions();
//             WRITE_READ: generate_write_read_transactions();
//             RANDOM: generate_random_transactions();
//         endcase
//     endtask

//     virtual task write_transaction();
//         pkt = new();
        
//         if (!pkt.randomize() with {
//             pkt.we == 1'b1;  // Force write operations
//         }) begin
//             $error("[%0t] GEN: Failed to randomize transaction", $time);
//         end
        
//         current_address = pkt.addr;
//         gen2drv.put(pkt);
//         $display("[%0t] GEN: Generated write transaction at address %0h", $time, current_address);
//     endtask

//     // virtual task random_delay();
//     //     int delay_cycles = $urandom_range(1, 5);
//     //     repeat (delay_cycles) @(posedge vif.clk);
//     // endtask

//     virtual task read_transaction();
//         pkt = new();
        
//         if (!pkt.randomize() with {
//             pkt.we == 1'b0; 
//             pkt.addr == current_address;
//         }) begin
//             $error("[%0t] GEN: Failed to randomize read transaction", $time);
//         end
        
//         gen2drv.put(pkt);
//         $display("[%0t] GEN: Generated read transaction at address %0h", $time, current_address);
//     endtask

//     virtual function void configure_transaction(transaction pkt);
//         super.configure_transaction(pkt); 
//             write_transaction();
//             // random_delay();
//             read_transaction(); 
        
//     endfunction

//     // Implement the different transaction generation methods
//     virtual task generate_write_transactions();
//         no_transactions = TestRegistry::get_int("NoOfTransactions", 100);
//         current_address = 0;  
//         $display("[%0t] GEN: Starting WRITE_ONLY test with %0d transactions", $time, no_transactions);

//         repeat(no_transactions) begin
//             write_transaction();
//         end
//     endtask

//     virtual task generate_read_transactions();
//         no_transactions = TestRegistry::get_int("NoOfTransactions", 100);
//         current_address = 0;  
//         $display("[%0t] GEN: Starting READ_ONLY test with %0d transactions", $time, no_transactions);

//         repeat(no_transactions) begin
//             read_transaction();
//         end
//     endtask

//     virtual task generate_write_read_transactions();
//         no_transactions = TestRegistry::get_int("NoOfTransactions", 100);
//         current_address = 0;  
//         $display("[%0t] GEN: Starting WRITE_READ test with %0d transactions", $time, no_transactions);

//         repeat(no_transactions) begin
//             write_transaction();
//             read_transaction();
//         end
//     endtask

//     virtual task generate_random_transactions();
//         no_transactions = TestRegistry::get_int("NoOfTransactions", 100);
//         current_address = 0;  
//         $display("[%0t] GEN: Starting RANDOM test with %0d transactions", $time, no_transactions);

//         repeat(no_transactions) begin
//             if ($urandom_range(0, 1) == 0)
//                 write_transaction();
//             else
//                 read_transaction();
//         end
//     endtask

// endclass