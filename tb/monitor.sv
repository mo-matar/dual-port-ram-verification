class monitor;

    virtual port_if vif;
    virtual port_if other_vif;
    mailbox mon2scb;
    event mon_done;
    string port_name;
    transaction pkt;
    transaction early_pkt;

    //coverage collector???

    function new(string port_name = "port_a");
        this.port_name = port_name;
    endfunction

    task run();
      
        $display("Monitor: Initializing...");

        forever begin

//           if(vif.ready == 0 && vif.valid == 1) begin
//               early_pkt = new;
//               early_pkt.addr = vif.addr;
//               early_pkt.we = vif.we;
//               if(vif.we) begin
//                   early_pkt.data = vif.data;
//                 early_pkt.current_time = $time;
//               early_pkt.start_of_transaction = 1;
//               mon2scb.put(early_pkt);
//               end
           
              
//           end
            
            @(posedge vif.clk iff (vif.ready==1 && vif.valid == 1));

          //@(posedge vif.clk);
        
            pkt = new;
            pkt.addr = vif.addr;
            pkt.we = vif.we;
            pkt.current_time = $time;
            pkt.start_of_transaction = 0;
            if(vif.we) begin
                pkt.data = vif.data;
              pkt.display(port_name, "MON write");
            end else begin
              //@(posedge vif.clk);
                pkt.data = vif.q;
              pkt.display(port_name, "MON read");
            end
            mon2scb.put(pkt);
        end

    endtask
        

endclass