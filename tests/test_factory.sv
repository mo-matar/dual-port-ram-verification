`include "test_names_defines.sv"
`include "basic_test.sv"
`include "write_read_tests.sv"
`include "memory_fill_tests.sv"
// Include other test files

class test_factory;
    static function test create_test(test_names_e test_type);
        test t;
        
        case(test_type)
            basic_write_read_porta: t = new basic_write_read_porta_test("basic_write_read_porta");
            basic_write_read_portb: t = new basic_write_read_portb_test("basic_write_read_portb");

            default: t = new test("base_test");
        endcase
        
        return t;
    endfunction
endclass
