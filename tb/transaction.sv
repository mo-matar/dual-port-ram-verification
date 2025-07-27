class transaction;

    rand bit [7:0] data;
    rand bit [5:0] addr; // address might be randc
    // bit ready;
    rand bit we;
    // bit valid;
    // bit [7:0] q;
    // bit rst_n;
    rand integer delay;
  
  constraint del_const {delay == 5;}

    function transaction copy();
        copy = new;
        copy.data = this.data;
        copy.addr = this.addr;
//         copy.ready = this.ready;
        copy.we = this.we;
//         copy.valid = this.valid;
//         copy.q = this.q;
    endfunction


  function void display(string port_name = "XXXX", string tag="");
    $display("[%s] T=%0t [%s] Transaction: data=%0h, addr=%0h, we=%0b delay=%0d", port_name, $time, tag, data, addr, we, delay);
    endfunction

endclass
