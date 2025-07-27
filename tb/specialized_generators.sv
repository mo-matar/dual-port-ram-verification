// Write-Read generator for Port A
class basic_write_read_porta_gen extends generator;

    function new();
        super.new();
    endfunction


    virtual task run();
        $display("Running basic write-read generator for Port A...");
        
        if(!active) return;

        // Goal: verify basic write and read operations on port a
        // write random data and address
        // read from the same address
        // verify that read data equals previously written data
        no_transactions = TestRegistry::get_int("NoOfTransactions");
        $display("[%0t] GEN: Starting basic write-read test on Port A with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            write_transaction();
            read_transaction();
            //! @(drv_done);??????????????????
        end


    endtask
endclass

class basic_write_read_portb_gen extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(!active) return;

        // Goal: verify basic write and read operations on port b
        // write random data and address
        // read from the same address
        // verify that read data equals previously written data
        no_transactions = TestRegistry::get_int("NoOfTransactions");
        $display("[%0t] GEN: Starting basic write-read test on Port B with %0d transactions", $time, no_transactions);

        repeat(no_transactions) begin
            write_transaction();
            read_transaction();
            //! @(drv_done);??????????????????
        end
    endtask
endclass

