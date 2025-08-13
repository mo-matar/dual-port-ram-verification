// Minimal virtual sequence base and a stub virtual sequence
class dpram_vseq_base extends uvm_sequence;
    `uvm_object_utils(dpram_vseq_base)
    `uvm_declare_p_sequencer(dpram_virtual_sequencer)
    dpram_reg_block reg_model;


    // Sub-sequencer handles for convenience in derived sequences
    dpram_sequencer porta_sqr;
    dpram_sequencer portb_sqr;

    function new(string name="dpram_vseq_base");
        super.new(name);
    endfunction

    virtual task body();
        // Bind sub-sequencer handles from the virtual sequencer
        porta_sqr = p_sequencer.porta_sqr;
        portb_sqr = p_sequencer.portb_sqr;
    endtask
endclass

class dpram_vseq extends dpram_vseq_base;
    `uvm_object_utils(dpram_vseq)

    function new(string name="dpram_vseq");
        super.new(name);
    endfunction

    virtual task body();
        dpram_wr_rd_seq seq_a;
        dpram_wr_rd_seq seq_b;

        seq_a = dpram_wr_rd_seq::type_id::create("seq_a");
        seq_b = dpram_wr_rd_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
      	seq_b.map = reg_model.portb_map;
        super.body();
        // Run basic write/read on both ports
      `uvm_warning("2222222", $sformatf("2222222222222222"))


        fork
            begin
                if(!seq_a.randomize()) `uvm_error("RAND","FAILED");
                seq_a.start(porta_sqr);
                
            end
            begin
                if(!seq_b.randomize()) `uvm_error("RAND","FAILED");
                seq_b.start(portb_sqr);
                
            end
        join
    endtask
endclass


class read_operation_porta_vseq extends dpram_vseq_base;
    `uvm_object_utils(read_operation_porta_vseq)

    function new(string name="read_operation_porta_vseq");
        super.new(name);
    endfunction

    virtual task body();
        read_operation_porta_seq seq_a;

        seq_a = read_operation_porta_seq::type_id::create("seq_a");
        seq_a.reg_model = reg_model;
//       reg_model.print();
        seq_a.map = reg_model.porta_map;
//         super.body();
//         Run read on port A
        if(!seq_a.randomize()) `uvm_error("RAND","FAILED");
        seq_a.start(porta_sqr);
    endtask
endclass

class write_operation_porta_vseq extends dpram_vseq_base;
    `uvm_object_utils(write_operation_porta_vseq)

    function new(string name="write_operation_porta_vseq");
        super.new(name);
    endfunction

    virtual task body();
        write_operation_porta_seq seq_a;

        seq_a = write_operation_porta_seq::type_id::create("seq_a");
        seq_a.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;

        if(!seq_a.randomize()) `uvm_error("RAND","FAILED");
        seq_a.start(porta_sqr);
        

    endtask
endclass


class basic_porta_write_portb_read_vseq extends dpram_vseq_base;
    `uvm_object_utils(basic_porta_write_portb_read_vseq)
    int NoTrans;

    function new(string name="basic_porta_write_portb_read_vseq");
        super.new(name);
    endfunction

    virtual task body();
        basic_write_seq seq_a;
        basic_read_seq seq_b;

        seq_a = basic_write_seq::type_id::create("seq_a");
        seq_b = basic_read_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
      	seq_b.map = reg_model.portb_map;

    if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
      `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")


        repeat(NoTrans) begin
            seq_a.start(porta_sqr);
            seq_b.current_addr = seq_a.current_addr;
            seq_b.write_data = seq_a.write_data;
            seq_b.start(portb_sqr);
        end
    endtask


endclass


class fill_memory_porta_write_portb_read_vseq extends dpram_vseq_base;
    `uvm_object_utils(fill_memory_porta_write_portb_read_vseq)
    int NoTrans;

    function new(string name="fill_memory_porta_write_portb_read_vseq");
        super.new(name);
    endfunction

    virtual task body();
        fill_mem_seq seq_a;
        read_all_mem_seq seq_b;

        super.body(); // Initialize sequencer handles
        
        seq_a = fill_mem_seq::type_id::create("seq_a");
        seq_b = read_all_mem_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
        seq_b.map = reg_model.portb_map;


        seq_a.start(porta_sqr);
        porta_sqr.stop_sequences();
        //wait random delay
        #(10 + $urandom_range(0, 20));
        seq_b.start(portb_sqr);

    endtask

endclass


class simultaneous_write_different_address_vseq extends dpram_vseq_base;
    `uvm_object_utils(simultaneous_write_different_address_vseq)
    int NoTrans;

    function new(string name="simultaneous_write_different_address_vseq");
        super.new(name);
    endfunction

    virtual task body();
        single_wr_rd_seq seq_a;
        single_wr_rd_seq seq_b;

        super.body(); // Initialize sequencer handles

        seq_a = single_wr_rd_seq::type_id::create("seq_a");
        seq_b = single_wr_rd_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
        seq_b.map = reg_model.portb_map;

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
      `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")

        repeat(NoTrans) begin
            #40;
            fork
                begin
                    seq_a.start(porta_sqr);
                end
                begin
                    seq_b.start(portb_sqr);
                end
            join
        end
    endtask

endclass

class simultaneous_write_same_address_vseq extends dpram_vseq_base;
    `uvm_object_utils(simultaneous_write_same_address_vseq)
    int NoTrans;
    logic [`ADDR_WIDTH-1:0] same_tr_addr;

    function new(string name="simultaneous_write_same_address_vseq");
        super.new(name);
    endfunction

    virtual task body();
        single_wr_rd_seq seq_a;
        single_wr_rd_seq seq_b;

        super.body(); // Initialize sequencer handles

        seq_a = single_wr_rd_seq::type_id::create("seq_a");
        seq_b = single_wr_rd_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
        seq_b.map = reg_model.portb_map;

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
      `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")

        repeat(NoTrans) begin
            same_tr_addr = $urandom_range(0, `MEM_DEPTH-1);
            seq_a.current_addr = same_tr_addr;
            seq_b.current_addr = same_tr_addr;
            #40;
            fork
                begin
                    seq_a.start(porta_sqr);

                end
                begin
                    seq_b.start(portb_sqr);
                end
            join
        end
    endtask

endclass


class simultaneous_write_read_same_address_vseq extends dpram_vseq_base;
    `uvm_object_utils(simultaneous_write_read_same_address_vseq)
    int NoTrans;
    int portA_write_portB_read;
    logic [`ADDR_WIDTH-1:0] same_tr_addr;

    function new(string name="simultaneous_write_read_same_address_vseq");
        super.new(name);
    endfunction

    virtual task body();
        basic_write_seq seq_a;
        basic_read_seq seq_b;

        super.body(); // Initialize sequencer handles

        seq_a = basic_write_seq::type_id::create("seq_a");
        seq_b = basic_read_seq::type_id::create("seq_b");
        seq_a.reg_model = reg_model;
        seq_b.reg_model = reg_model;
        seq_a.map = reg_model.porta_map;
        seq_b.map = reg_model.portb_map;
        seq_a.ral_check = 0;
        seq_b.ral_check = 0;

        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "NoTrans", NoTrans))
            `uvm_fatal("CONFIG_ERROR", "Failed to get NoTrans from config_db")

        if(!uvm_config_db#(int)::get(null, "uvm_test_top", "portA_write_portB_read", portA_write_portB_read))
            `uvm_fatal("CONFIG_ERROR", "Failed to get portA_write_portB_read from config_db")

        repeat(NoTrans) begin
            same_tr_addr = $urandom_range(0, `MEM_DEPTH-1);
            seq_a.current_addr = same_tr_addr;
            seq_b.current_addr = same_tr_addr;
            #40;
            if(portA_write_portB_read) begin
                fork
                    begin
                        seq_a.start(porta_sqr);

                    end
                    begin
                        seq_b.start(portb_sqr);
                    end
                join
                end else begin
                fork
                    begin
                        seq_a.start(portb_sqr);

                    end
                    begin
                        seq_b.start(porta_sqr);
                    end
                join
            end

        end
    endtask

endclass