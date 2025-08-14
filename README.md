# dual-port-ram-verification
A dual port RAM verification project with valid-ready protocol environment implemented in both SystemVerilog and UVM methodologies.

## Project Structure

This project contains two verification approaches:

- **sv_verification/**: Traditional SystemVerilog verification environment with custom testbench components including generators, drivers, monitors, and scoreboard
- **uvm_verification/**: Universal Verification Methodology (UVM) based environment with standardized components, sequences, agents, and comprehensive coverage model.

Both environments verify the same dual-port RAM DUT with identical test scenarios to ensure thorough validation across different verification methodologies.

## Testbench Architecture
### SystemVerilog Testbench Architecture

![SV Testbench Architecture](testplan/sv_tb_architecture.png)
---
### UVM Testbench Architecture with RAL

![UVM Testbench Architecture](testplan/uvm_tb_architecture.png)

## UVM Environment Details

The UVM verification environment implements a comprehensive Register Abstraction Layer (RAL) model to provide high-level memory access and verification capabilities.

### RAL Model Implementation

#### Register Block (`dpram_reg_block`)
The main register block class extends `uvm_reg_block` and serves as the top-level container for the dual-port RAM memory model:

- **Memory Instance**: Contains a `dut_mem` object that models the physical memory
- **Dual Port Maps**: Implements separate register maps for each port:
  - `porta_map`: Register map for Port A access
  - `portb_map`: Register map for Port B access
- **HDL Path Configuration**: Establishes backdoor access paths to the actual DUT memory:
  - RTL path: `"tb_dual_port_ram.dut"`
  - Memory path: `"mem_inst.mem"`

#### Memory Model (`dut_mem`)
Extends `uvm_mem` to represent the dual-port RAM:
- **Size**: Configurable depth (`MEM_DEPTH`) and width (`DATA_WIDTH`)
- **Access Policy**: Read-Write (RW) access for both ports
- **Backdoor Support**: Enables direct memory access for initialization and checking

#### Register Adapter (`dpram_adapter`)
The adapter class bridges between register-level operations and bus-level transactions:

**Key Features**:
- **reg2bus Method**: Converts register operations to `dpram_item` transactions
  - Maps UVM register operations (READ/WRITE) to bus protocol
  - Handles address and data translation
  - Supports extension objects for timing control (`cfg_info`)
- **bus2reg Method**: Converts bus transactions back to register operations
  - Processes `dpram_item` responses
  - Updates register model state
  - Handles status reporting

**Extension Support**:
The adapter integrates with `cfg_info` extension objects to control transaction timing through the `transmit_delay` parameter.

### Sequence Architecture

#### Base Sequences (`dpram_base_seq`)
Provides common functionality for all sequences:
- **Front-door Operations**: Uses register model for standard access
- **Back-door Operations**: Direct memory access for setup/checking
- **Memory Pool Management**: Global memory tracking for consistency
- **Configuration Extensions**: Timing and behavior control

#### Virtual Sequences
Coordinate multiple port operations:
- **Simultaneous Operations**: Fork-join constructs for concurrent access
- **Cross-Port Verification**: Write on one port, read on another
- **Memory Fill Patterns**: Comprehensive memory testing

### Test Implementation

Each test class extends `base_test` and configures:
- **Virtual Interface Setup**: Port A and B interface configuration
- **Register Model Assignment**: RAL model connection to sequences
- **Reset Handling**: Randomized reset timing and duration
- **Sequence Execution**: Specific test sequence instantiation and execution

The UVM environment provides comprehensive memory verification through layered abstraction, enabling both register-level and transaction-level testing with full observability and control.

## Test Scenarios

| Test Case | Description | Name | SV Status | UVM Status | UVM Run Flags |
|-----------|------------|------|-----------|------------|---------------|
| Write operation test | Verify that write operation works independently of read. Send a frontdoor write transaction to a port, read the data with backdoor access, check read data is equal to written data | write_operation_single_port_test | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=write_operation_single_port_test +portA_portB_alternate_op=1 +UVM_NO_RELNOTES +acc=rw` |
| Read operation test | Verify that read operation works independently of write. Write random data with backdoor access to random memory address, send read transaction to the same address, check read data is equal to memory data | read_operation_single_port_test | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=read_operation_single_port_test +portA_portB_alternate_op=1 +UVM_NO_RELNOTES +acc=rw` |
| Single port write/read operation (Port A) | Verify basic write and read operations on port A. Write random data and address, read from the same address, verify that read data equals previously written data | basic_write_read_porta | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=basic_write_read_single_port_test +portA_portB_alternate_op=1 +UVM_NO_RELNOTES +acc=rw` |
| Single port write/read operation (Port B) | Verify basic write and read operations on port B. Write random data and address, read from the same address, verify that read data equals previously written data | basic_write_read_portb | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=basic_write_read_single_port_test +portA_portB_alternate_op=0 +UVM_NO_RELNOTES +acc=rw` |
| Write/read both ports | Verify basic write and read operations on both ports. Write random data and addresses, read from the same address, verify that read data equals previously written data | basic_write_read_both_ports | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=dpram_test +portA_portB_alternate_op=0 +UVM_NO_RELNOTES +acc=rw` |
| Basic write/read different ports | Ensure memory consistency across ports. Select port A for writing and port B for reading, write random data and random address on port A, read data at the same address on port B, check if data written from port A is the same as the data read from port B | basic_porta_write_portb_read | PASS | PASS | `+NoTrans=10 +UVM_TESTNAME=basic_porta_write_portb_read_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Fill memory with port A, read entire memory with port B | Test ability of port A to fill memory and port B to read all memory. Write to all memory locations through Port A, Read all memory locations through port B, check if written data is equal to read data | fill_memory_porta_write_portb_read | PASS | PASS | `+UVM_TESTNAME=fill_memory_porta_write_portb_read_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Simultaneous read from different addresses | Test ability of memory to handle reads from both ports simultaneously. Read address from port A, read different address from port B at same cycle, verify the read data is consistent and have not changed | simultaneous_read_different_address | PASS | PASS | `+UVM_TESTNAME=simultaneous_read_different_address_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Simultaneous write to different addresses | Test ability of memory to handle writes from both ports simultaneously. Write to random address from port A, write to different address from port B at same cycle, read data written and verify that it's consistent | simultaneous_write_different_address | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=simultaneous_write_different_address_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Simultaneous write to the same address | Check the behaviour of memory with collisions. Write to address, random data on port A, write to same address, random data, on port B at same cycle, Read same address verify arbitration logic | simultaneous_write_same_address | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=simultaneous_write_same_address_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Simultaneous write and read to the same address | Ensure consistency accessing data with different modes of operation. Fill memory with one port, write with a port and read with a different port at the same address, ensure that the new value has been read not the old value | simultaneous_write_read_same_address | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=simultaneous_write_read_same_address_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Out of range memory access | Check for out of range access handling. Write on illegal addresses, try reading all memory, verify that memory was not affected | out_of_range_memory_access | PASS | PASS | `+UVM_TESTNAME=out_of_range_memory_access_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Reset test | Write random data and random address, apply reset, read same address, should read default 0 value from memory | reset_test | CANCELED | CANCELED | N/A |
| Back to back transactions on port A | Test handling of continuous writing and reading on memory from port A. Write random data with random address from port A continuously, verify correct data | B2B_transactions_porta | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=B2B_transactions_single_port_test +portA_portB_alternate_op=1 +UVM_NO_RELNOTES +acc=rw` |
| Back to back transactions on port B | Test handling of continuous writing and reading on memory from port B. Write random data with random address from port B continuously, verify correct data and arbitration | B2B_transactions_portb | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=B2B_transactions_single_port_test +portA_portB_alternate_op=0 +UVM_NO_RELNOTES +acc=rw` |
| Back to back transactions on both ports | Test continuous transactions on memory from both ports. Random read or write, put random data on memory with random addresses, check if reference model has the same data as the memory | B2B_transactions_both_ports | PASS | PASS | `+UVM_TESTNAME=B2B_transactions_both_ports_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Default value test | Verify default value of memory. Read random addresses from memory, ensure data read is 0 | default_mem_value | PASS | PASS | `+NoTrans=20 +UVM_TESTNAME=default_mem_value_test +portA_write_portB_read=1 +UVM_NO_RELNOTES +acc=rw` |
| Write during reset | Verify correct operation when writing while reset. Hold reset for some time, write while reset is being held, verify that writes do not affect memory | write_during_reset | N/A | CANCELED | N/A |






