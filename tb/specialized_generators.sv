// Write-Read generator for Port A
class basic_write_read_porta_gen extends generator;

    function new();
        super.new();
    endfunction


    virtual task run();
        $display("Running basic write-read generator for Port A...");
        
        if(!active) return;

        // Goal: verify basic write and read operations on port a
        // write random data and address
        // read from the same address
        // verify that read data equals previously written data
        no_transactions = TestRegistry::get_int("NoOfTransactions");
        $display("[%0t] GEN: Starting basic write-read test on Port A with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            write_transaction();
            read_transaction();
            //! @(drv_done);??????????????????
        end


    endtask
endclass

class basic_write_read_portb_gen extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(!active) return;

        // Goal: verify basic write and read operations on port b
        // write random data and address
        // read from the same address
        // verify that read data equals previously written data
        no_transactions = TestRegistry::get_int("NoOfTransactions");
        $display("[%0t] GEN: Starting basic write-read test on Port B with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            write_transaction();
            read_transaction();
            //! @(drv_done);??????????????????
        end
    endtask
endclass

class basic_porta_write_portb_read_gen_a extends generator;
    semaphore key;
   mailbox wrmb;
    logic [$clog2(`DEPTH)-1:0] addr_q[$]; //same addresses for both ports
    function new();
        super.new();
    endfunction

    virtual task set_addresses(logic [$clog2(`DEPTH)-1:0] addr_q[$]);
        this.addr_q = addr_q;
    endtask

    virtual task write_transaction();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b1;  // Force write operations
            pkt.delay == 1;
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
            pkt.addr = addr_q.pop_front(); // assign and remove the next address from the queue
		pkt.we = 1;

        pkt.display(port_name, "GEN write");

      gen2drv.put(pkt);
      
      //wrmb.put(pkt);

    endtask

    virtual task run();
        if(!active) return;
        no_transactions = TestRegistry::get_int("NoOfTransactions");
        $display("[%0t] GEN: Starting Port A write and Port B read test with %0d transactions", $time, no_transactions);
      key.get(1);

        repeat(no_transactions) begin
          #5;
                
            write_transaction();
          
        end
    endtask

endclass



class basic_portb_write_porta_read_gen_b extends generator;
    logic [$clog2(`DEPTH)-1:0] addr_q[$]; //same addresses for both ports
  	semaphore key;
    mailbox wrmb;
    function new();
        super.new();
    endfunction

    virtual task set_addresses(logic [$clog2(`DEPTH)-1:0] addr_q[$]);
        this.addr_q = addr_q;
    endtask

    virtual task read_transaction();
        pkt = new();
        
        
        if (!pkt.randomize() with {
            pkt.we == 1'b0;  // Force read operations
            pkt.delay == 1;
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
      
      pkt.addr = addr_q.pop_front(); // assign and remove the next address from the queue
     // wrmb.get(pkt);
     // pkt.data = $urandom_range(0, 255);
      	
        pkt.we = 0;
        
        pkt.display(port_name, "GEN read");
        gen2drv.put(pkt);

    endtask

    virtual task run();
        if(!active) return;
        no_transactions = TestRegistry::get_int("NoOfTransactions");
        $display("[%0t] GEN: Starting Port B write and Port A read test with %0d transactions", $time, no_transactions);

      repeat(no_transactions) begin
        #15;
        
            read_transaction();
        
        end
    endtask

endclass

