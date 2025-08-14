
class fill_mem_seq extends dpram_base_seq;
    `uvm_object_utils(fill_mem_seq)
    function new(string name="fill_mem_seq");
        super.new(name);
    endfunction

    virtual task body();
      super.body();

        
        fill_mem();
      
    endtask
endclass
// alternative using bursts
// class fill_mem_seq extends dpram_base_seq;
//     `uvm_object_utils(fill_mem_seq)
//     function new(string name="fill_mem_seq");
//         super.new(name);
//     endfunction

//     virtual task body();
//       uvm_status_e status;  // Add missing status declaration
//       uvm_reg_data_t burst_data[];
//       burst_data = new[`MEM_DEPTH];
//       super.body();

//       for (int i = 0; i < `MEM_DEPTH; i++) begin
//         burst_data[i] = $urandom_range(0, 255);
//       end

//       reg_model.mem.burst_write(status, 0, burst_data, UVM_FRONTDOOR, map, this);
      
//       if (status != UVM_IS_OK) begin
//         `uvm_error(get_type_name(), $sformatf("Burst write failed with status: %s", status.name()))
//       end else begin
//         `uvm_info(get_type_name(), $sformatf("Successfully filled memory with %0d entries", `MEM_DEPTH), UVM_MEDIUM)
//       end
//     endtask
// endclass