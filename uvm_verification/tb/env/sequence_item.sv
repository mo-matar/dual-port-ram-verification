class dpram_item extends uvm_sequence_item;
    `uvm_object_utils(item)

    rand logic [`MEM_DEPTH-1:0] addr;
    rand logic [`DATA_WIDTH-1:0] data;
    rand bit op;
    rand integer delay;

    constraint dpram_constraint {
        delay >= 0;
        delay <= 10;
        addr inside {[0:`MEM_DEPTH-1]};
    }


    function new(string name="item");
        super.new(name);
    endfunction

    virtual function string convert2string();
        return $sformatf("item: addr=%0d, data=%0h, op=%0b, delay=%0d", addr, data, op, delay);
    endfunction
endclass


class dpram_write_item extends item;
    `uvm_object_utils(write_item)
    constraint write_constraint {
        op == 1; // Ensure this is a write operation
    }

    function new(string name="write_item");
        super.new(name);
    endfunction
endclass


class dpram_read_item extends item;
    `uvm_object_utils(read_item)
    constraint read_constraint {
        op == 0; 
        }

    function new(string name="read_item");
        super.new(name);
    endfunction
endclass