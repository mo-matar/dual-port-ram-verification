class dpram_adapter extends uvm_reg_adapter;

    `uvm_object_utils(dpram_adapter)

    //constructor
    function new(string name = "dpram_adapter");
        super.new(name);
    endfunction

    // reg2bus method

    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

        dpram_item tr;
        tr = dpram_item::type_id::create("tr");

        tr.op = (rw.kind == UVM_WRITE) ? 1'b1 : 1'b0;
        tr.addr = rw.addr;
        if(tr.op == 1'b1) tr.data = rw.data;
        // if(tr.op == 1'b0) tr.rd_data = rw.data;

        return tr;
    endfunction

    // bus2reg method

    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

        dpram_item tr;
        if (!$cast(tr, bus_item)) begin
            `uvm_fatal("CONVERT DPRAM_ITEM 2 UVM_SEQ_ITEM", "bus item is not of type dpram_item ")
        end

        rw.kind = (tr.op == 1'b1) ? UVM_WRITE : UVM_READ;
        rw.addr = tr.addr;
        rw.data = tr.data;
        rw.status = UVM_IS_OK;
       
        endfunction

endclass
