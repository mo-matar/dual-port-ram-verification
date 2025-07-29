class driver;
    mailbox gen2drv;
    transaction pkt;
    virtual port_if vif;
    string port_name;


    function new(string port_name = "port_a");
        this.port_name = port_name;
    endfunction

    task run();
        forever begin
            gen2drv.get(pkt);
            vif.data <= pkt.data;
            vif.addr <= pkt.addr;
            vif.we <= pkt.we;
            vif.valid <= 1'b1;
            pkt.display(port_name, "DRV before delay");
            @(posedge vif.clk iff vif.ready==1);
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
            pkt.display(port_name, "DRV after delay");
        end
    endtask

    
    

endclass





