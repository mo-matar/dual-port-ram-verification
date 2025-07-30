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

// Fill memory through Port A and read through Port B
class fill_memory_porta_write_portb_read_gen_a extends generator;
    event mem_filled;
    bit [$clog2(`DEPTH)-1:0] current_addr = '{default: 0};

    function new();
        super.new();
    endfunction

    virtual task write_transaction();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b1;  // Force write operations
            pkt.delay == 0;
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
        
        pkt.addr = current_addr; // Use current address for writing
        current_addr++;
        pkt.display(port_name, "GEN write");
        gen2drv.put(pkt);

    endtask

    virtual task run();
        if(!active) return;

        no_transactions = `DEPTH; // Fill all memory locations
        $display("[%0t] GEN: Starting fill memory test on Port A with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            write_transaction();
        end

        // Signal that memory is filled
        -> mem_filled;


    endtask

endclass


class fill_memory_portb_write_porta_read_gen_b extends generator;
    event mem_filled;
    bit [$clog2(`DEPTH)-1:0] current_addr = '{default: 0};

    function new();
        super.new();
    endfunction

    virtual task read_transaction();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b0;  // Force read operations
            pkt.delay == 1;
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
        
        pkt.addr = current_addr; // Use current address for reading
        current_addr++;
        pkt.display(port_name, "GEN read");
        gen2drv.put(pkt);

    endtask

    virtual task run();
        if(!active) return;

        no_transactions = `DEPTH; // Read all memory locations
        $display("[%0t] GEN: Starting fill memory test on Port B with %0d transactions", $time, no_transactions);
      wait(mem_filled.triggered); // Wait for memory to be filled by Port A
        repeat(no_transactions) begin
            read_transaction();
        end


    endtask

endclass

class B2B_transactions_porta_gen extends generator;
    function new();
        super.new();
    endfunction
  bit [`DEPTH-1: 0] current_addr = '{default: 0};

    virtual task read_all_memory();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b0;  // Force read operations
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
        
        pkt.addr = current_addr;
        pkt.display(port_name, "GEN read all memory");
        gen2drv.put(pkt);
        current_addr++;

        endtask

    

    virtual task run();
        if(!active) return;

        no_transactions = TestRegistry::get_int("NoOfTransactions");
        $display("[%0t] GEN: Starting B2B transactions test on Port A with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            write_transaction();
            read_transaction();
        end
      $display("begin delay of 100!!!");
        #100;
              $display("[%0t] ######################GEN: Starting read all memory test on Port A##############################", $time);
      
       

        repeat(`DEPTH) begin
            read_all_memory();
        end
      
    endtask

endclass


class default_mem_value_gen extends generator;
    function new(string port_name = "port_a");
        super.new(port_name);
    endfunction

    virtual task run();
        if(!active) return;

        no_transactions = TestRegistry::get_int("NoOfTransactions");
        $display("[%0t] GEN: Starting default memory value test on Port A with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            read_transaction();
        end
    endtask
    endclass


class reset_gen extends generator;
    virtual port_if vif;
    rand integer rst_delay;
    bit [$clog2(`DEPTH)-1:0] current_addr = '{default: 0};
    function new();
        super.new(port_name);
    endfunction

    virtual task run();
        if(!active) return;

        fork
            begin
                no_transactions = TestRegistry::get_int("NoOfTransactions");
                $display("[%0t] GEN: Starting B2B transactions test on Port A with %0d transactions", $time, no_transactions);

                repeat(no_transactions) begin
                    write_transaction();
                    read_transaction();
                end
            end

            begin
                rst_delay = $urandom_range(16, 28); // Random reset delay
                $display("[%0t] GEN: Applying reset after %0d clock cycles", $time, rst_delay);
                repeat(rst_delay) @(posedge vif.clk);
                -> reset_system;
                $display("[%0t] GEN: Reset asserted", $time);               
            end

            
        join_any
        disable fork; 
        #50;


        //ensure memory has been reset
        $display("[%0t] GEN: Reset complete, ensuring memory is reset to default values", $time);
        repeat(`DEPTH) begin
            read_all_memory();
        end

        
    endtask


    virtual task read_all_memory();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b0;  // Force read operations
            pkt.delay == 1;
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
        
        pkt.addr = current_address;
        pkt.display(port_name, "GEN read all memory");
        gen2drv.put(pkt);
        current_addr++;

        endtask



endclass