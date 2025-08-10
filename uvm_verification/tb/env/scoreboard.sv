`uvm_analysis_imp_decl(_a)
`uvm_analysis_imp_decl(_b)
class dpram_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(dpram_scoreboard)

    // Analysis ports for each agent
    uvm_analysis_imp_a#(dpram_item, dpram_scoreboard) m_analysis_imp_a;
    uvm_analysis_imp_b#(dpram_item, dpram_scoreboard) m_analysis_imp_b;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        m_analysis_imp_a = new("m_analysis_imp_a", this);
        m_analysis_imp_b = new("m_analysis_imp_b", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Additional initialization if needed
    endfunction

    virtual function write_a(dpram_item item);
        `uvm_info("DPRAM_SCOREBOARD", $sformatf("Received item from Agent A: %s", item.convert2string()), UVM_MEDIUM);
        // Process item from agent A
    endfunction
    virtual function write_b(dpram_item item);
        `uvm_info("DPRAM_SCOREBOARD", $sformatf("Received item from Agent B: %s", item.convert2string()), UVM_MEDIUM);
        // Process item from agent B
    endfunction



endclass