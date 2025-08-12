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
            `uvm_info("DPRAM_DRIVER", "before clock edge and ready", UVM_MEDIUM);
            @(posedge vif.clk iff vif.ready==1);
                        `uvm_info("DPRAM_DRIVER", "before delay", UVM_MEDIUM);
                                    item.data = vif.op ? vif.wr_data : vif.rd_data;
            seq_item_port.item_done(item);
            fork
                begin
                    repeat(item.delay) begin
                        vif.valid <= 1'b0;
                        @(posedge vif.clk);
                        `uvm_info("DPRAM_DRIVER", "after delay cycle", UVM_MEDIUM);

                    end
                    `uvm_info("DPRAM_DRIVER", "delay finished", UVM_MEDIUM);
                end
                begin
                    @(negedge vif.rst_n);
                    vif.valid <= 1'b0;
                end
            join_any
            disable fork;

            `uvm_info("DPRAM_DRIVER", item.convert2string(), UVM_MEDIUM);
        end
        endtask


endclass
