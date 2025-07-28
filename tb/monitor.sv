class monitor;

    virtual port_if vif;
    mailbox mon2scb;
    event mon_done;
    string port_name;

    //coverage collector???

    function new(string port_name = "port_a");
        this.port_name = port_name;
    endfunction

    task run();
//         $display("Monitor: Initializing...");

        forever begin
            transaction pkt;
            @(posedge vif.clk iff (vif.ready==1 && vif.valid == 1));
        
            pkt = new;
            pkt.addr = vif.addr;
            pkt.we = vif.we;
            if(vif.we) begin
                pkt.data = vif.data;
              pkt.display(port_name, "MON write");
            end else begin
                pkt.data = vif.q;
              pkt.display(port_name, "MON read");
            end
            //pkt.data = vif.q;
//             pkt.rst_n = vif.rst_n;

//             pkt.display(port_name, "MON");
            mon2scb.put(pkt);
        end
                    $display("~~~~~~~~~~~~~MON END~~~~~~~~~~~~~~~~~~~~~~");


    endtask
        

endclass