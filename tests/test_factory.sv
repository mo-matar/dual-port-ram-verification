// `include "test_names_defines.sv"
// Include other test files
// `include "write_read_tests.sv"

class test_factory;
  static function test create_test(string test_type);
        test t;
        
        case(test_type)
            "basic_write_read_porta": begin
                t = basic_write_read_porta_test::new("basic_write_read_porta");
                //t = porta_test;
            end
            "basic_write_read_portb": begin
                basic_write_read_portb_test portb_test;
                portb_test = new("basic_write_read_portb");
                t = portb_test;
            end

            default: begin
                basic_write_read_porta_test porta_test;
                porta_test = new("basic_write_read_porta");
                t = porta_test;
            end
        endcase
        
        return t;
    endfunction
endclass
