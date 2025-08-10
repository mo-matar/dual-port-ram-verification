// Basic DPRAM sequences


class dpram_wr_rd_seq extends uvm_sequence#(dpram_item);
    `uvm_object_utils(dpram_wr_rd_seq)
    logic [`MEM_DEPTH-1:0] current_addr;
    rand int NoTrans;
    constraint NoTrans_c {
        NoTrans >= 10;
        NoTrans <= 20;
    }


    function new(string name="dpram_wr_rd_seq");
        super.new(name);
    endfunction

    virtual task body();
        dpram_item it;
        repeat(NoTrans) begin
        `uvm_create(it);
        `uvm_rand_send_with(it, { it.op == 1; })
        current_addr = it.addr; // Store the address for the read operation

        `uvm_create(it);
        `uvm_rand_send_with(it, { it.op == 0; it.addr == current_addr; })
        end

        // // Write
        // it = dpram_item::type_id::create("it_w");
        // start_item(it);
        // if (!it.randomize() with { it.op == 1 }) begin
        //     `uvm_error(get_type_name(), "Randomize write item failed")
        // end
        // current_addr = it.addr; // Store the address for the read operation
        // finish_item(it);
        // // Read same address
        // it = dpram_item::type_id::create("it_r");
        // start_item(it);
        // if (!it.randomize() with { it.addr == addr; it.op == 0; it.delay == 0; }) begin
        //     `uvm_error(get_type_name(), "Randomize read item failed")
        // end
        // finish_item(it);
    endtask
endclass
