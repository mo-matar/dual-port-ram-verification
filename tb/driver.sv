class driver;
    mailbox gen2drv;
    event drv_done;
    int no_transactions;
    transaction packet;
    virtual port_if vif;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        forever begin
            transaction pkt;
            $display("Driver: Waiting for transaction...");
            gen2drv.get(pkt);
            @(posedge vif.clk);
            vif.data <= pkt.data;
            vif.addr <= pkt.addr;
            vif.we <= pkt.we;
            vif.valid <= pkt.valid;
            // vif.rst_n <= pkt.rst_n;
            if(pkt.valid) begin
                wait(vif.ready);
            end

            // might need an event here to signal completion for generator
            //-> drv_done;
        end
    endtask

    
    

endclass





