class generator;

    mailbox gen2drv;
    event gen_done;
    int no_transactions;
    transaction pkt;
    virtual port_if vif;
    int current_address;
    bit active;
    string port_name;
    typedef enum { READ, WRITE, WRITE_READ } transaction_type;
  int count;

    function new(string port_name = "port_a");
        this.port_name = port_name;
        this.active = 1;
    endfunction

    virtual task run();
      count = 0;
        $display("Running generator on %s...", port_name);
        //print the status of the current port
        $display("[%0t] GEN: Port %s is %s", $time, port_name, active ? "active" : "inactive");
        //if(!active) return;

        no_transactions = TestRegistry::get_int("NoOfTransactions");
        current_address = 0;  
        $display("[%0t] GEN: Starting test with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
          count++;
          $display("[%0t] GEN: Generating transaction %0d", $time, count);
            write_transaction();
            read_transaction();
            // configure_transaction(pkt);
        end
      $display("~~~~~~~~~~~~~GEN END~~~~~~~~~~~~~~~~~~~~~~");

    endtask

    virtual task write_transaction();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b1;  // Force write operations
            delay == 5;
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
        
        current_address = pkt.addr;
        pkt.display(port_name, "GEN write");
        gen2drv.put(pkt);
      pkt.display("GEN write");
//       $display("[T=%0t] GEN: Generated write transaction at address %0h", $time, current_address);
      
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
          $error("[T=%0t] GEN: Failed to randomize read transaction", $time);
        end
        
        pkt.display(port_name, "GEN read");
        gen2drv.put(pkt);
      $display("[T=%0t] GEN: Generated read transaction at address %0h", $time, current_address);
    endtask

//     virtual function void configure_transaction(transaction pkt);
//         //super.configure_transaction(pkt); 
//             write_transaction();
//             // random_delay();
//             read_transaction(); 
        
//     endfunction

endclass

