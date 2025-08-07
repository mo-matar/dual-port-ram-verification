class generator;
    mailbox gen2drv;
    event gen_done;
    int no_transactions;
    transaction pkt;
    virtual port_if vif;
    int sequential_addr = 0;
    int fill_address = 0;
  	event mem_filled;
    bit active;
  int current_address;
    string port_name;
    typedef enum { READ, WRITE, WRITE_READ, DISABLED } transaction_type;
    int count;
    int transaction_index;
  event reset_system;
      logic [`ADDR_WIDTH-1:0] addr_q[$]; //same addresses for both ports
          event hold_reset;



    function new(string port_name = "port_a");
        this.port_name = port_name;
        this.active = 1;
    endfunction

        virtual task set_addresses(logic [`ADDR_WIDTH-1:0] addr_q[$]);
        this.addr_q = addr_q;
    endtask

    virtual task run();
      
      count = 0;
        $display("Running generator on %s...", port_name);
        $display("[%0t] GEN: Port %s is %s", $time, port_name, active ? "active" : "inactive");
              if(!active) return;


        no_transactions = TestRegistry::get_int("NoOfTransactions");
        current_address = 0;  
        repeat(no_transactions) begin
          count++;
          $display("[%0t] GEN: Generating transaction %0d", $time, count);
            write_transaction();
            read_transaction();
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
        pkt.display(port_name, "GEN write");
        gen2drv.put(pkt);
      
    endtask

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
    endtask


        virtual task read_all_memory();
        pkt = new();
        
        if (!pkt.randomize() with {
            pkt.we == 1'b0;  // Force read operations
            pkt.delay == 1;
        }) begin
            $error("[%0t] GEN: Failed to randomize transaction", $time);
        end
        
        pkt.addr = sequential_addr;
        pkt.display(port_name, "GEN read all memory");
        gen2drv.put(pkt);
        sequential_addr++;

        endtask

        virtual task fill_memory();
          pkt = new();
          if (!pkt.randomize() with {
              pkt.we == 1'b1;  // Force write operations
              pkt.addr == fill_address;
              pkt.delay == 0;
              pkt.data == 16'hff;
          }) begin
              $error("[%0t] GEN: Failed to randomize fill memory transaction", $time);
          end
          pkt.display(port_name, "GEN fill memory");
          gen2drv.put(pkt);
          fill_address++;
          if (fill_address >= `MEM_DEPTH) begin
              fill_address = 0; // Reset fill address after reaching memory depth
          end
    endtask

endclass

