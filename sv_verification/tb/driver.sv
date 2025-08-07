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
              begin
                    repeat(pkt.delay) begin
                        vif.valid <= 1'b0;
                        @(posedge vif.clk);
                    end
                end
                begin
                    @(negedge vif.rst_n);
                    vif.valid <= 1'b0;  
                end
            join_any
            disable fork;
            pkt.display(port_name, "DRV after delay");
        end
    endtask

    
    

endclass





