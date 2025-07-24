class basic_write_read_porta_test extends test;
    function new(string name = "basic_write_read_porta_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        // Create and assign specialized generator
        write_read_generator wr_gen = new();
        e0.agent_a.set_generator(wr_gen);
        
        // Deactivate port B
        e0.agent_b.gen.active = 0;
        
        // Other configurations specific to this test
    endtask
endclass

class basic_porta_write_portb_read_test extends test;
    function new(string name = "basic_porta_write_portb_read_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        // Create specialized generators for each port
        write_only_generator w_gen = new();
        read_only_generator r_gen = new();
        
        // Assign generators to agents
        e0.agent_a.set_generator(w_gen);
        e0.agent_b.set_generator(r_gen);
        
        // Other configurations
    endtask
endclass
