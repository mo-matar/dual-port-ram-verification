class driver;
    mailbox gen2drv;
    // event drv_done;
    // int no_transactions;
    transaction packet;
    virtual port_if vif;

    // function new(mailbox gen2drv);
    //     this.gen2drv = gen2drv;
    // endfunction

    task run();
        forever begin
            transaction pkt;
            $display("Driver: Waiting for transaction...");
            vif.data <= pkt.data;
            vif.addr <= pkt.addr;
            vif.we <= pkt.we;
            vif.valid <= 1'b1;
            @(posedge vif.clk iff vif.ready==1);
                // wait(vif.ready);
            if(pkt.delay > 0) begin
                vif.valid <= 1'b0;
                repeat(pkt.delay)begin
                     @(posedge vif.clk);
                end
            end
            



            // might need an event here to signal completion for generator
            //-> drv_done;
        end
    endtask

    
    

endclass





