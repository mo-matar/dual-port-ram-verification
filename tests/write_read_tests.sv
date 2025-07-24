class basic_write_read_porta_test extends test;
    function new(string name = "basic_write_read_porta_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        basic_write_read_porta_gen gen_a = new();
        // basic_write_read_portb_gen gen_b = new();
        e0.agent_a.set_generator(gen_a);
        //e0.agent_b.set_generator(gen_b);
        e0.agent_b.gen.active = 0;
    endtask
endclass

class basic_write_read_portb_test extends test;
    function new(string name = "basic_write_read_portb_test");
        super.new(name);
    endfunction
    
    virtual task configure_test();
        basic_write_read_portb_gen gen_b = new();
        e0.agent_b.set_generator(gen_b);
        e0.agent_a.gen.active = 0;
        
    endtask
endclass
