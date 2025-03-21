module fsm_loop_2(
    input clk,
    input [23:0] key, 
    input start,

    output request,
    output write,

    input request_finished,

    output reg [7:0] address,
    input [7:0] data_in,
    output reg [7:0] data,

    output finished,

    // can set these as just reg, set as output for debugging
    output reg [7:0] state,
    output reg [7:0] count,
    output reg [7:0] data_i,
    output reg [7:0] data_j,
    // reg [7:0] address_i; this is just count
    output reg [7:0] address_j,
    output reg [7:0] key_select
);

    
    parameter [7:0] first            = 8'b00000_00_0;
    parameter [7:0] idle             = 8'b00001_00_0;
    parameter [7:0] request_read_i   = 8'b00010_01_0;
    parameter [7:0] calculate_j      = 8'b00011_00_0;
    parameter [7:0] request_read_j   = 8'b00100_01_0;
    parameter [7:0] request_write_j  = 8'b00101_11_0;
    parameter [7:0] request_write_i  = 8'b00110_11_0;
    parameter [7:0] check_finish     = 8'b00111_00_0;
    parameter [7:0] increment        = 8'b01000_00_0;
    parameter [7:0] finish           = 8'b01001_00_1;

    wire [1:0] num = count % 3;

    assign finished = state[0];
    assign request = state[1];
    assign write  = state[2];

    // State logic
    always_ff @(posedge clk)
    begin
        case(state)
            first: if(start) state <= idle;
            idle: state <= request_read_i;
            request_read_i: if(request_finished) state <= calculate_j; // calculate_J
            calculate_j: state <= request_read_j;
            request_read_j: if(request_finished) state <= request_write_j;
            request_write_j: if(request_finished) state <= request_write_i;
            request_write_i: if(request_finished) state <= check_finish;

            check_finish: begin 
                if(count == 8'd255)
                    state <= finish;
                else 
                    state <= increment; 
            end
            increment: state <= idle; // idle, testing with finish
            finish: state <= first; 
            default: state <= first;
        endcase
    end

    // 256 Counter
    always_ff @(posedge clk)
    begin
        case(state)
            increment: count <= count + 8'b1;
            first: count <= 8'b0;
            default: count <= count;
        endcase
    end

    always_ff @(posedge clk)
    begin
        case(state)
        // Note: Request also waits for the finish signal, and thus will read the result in same state
        // Think this is ok because the mem fsm has a couple cycles before it gets to read/write
        request_read_i: begin
            data_i <= data_in;
            address <= count;
        end

        calculate_j: address_j <= (address_j + data_i + key_select);

        request_read_j: begin
            data_j <= data_in;
            address <= address_j;
        end

        request_write_j: begin
            data <= data_i;
            address <= address_j;
        end

        request_write_i: begin
            data <= data_j;
            address <= count;
        end

        first: begin
            address <= 8'b0;
            address_j <= 8'b0;
        end

        endcase
    end

    // Key_select assignment
    always_ff @(posedge clk)
    begin
        case(num)
            2'd0: key_select <= key[23:16];
            2'd1: key_select <= key[15:8];
            2'd2: key_select <= key[7:0];
            default key_select <= 8'b0;
        endcase
    end

endmodule