class out_of_range_memory_access_vseq extends dpram_vseq_base;

    `uvm_object_utils(out_of_range_memory_access_vseq)

    function new(string name="out_of_range_memory_access_vseq");
        super.new(name);
    endfunction

    virtual task body();
      dpram_write_item item;

        read_all_mem_seq seq_rd_mem;
        seq_rd_mem = read_all_mem_seq::type_id::create("seq_rd_mem");


        seq_rd_mem.reg_model = reg_model;
        seq_rd_mem.map = reg_model.porta_map;

        super.body();
        // Run basic write/read on both ports

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
            `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")

        repeat(NoTrans) begin

        
            
              `uvm_do_on_with(item, porta_sqr, {item.addr inside {[`MEM_DEPTH: 65535]};})
          get_response(rsp);
            
              `uvm_do_on_with(item, portb_sqr, {item.addr inside {[`MEM_DEPTH: 65535]};})
          get_response(rsp);
        

        end


        seq_rd_mem.start(porta_sqr);
    endtask


endclass