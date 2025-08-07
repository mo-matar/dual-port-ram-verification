class transaction;

  rand logic [`WIDTH-1:0] data;
  rand bit [`ADDR_WIDTH-1:0] addr; // address might be randc
    // bit ready;
    rand bit we;
    // bit valid;
    // bit [7:0] q;
    // bit rst_n;
    rand integer delay;
      time current_time;
    bit start_of_transaction;
    bit end_of_transaction;
  
  constraint del_const {delay >= 0; delay < 6; addr < 49152;}

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
    if(!TestRegistry::get_int("Disabledisplay"))
    $display("[%s]\t T=%8t\t [%15s] \t: data=%02h,\t addr=%02h,\t we=%1b,\t delay=%d",port_name, $time, tag, data, addr, we, delay);
  endfunction

endclass
