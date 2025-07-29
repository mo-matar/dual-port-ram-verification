class generator;
    mailbox gen2drv;
    event gen_done;
    int no_transactions;
    transaction pkt;
    virtual port_if vif;
    int current_address;
    bit active;
    string port_name;
    typedef enum { READ, WRITE, WRITE_READ, DISABLED } transaction_type;
    int count;
    int transaction_index;

    function new(string port_name = "port_a");
        this.port_name = port_name;
        this.active = 1;
    endfunction

    virtual task run();
      count = 0;
        $display("Running generator on %s...", port_name);
        $display("[%0t] GEN: Port %s is %s", $time, port_name, active ? "active" : "inactive");

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
            delay == 5;
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

endclass

