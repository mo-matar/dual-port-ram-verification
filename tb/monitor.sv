class monitor;

    virtual port_if vif;
    mailbox mon2scb;
    event mon_done;

    //coverage collector???

    task run();
        $display("Monitor: Initializing...");

        forever begin
            transaction pkt;
            @(posedge vif.clk iff (vif.ready==1 && vif.valid == 1));
        
            pkt = new;
            pkt.addr = vif.addr;
            pkt.we = vif.we;
            if(vif.we) begin
                pkt.data = vif.data;
            end else begin
                pkt.data = vif.q;
            end
            pkt.data = vif.q;
            pkt.rst_n = vif.rst_n;

            pkt.display("MON");
            mon2scb.put(pkt);
        end

    endtask
        

endclass