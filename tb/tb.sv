module tb;
    

    //interface instance here with clk

    // dut instance here

    

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    initial begin
        test t0;
        #20;

        t0 = new;
        t0.e0.vif = _if;
        t0.run();
        #500 $finish;
        end
endmodule


// instantiate the DUT wrapper here
