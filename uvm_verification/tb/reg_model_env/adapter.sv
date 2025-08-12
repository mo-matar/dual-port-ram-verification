class dpram_adapter extends uvm_reg_adapter;

    `uvm_object_utils(dpram_adapter)
    static int delay = 0;

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
        tr.data = rw.data;
        tr.delay = this.delay;
        // if(tr.op == 1'b0) tr.rd_data = rw.data;
        `uvm_info("DPRAM_ADAPTER", $sformatf("Converted reg item to bus item: addr=%0h, data=%0h", tr.addr, tr.data), UVM_MEDIUM)

        return tr;
    endfunction

    // bus2reg method

    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);


        dpram_item tr;
        if (!$cast(tr, bus_item)) begin
            `uvm_fatal("CONVERT DPRAM_ITEM 2 UVM_SEQ_ITEM", "bus item is not of type dpram_item ")
        end
      `uvm_info("!!DPRAM_ADAPTER", $sformatf("current bus item that will be converted %s", bus_item.convert2string()), UVM_MEDIUM)

        rw.kind = (tr.op == 1'b1) ? UVM_WRITE : UVM_READ;
        rw.addr = tr.addr;
        rw.data = tr.data;
        rw.status = UVM_IS_OK;
        `uvm_info("DPRAM_ADAPTER", $sformatf("Converted bus item to reg item: addr=%0h, data=%0h", rw.addr, rw.data), UVM_MEDIUM)

        endfunction

endclass
