class driver;
    mailbox gen2drv;
    // event drv_done;
    // int no_transactions;
    transaction pkt;
    virtual port_if vif;
    string port_name;

    // function new(mailbox gen2drv);
    //     this.gen2drv = gen2drv;
    // endfunction

    function new(string port_name = "port_a");
        this.port_name = port_name;
    endfunction

    task run();
//               $display("Running driver on %s...", port_name);

        forever begin
          gen2drv.get(pkt);
//             $display("Driver: Waiting for transaction...");
            vif.data <= pkt.data;
            vif.addr <= pkt.addr;
            vif.we <= pkt.we;
            vif.valid <= 1'b1;
            @(posedge vif.clk iff vif.ready==1);
                // wait(vif.ready);
            fork
                if(pkt.delay > 0) begin
                    vif.valid <= 1'b0;
                    repeat(pkt.delay) begin
                        @(posedge vif.clk);
                    end
                end
                
              @(negedge vif.rst_n);
            join_any
            disable fork;
            pkt.display(port_name, "DRV");
            



            // might need an event here to signal completion for generator
            //-> drv_done;
        end
              $display("~~~~~~~~~~~~~DRV END~~~~~~~~~~~~~~~~~~~~~~");
    endtask

    
    

endclass





