`uvm_analysis_imp_decl(_a)
`uvm_analysis_imp_decl(_b)

// Define the global memory pool type
typedef uvm_pool#(longint unsigned, bit[`DATA_WIDTH-1:0]) dpram_mem_pool_t;

class dpram_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(dpram_scoreboard)

    uvm_analysis_imp_a#(dpram_item, dpram_scoreboard) m_analysis_imp_a;
    uvm_analysis_imp_b#(dpram_item, dpram_scoreboard) m_analysis_imp_b;

    // Global memory pool handle
    dpram_mem_pool_t global_mem_pool;

    int unsigned pass_a, fail_a, pass_b, fail_b;

    bit is_reset = 0;
    uvm_event reset_system_e;
    uvm_event hold_reset_e;

    virtual port_if vif_a;
    virtual port_if vif_b;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        m_analysis_imp_a = new("m_analysis_imp_a", this);
        m_analysis_imp_b = new("m_analysis_imp_b", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Get or create the global memory pool
        global_mem_pool = dpram_mem_pool_t::get_global_pool();
        
        // Set the global memory pool in config_db for access from anywhere
        // uvm_config_db#(dpram_mem_pool_t)::set(null, "*", "global_mem_pool", global_mem_pool);

        // Resolve reset events from the global event pool (optional)
        //uvm_event_pool pool = uvm_event_pool::get_global();
        //reset_system_e = pool.get("reset_system");
        //hold_reset_e  = pool.get("hold_reset");

        if (!uvm_config_db#(virtual port_if)::get(null, "uvm_test_top", "port_a_if", vif_a))
            `uvm_fatal("DPRAM_SCB", "vif_a not set via config_db")
        if (!uvm_config_db#(virtual port_if)::get(null, "uvm_test_top", "port_b_if", vif_b))
            `uvm_fatal("DPRAM_SCB", "vif_b not set via config_db")
    endfunction

    function void reset_memory();
        longint unsigned key;
        // Delete all entries from the global memory pool
        if (global_mem_pool.first(key)) begin
            do begin
                global_mem_pool.delete(key);
            end while (global_mem_pool.next(key));
        end
        `uvm_info("DPRAM_SCB", "Resetting global memory reference pool...", UVM_LOW)
    endfunction

    function bit address_is_legal(longint unsigned addr);
        return (addr < `MEM_DEPTH);
    endfunction

    function bit [`DATA_WIDTH-1:0] get_expected(longint unsigned addr);
        bit [`DATA_WIDTH-1:0] v = '0;
        if (global_mem_pool.exists(addr)) begin
            v = global_mem_pool.get(addr);
        end
        // If address doesn't exist, return default value (zero)
        return v;
    endfunction

    virtual function void write_a(dpram_item item);
        bit [`DATA_WIDTH-1:0] exp;
        `uvm_info("DPRAM_SCB", $sformatf("A: %s", item.convert2string()), UVM_MEDIUM)
        if (is_reset) return;

        if (item.op) begin
            if (!address_is_legal(item.addr))
                `uvm_warning("DPRAM_SCB", $sformatf("Illegal address on A: 0x%0h", item.addr))
            global_mem_pool.add(item.addr, item.data);
        end
        else begin
            exp = get_expected(item.addr);
            if (exp !== item.data) begin
                fail_a++;
                `uvm_error("DPRAM_SCB_MISMATCH", $sformatf("A addr 0x%0h exp 0x%0h got 0x%0h",
                                                          item.addr, exp, item.data))
            end
            else begin
                pass_a++;
                `uvm_info("DPRAM_SCB", $sformatf("A MATCH addr 0x%0h data 0x%0h", item.addr, item.data), UVM_LOW)
            end
        end
    endfunction

    // Process item from Agent B
    virtual function void write_b(dpram_item item);
        bit [`DATA_WIDTH-1:0] exp;
        `uvm_info("DPRAM_SCB", $sformatf("B: %s", item.convert2string()), UVM_MEDIUM)
        if (is_reset) return;

        if (item.op) begin
            if (!address_is_legal(item.addr))
                `uvm_warning("DPRAM_SCB", $sformatf("Illegal address on B: 0x%0h", item.addr))
            global_mem_pool.add(item.addr, item.data);
        end
        else begin
            exp = get_expected(item.addr);
            if (exp !== item.data) begin
                fail_b++;
                `uvm_error("DPRAM_SCB_MISMATCH", $sformatf("B addr 0x%0h exp 0x%0h got 0x%0h",
                                                          item.addr, exp, item.data))
            end
            else begin
                pass_b++;
                `uvm_info("DPRAM_SCB", $sformatf("B MATCH addr 0x%0h data 0x%0h", item.addr, item.data), UVM_LOW)
            end
        end
    endfunction

    // Handle reset and collision bypass using UVM run_phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            // Reset thread using uvm_event(s) to mirror the raw scoreboard
            begin
                if (reset_system_e != null) begin
                    forever begin
                        reset_system_e.wait_trigger();
                        is_reset = 1;
                        reset_memory();
                        if (hold_reset_e != null) hold_reset_e.wait_trigger();
                        is_reset = 0;
                    end
                end
            end

            // Write/Read same-address bypass/collision handling using virtual IFs
            begin
                if (vif_a != null && vif_b != null) begin
                    forever begin
                        @(posedge vif_a.clk);
                        if (is_reset) continue;

                        if ((vif_a.valid && vif_b.valid) &&
                            (vif_a.addr == vif_b.addr) &&
                            (vif_a.op != vif_b.op)) begin
                            // If B writes and A loses arbitration, commit B
                            if (vif_b.op && !vif_a.arbiter_b)
                                global_mem_pool.add(vif_b.addr, vif_b.wr_data);
                            // If A writes and B loses arbitration, commit A
                            else if (vif_a.op && vif_b.arbiter_b)
                                global_mem_pool.add(vif_a.addr, vif_a.wr_data);
                        end
                    end
                end
            end
        join_none
    endtask

    // Summarize at end of test
    function void report_phase(uvm_phase phase);
        `uvm_info("DPRAM_SCB_SUMMARY",
                  $sformatf("Port A: %0d Pass, %0d Fail; Port B: %0d Pass, %0d Fail; Total Pass: %0d, Total Fail: %0d",
                            pass_a, fail_a, pass_b, fail_b, pass_a+pass_b, fail_a+fail_b),
                  UVM_HIGH)
    endfunction

endclass