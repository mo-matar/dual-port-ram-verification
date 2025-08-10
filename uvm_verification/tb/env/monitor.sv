class dpram_monitor extends uvm_monitor;
    `uvm_component_utils(dpram_monitor)

    dpram_item item;
    uvm_analysis_port #(dpram_item) analysis_port;
    virtual port_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual port_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOCONFIG", "No virtual interface found for vif")
        end
        analysis_port = new("analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            // Wait for an item to be available
            @(posedge vif.clk iff (vif.ready==1 && vif.valid == 1));
            item = new;
            item.addr = vif.addr;
            item.op = vif.op;
            if (vif.op == 1) begin
                item.data = vif.wr_data;
              `uvm_info("MON WRITE", item.convert2string(), UVM_MEDIUM);
            end else begin
                item.data = vif.rd_data; // Assuming rd_data is valid for read operations
              `uvm_info("MON READ", item.convert2string(), UVM_MEDIUM);
            end
            analysis_port.write(item);

        end
    endtask
endclass