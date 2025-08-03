class basic_write_read_porta_test extends test;
    function new(string name = "basic_write_read_porta_test");
        super.new(name);
    endfunction
    
  virtual task configure_test();
      basic_write_read_porta_gen gen_a;

         gen_a = new();
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.gen.active = 0;
    endtask
endclass

class basic_write_read_portb_test extends test;
    function new(string name = "basic_write_read_portb_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        basic_write_read_portb_gen gen_b;

         gen_b = new();
        e0.agent_b.set_generator(gen_b);
        e0.agent_a.gen.active = 0;
        
    endtask
endclass

class basic_porta_write_portb_read_test extends test;
  logic [`ADDR_WIDTH-1:0] addr_q[$];
    int queue_size;
    function new(string name = "basic_porta_write_portb_read_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        basic_porta_write_portb_read_gen_a gen_a;
        basic_portb_write_porta_read_gen_b gen_b;
              semaphore key;
      mailbox wrmb;
      key = new(1);
      wrmb = new(1);

        gen_a = new();
        gen_b = new();
        gen_a.key = key;
        gen_b.key = key;
      gen_b.wrmb = wrmb;
      gen_a.wrmb = wrmb;
      
        // define a queue of size noOfTransactions
        queue_size = TestRegistry::get_int("NoOfTransactions");
        for (int i = 0; i < queue_size; i++) begin
            addr_q.push_back( $urandom_range(0, `MEM_DEPTH-1) );
        end
        e0.agent_a.set_generator(gen_a);
        gen_a.port_name = "port_a";
        gen_b.port_name = "port_b";
        e0.agent_b.set_generator(gen_b);
        gen_a.set_addresses(addr_q);
        gen_b.set_addresses(addr_q);
    endtask

endclass


class fill_memory_porta_write_portb_read_test extends test;
  /*Goal: test ability of  port A to fill memory and port B to read all memory
    Write to all memory locations through Port A
    Read all memory locations through port B
    check if written data is equal to read data*/
    
    function new(string name = "fill_memory_porta_write_portb_read_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        fill_memory_porta_write_portb_read_gen_a gen_a;
        fill_memory_portb_write_porta_read_gen_b gen_b;
        event mem_filled;
        gen_a = new();
        gen_b = new();
        gen_a.mem_filled = mem_filled;
        gen_b.mem_filled = mem_filled;
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask
        


endclass


class B2B_transactions_porta_test extends test;
  /*Goal: test handling of continous writing on memory from  port A 
    write random data with random address from port A continously
    verify correct data and arbitration*/
    function new(string name = "B2B_transactions_porta_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        B2B_transactions_porta_gen gen_a;
        gen_a = new();
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.gen.active = 0;
    endtask

endclass


         

class default_mem_value_test extends test;
  /*Goal: verify default value of memory
    read random addresses from memory
    ensure data read is 0*/
    
    function new(string name = "default_mem_value_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        default_mem_value_gen gen_a;
        default_mem_value_gen gen_b;
        gen_a = new();
        gen_b = new();
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask

endclass


class reset_test extends test;
  /*Goal: write random data and random address
    apply reset
    read same address
    should read default 0 value from memory*/
    
    function new(string name = "reset_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        reset_gen gen_a;
//         reset_gen gen_b;
        gen_a = new();
//         gen_b = new();
        gen_a.vif = e0.vif_a;
//         gen_b.vif = e0.vif_b;
        e0.agent_a.set_generator(gen_a);
      	gen_a.reset_system = this.reset_system;
        e0.sb.reset_system = this.reset_system;
        //e0.agent_b.set_generator(gen_b);
        e0.agent_b.gen.active = 0;
      
//       ->reset_system;
    endtask

endclass


class simultaneous_write_same_address_test extends test;
  /*Goal: check the behaviour of memory with collisions
    write to address , random data on  port A
    write to same address , random data , on port B at same cycle
    Read same address verify arbitration logic*/
    logic [`ADDR_WIDTH-1:0] addr_q[$];
    int queue_size;
    
    function new(string name = "simultaneous_write_same_address_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        simultaneous_write_same_address_gen gen_a;
        simultaneous_write_same_address_gen gen_b;
        gen_a = new();
        gen_b = new();
        queue_size = TestRegistry::get_int("NoOfTransactions");
        for (int i = 0; i < queue_size; i++) begin
            addr_q.push_back( $urandom_range(0, `MEM_DEPTH-1) );
        end
        gen_a.set_addresses(addr_q);
        gen_b.set_addresses(addr_q);

        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask
endclass

class simultaneous_write_read_same_address_test extends test;
  /*Goal: check the behaviour of memory with collisions
    write to address , random data on  port A
    read from same address , random data , on port B at same cycle
    verify arbitration logic*/
    logic [`ADDR_WIDTH-1:0] addr_q[$];
    int queue_size;
    event mem_filled;
    
    function new(string name = "simultaneous_write_read_same_address_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        simultaneous_write_read_same_address_gen_a gen_a;
        simultaneous_write_read_same_address_gen_b gen_b;
        gen_a = new();
        gen_b = new();
        queue_size = TestRegistry::get_int("NoOfTransactions");
        for (int i = 0; i < queue_size; i++) begin
            addr_q.push_back( $urandom_range(0, `DEPTH-1) );
        end
        gen_a.set_addresses(addr_q);
        gen_b.set_addresses(addr_q);
        gen_a.mem_filled = mem_filled;
        gen_b.mem_filled = mem_filled;

      if(!TestRegistry::get_int("portA_fill_portB_read")) begin

      e0.agent_a.set_generator(gen_b);
      e0.agent_b.set_generator(gen_a);
      end
      else begin
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);        
      end
    endtask

endclass

class out_of_range_memory_access_test extends test;
  /*Goal: check the behaviour of memory with out of range access
    write to address , random data on  port A
    write to same address , random data , on port B at same cycle
    Read same address verify arbitration logic*/
    event write_finished;
    
    
    function new(string name = "out_of_range_memory_access_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        out_of_range_memory_access_gen_a gen_a;
        out_of_range_memory_access_gen_a gen_b;
        gen_a = new();
        gen_b = new();
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
              e0.agent_b.gen.active = 0;

    endtask


endclass


class B2B_transactions_both_ports_test extends test;
  /*Goal: test continuous transactions on memory from both ports
    random read or write
    put random data on memory with random addresses
    check if reference model has the same data as the memory*/

    function new(string name = "B2B_transactions_both_ports");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        B2B_transactions_both_ports_gen gen_a;
        B2B_transactions_both_ports_gen gen_b;
        gen_a = new();
        gen_b = new();
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask

endclass