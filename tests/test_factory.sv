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
            "B2B_transactions_portb": begin
                B2B_transactions_portb_test b2b_test;
                b2b_test = new("B2B_transactions_portb");
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

            "simultaneous_write_same_address": begin
                simultaneous_write_same_address_test sim_test;
                sim_test = new("simultaneous_write_same_address");
                t = sim_test;
            end

            "out_of_range_memory_access": begin
                out_of_range_memory_access_test out_of_range_test;
                out_of_range_test = new("out_of_range_memory_access");
                t = out_of_range_test;
            end
            "simultaneous_write_read_same_address": begin
                simultaneous_write_read_same_address_test sim_write_read_test;
                sim_write_read_test = new("simultaneous_write_read_same_address");
                t = sim_write_read_test;
            end
            "simultaneous_read_different_address": begin
                simultaneous_read_different_address_test sim_read_test;
                sim_read_test = new("simultaneous_read_different_address");
                t = sim_read_test;
            end
            "simultaneous_write_different_address": begin
                simultaneous_write_different_address_test sim_write_test;
                sim_write_test = new("simultaneous_write_different_address");
                t = sim_write_test;
            end

            "B2B_transactions_both_ports": begin
                B2B_transactions_both_ports_test b2b_both_test;
                b2b_both_test = new("B2B_transactions_both_ports");
                t = b2b_both_test;
            end

            "B2B_transactions_both_ports_same_address": begin
                B2B_transactions_both_ports_same_address_test b2b_both_same_test;
                b2b_both_same_test = new("B2B_transactions_both_ports_same_address");
                t = b2b_both_same_test;
            end

            "write_during_reset": begin
                write_during_reset_test write_reset_test;
                write_reset_test = new("write_during_reset");
                t = write_reset_test;
            end

            default: begin
                t = new;

            end

        endcase
        
        return t;
    endfunction
endclass
