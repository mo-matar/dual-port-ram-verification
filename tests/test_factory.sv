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

            "B2B_transactions_porta": begin
                B2B_transactions_porta_test b2b_test;
                b2b_test = new("B2B_transactions_porta");
                t = b2b_test;
            end

            "default_mem_value": begin
                default_mem_value_test default_test;
                default_test = new("default_mem_value_test");
                t = default_test;
            end
          "reset_test": begin
                reset_test reset_t;
                reset_t = new("reset_test");
                t = reset_t;
            end

            default: begin
                t = new;

            end

        endcase
        
        return t;
    endfunction
endclass
