class monitor;

    virtual port_if vif;
    mailbox mon2scb;
    event mon_done;

    //coverage collector???

    task run();
        $display("Monitor: Initializing...");

        forever begin
            transaction pkt;
            @(posedge vif.clk);
        
            pkt = new;
            pkt.data = vif.data;
            pkt.addr = vif.addr;
            pkt.we = vif.we;
            pkt.valid = vif.valid;
            pkt.ready = vif.ready;
            pkt.q = vif.q;
            pkt.rst_n = vif.rst_n;

            pkt.display("MON");
            mon2scb.put(pkt);
        end

    endtask
        

endclass