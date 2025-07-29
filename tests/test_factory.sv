// `include "test_names_defines.sv"
// Include other test files
// `include "write_read_tests.sv"

class test_factory;
  static function test create_test(string test_type);
        test t;
        
        case(test_type)
            "basic_write_read_porta": begin
                basic_write_read_porta_test porta_test;
              porta_test = new("basic_write_read_porta");
                t = porta_test;
            end
            "basic_write_read_portb": begin
                basic_write_read_portb_test portb_test;
                portb_test = new("basic_write_read_portb");
                t = portb_test;
            end

            "basic_porta_write_portb_read": begin
                basic_porta_write_portb_read_test porta_portb_test;
                porta_portb_test = new("basic_porta_write_portb_read");
                t = porta_portb_test;
            end

            "fill_memory_porta_write_portb_read": begin
                fill_memory_porta_write_portb_read_test fill_test;
                fill_test = new("fill_memory_porta_write_portb_read");
                t = fill_test;
            end

            default: begin
                t = new;

            end

        endcase
        
        return t;
    endfunction
endclass
