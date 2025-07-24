class scoreboard;

    bit [`DEPTH-1:0] mem [bit [`WIDTH-1:0]];

    // function automatic void write_a(bit [7:0] addr, bit [7:0] data);
    //     mem[addr] = data;
    // endfunction

    // function automatic void write_b(bit [7:0] addr, bit [7:0] data);
    //     mem[addr] = data;
    // endfunction

    // function automatic bit [7:0] read_a(bit [7:0] addr);
    //     return mem.exists(addr) ? mem[addr] : '0;
    // endfunction

    // function automatic bit [7:0] read_b(bit [7:0] addr);
    //     return mem.exists(addr) ? mem[addr] : '0;
    // endfunction

endclass