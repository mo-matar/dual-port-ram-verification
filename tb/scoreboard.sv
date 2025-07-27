class scoreboard;
    mailbox mon2scb_a;
    mailbox mon2scb_b;
    transaction pkt_a, pkt_b;


    bit [0:`DEPTH-1] mem_ref [bit [`WIDTH-1:0]];

    task run();
//         forever begin
//             // transaction pkt_a, pkt_b;
//             // // Wait for transactions from monitors
//             // fork
//             // if(try_get(pkt_a)) begin
//             //     mon2scb_a.get(pkt_a);
//             //     if (pkt_a.we == 1) begin
//             //         mem_ref[pkt_a.addr] = pkt_a.data;
//             //         pkt_a.display("SCB: packet A received");
//             //     end
//             //     else if (pkt_a.we == 0) begin
//             //         if (mem_ref[pkt_a.addr] !== pkt_a.data) begin
//             //             $display("SCB: Mismatch Error at addr %0d: expected %0h, got %0h", pkt_a.addr, mem_ref[pkt_a.addr], pkt_a.data);
//             //         end else begin
//             //             $display("SCB: Match Passed at addr %0d: data %0h", pkt_a.addr, pkt_a.data);
//             //         end
//             //     end
//             // end
            
//             // if(try_get(pkt_b)) begin
//             //     mon2scb_b.get(pkt_b);
//             //     if (pkt_b.we == 1) begin
//             //         mem_ref[pkt_b.addr] = pkt_b.data;
//             //         pkt_b.display("SCB: packet B received");
//             //     end
//             //     else if (pkt_b.we == 0) begin
//             //         if (mem_ref[pkt_b.addr] !== pkt_b.data) begin
//             //             $display("SCB: Mismatch Error at addr %0d: expected %0h, got %0h", pkt_b.addr, mem_ref[pkt_b.addr], pkt_b.data);
//             //         end else begin
//             //             $display("SCB: Match Passed at addr %0d: data %0h", pkt_b.addr, pkt_b.data);
//             //         end
//             //     end
//             // end
//             // join_any
//             // disable fork;
//         end
    endtask




endclass
