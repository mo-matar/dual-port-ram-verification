class dpram_driver extends uvm_driver #(dpram_item);
    `uvm_component_utils(dpram_driver)

    virtual port_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual port_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOCONFIG", "No virtual interface found for vif")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin 
                  dpram_item item;

            seq_item_port.get_next_item(item);
            vif.wr_data <= item.data;
            vif.addr <= item.addr;
            vif.op <= item.op;
            vif.valid <= 1'b1;
            @(posedge vif.clk iff vif.ready==1);
            fork
                begin
                    repeat(item.delay) begin
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
            seq_item_port.item_done();
        end
        endtask


endclass
