// Code your design here
module dpram
  (
    input [7:0] data_a, data_b,
    input [5:0] addr_a, addr_b,
    input we_a, we_b, clk, rst_n,
    input valid_a, valid_b,        // Valid signals - indicates sender has valid data
    output reg ready_a, ready_b,   // Ready signals - indicates module can accept transaction
    output reg [7:0] q_a, q_b
  );
    // Declare the RAM variable
    reg [7:0] ram[63:0];
 
    // Transaction flags
    wire trans_a = valid_a & ready_a;
    wire trans_b = valid_b & ready_b;
 
    // Ready logic - in this simple implementation we're always ready
    // In more complex designs, this could depend on internal state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ready_a <= 1'b1;
            ready_b <= 1'b1;
        end else begin
            ready_a <= 1'b1;  // Always ready to accept new transactions
            ready_b <= 1'b1;  // Always ready to accept new transactions
        end
    end
 
    // Port A
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q_a <= 8'b0;
        end else if (trans_a) begin  // Only process when handshake complete
            if (we_a) begin
                ram[addr_a] <= data_a;
                q_a <= data_a;
            end else begin
                q_a <= ram[addr_a];
            end
        end
    end
 
    // Port B
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
            q_b <= 8'b0;
        end else if (trans_b) begin  // Only process when handshake complete
            if (we_b) begin
                ram[addr_b] <= data_b;
                q_b <= data_b;
            end else begin
                q_b <= ram[addr_b];
            end
        end
    end
 
endmodule