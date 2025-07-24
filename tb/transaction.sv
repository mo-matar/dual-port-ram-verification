class transaction;

    rand bit [7:0] data;
    rand bit [5:0] addr; // address might be randc
    bit ready;
    rand bit we;
    bit valid;
    bit [7:0] q;
    // bit rst_n;

    function transaction copy();
        copy = new;
        copy.data = this.data;
        copy.addr = this.addr;
        copy.ready = this.ready;
        copy.we = this.we;
        copy.valid = this.valid;
        copy.q = this.q;
    endfunction


    function void display();
        $display("[%0t] Transaction: data=%0h, addr=%0h, we=%0b, valid=%0b, q=%0h, rst_n=%0b", $time, data, addr, we, valid, q, rst_n);
    endfunction

endclass
