// // `include "memory_defines.sv"
// `define START_ADDR 0
// `define END_ADDR (START_ADDR + `DEPTH - 1)
class scoreboard;
    mailbox mon2scb_a;
    mailbox mon2scb_b;
    transaction pkt_a, pkt_b;
    int pass_a, fail_a, pass_b, fail_b;
    virtual port_if vif_a, vif_b;
    event reset_system;
    bit is_reset = 0;
    event hold_reset;


   bit [0:`DEPTH-1] mem_ref [bit [`WIDTH-1:0]] = '{default: 0};

    function void reset_memory();
        $display("Resetting memory reference...");
        for (int i = 0; i < `DEPTH; i++) begin
            this.mem_ref[i] = '0;
        end
    endfunction



    task scb_summary();
        $display("Scoreboard Summary:");
        $display("Port A: %0d Pass, %0d Fail", pass_a, fail_a);
        $display("Port B: %0d Pass, %0d Fail", pass_b, fail_b);
        $display("Total Pass: %0d, Total Fail: %0d", pass_a + pass_b, fail_a + fail_b);
    endtask



    function int address_is_legal(int addr);
      return (addr >= 0 && addr < `DEPTH);
    endfunction

      task automatic run();

        fork
            forever begin
              if(is_reset) continue;
                mon2scb_a.get(pkt_a);
if(!TestRegistry::get_int("Disabledisplay"))
                $display("time got pkt_a: %0t", $time);
                pkt_a.display("port_a", "MBX received");
                if (pkt_a.we == 1) begin
                    if(!address_is_legal(pkt_a.addr)) begin
                                            if(!TestRegistry::get_int("Disabledisplay"))
                      $display("SCB: Illegal address %0h accessed on port A", pkt_a.addr);
                        //fail_a++;
                    end
                  if(!TestRegistry::get_int("Disabledisplay"))
                    $display("SCB A: Writing to ref at addr %0h with data %0h", pkt_a.addr, pkt_a.data);
                    mem_ref[pkt_a.addr] = pkt_a.data;
                    pkt_a.display("port_a", "SCB: written to ref");
                end
                else if (pkt_a.we == 0) begin
                    if (!address_is_legal(pkt_a.addr)) begin
                      if(!TestRegistry::get_int("Disabledisplay"))
                      $display("SCB: Illegal address %0h accessed on port A", pkt_a.addr);
                        //fail_a++;
                        
                    end
                                        if(!TestRegistry::get_int("Disabledisplay"))
                    $display("SCB A: Reading from ref at addr %0h with expected data %0h", pkt_a.addr, mem_ref[pkt_a.addr]);
                    if (mem_ref[pkt_a.addr] !== pkt_a.data) begin
//                       if(!TestRegistry::get_int("Disabledisplay"))
                      $display("%0t SCB: Mismatch Error at addr %0h: expected %0h, got %0h", $time, pkt_a.addr, mem_ref[pkt_a.addr], pkt_a.data);
                        fail_a++;
                    end else begin
                      if(!TestRegistry::get_int("Disabledisplay"))
                      $display("SCB: Match Passed at addr %0h: data %0h", pkt_a.addr, pkt_a.data);
                        pass_a++;
                    end
                end

            end


            forever begin
              if(is_reset) continue;
                mon2scb_b.get(pkt_b);
              if(!TestRegistry::get_int("Disabledisplay"))
                $display("time got pkt_b: %0t", $time);
                pkt_b.display("port_b", "MBX received");
                if (pkt_b.we == 1) begin
                    if(!address_is_legal(pkt_b.addr)) begin
                      if(!TestRegistry::get_int("Disabledisplay"))
                        $display("%0t SCB: Illegal address %0h accessed on port B", $time, pkt_b.addr);
                        //fail_b++;
                    end
                  if(!TestRegistry::get_int("Disabledisplay"))
                    $display("SCB B: Writing to ref at addr %0h with data %0h", pkt_b.addr, pkt_b.data);
                    mem_ref[pkt_b.addr] = pkt_b.data;
                    pkt_b.display("port_b", "SCB: written to ref");
                end
                else if (pkt_b.we == 0) begin
                    if (!address_is_legal(pkt_b.addr)) begin
                      if(!TestRegistry::get_int("Disabledisplay"))
                      $display("SCB: Illegal address %0h accessed on port B", pkt_b.addr);
                        //fail_b++;
                        
                    end
                  if(!TestRegistry::get_int("Disabledisplay"))
                    $display("SCB B: Reading from ref at addr %0h with expected data %0h", pkt_b.addr, mem_ref[pkt_b.addr]);
                    
                    if (mem_ref[pkt_b.addr] !== pkt_b.data) begin
                      if(!TestRegistry::get_int("Disabledisplay"))
                        $display("%0t SCB: Mismatch Error at addr %0h: expected %0h, got %0h", $time, pkt_b.addr, mem_ref[pkt_b.addr], pkt_b.data);
                        fail_b++;
                    end else begin
                      if(!TestRegistry::get_int("Disabledisplay"))
                      $display("SCB: Match Passed at addr %0h: data %0h", pkt_b.addr, pkt_b.data);
                        pass_b++;
                    end
                end

            end
          
          forever begin
            @(reset_system)
            reset_memory();
          end
          
//           forever begin
            
//           end
          //thread to check write read collision and bypass write value
          forever begin
            if(is_reset) continue;
            @(posedge vif_a.clk);
            if((vif_a.valid && vif_b.valid) && (vif_a.addr == vif_b.addr) && (vif_a.we != vif_b.we)) begin
              if(vif_b.we && !vif_a.arbiter_b)begin
                mem_ref[vif_b.addr] = vif_b.data;
              end
              else if(vif_a.we && vif_b.arbiter_b) begin
                mem_ref[vif_a.addr] = vif_a.data;
              end

          end
          end
            
        join

    endtask




endclass
