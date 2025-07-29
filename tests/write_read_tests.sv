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
    logic [$clog2(`DEPTH)-1:0] addr_q[$];
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
            addr_q.push_back( $urandom_range(0, `DEPTH-1) );
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


// class B2B_transactions_porta_test extends test;
//   /*Goal: test handling of continous writing on memory from  port A 
//     write random data with random address from port A continously
//     verify correct data and arbitration*/
//     function new(string name = "B2B_transactions_porta_test");
//         super.new(name);
//     endfunction
    
//     virtual task configure_test();
//         B2B_transactions_porta_gen_a gen_a;
//         B2B_transactions_portb_gen_b gen_b;
//         event B2B_transactions_done;
//         gen_a = new();
//         gen_b = new();
//         gen_a.B2B_transactions_done = B2B_transactions_done;
//         gen_b.B2B_transactions_done = B2B_transactions_done;
//         e0.agent_a.set_generator(gen_a);
//         e0.agent_b.set_generator(gen_b);
//     endtask

// endclass


         
