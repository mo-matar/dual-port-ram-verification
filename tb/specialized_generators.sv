// Write-Read generator for Port A
class write_read_generator extends generator;
    function new();
        super.new();
    endfunction
    
    virtual task run();
        if(!active) return;
        
        // Implement specific write-read pattern
        // Example:
        // 1. Generate write transaction
        // 2. Send to driver via gen2drv
        // 3. Generate read transaction to same address
        // 4. Send to driver
    endtask
endclass

// Write-only generator
class write_only_generator extends generator;
    function new();
        super.new();
    endfunction
    
    virtual task run();
        if(!active) return;
        
        // Implement write-only pattern
    endtask
endclass

// Read-only generator
class read_only_generator extends generator;
    function new();
        super.new();
    endfunction
    
    virtual task run();
        if(!active) return;
        
        // Implement read-only pattern
    endtask
endclass

// More specialized generators as needed...
