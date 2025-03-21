module fsm_mem(
    input clk,

    output wren_s,
    input [7:0] q_s,
    output reg [7:0] data_s,
    output reg [7:0] address_s,

    input [7:0] data_1,
    input [7:0] data_2,
    input [7:0] data_3,

    output reg [7:0] data_2_out,
    output reg [7:0] data_3_out,

    input [7:0] address_1,
    input [7:0] address_2,
    input [7:0] address_3,

    input request_1,
    input request_2,
    input request_3,

    input wrt_2,
    input wrt_3,

    output finished_1,
    output finished_2,
    output finished_3

);

    reg [9:0] state;

    parameter [9:0] check_loop_1     = 10'b00000_000_0;
    parameter [9:0] write_set_1      = 10'b00001_000_0;
    parameter [9:0] write_1          = 10'b00010_000_1;
    parameter [9:0] finish_1         = 10'b00011_001_0;

    parameter [9:0] check_loop_2     = 10'b00100_000_0;
    parameter [9:0] read_write_2     = 10'b00101_000_0;
    parameter [9:0] read_req_2       = 10'b00110_000_0;
    parameter [9:0] wait_read_2      = 10'b00111_000_0;
    parameter [9:0] read_2           = 10'b01000_000_0;
    parameter [9:0] write_set_2      = 10'b01001_000_0;
    parameter [9:0] write_2          = 10'b01010_000_1;
    parameter [9:0] finish_2         = 10'b01011_010_0;

    parameter [9:0] check_loop_3     = 10'b01100_000_0;
    parameter [9:0] read_write_3     = 10'b01101_000_0;
    parameter [9:0] read_req_3       = 10'b01110_000_0;
    parameter [9:0] wait_read_3      = 10'b01111_000_0;
    parameter [9:0] read_3           = 10'b10000_000_0;
    parameter [9:0] write_set_3      = 10'b10001_000_0;
    parameter [9:0] write_3          = 10'b10010_000_1;
    parameter [9:0] finish_3         = 10'b10011_100_0;

    assign wren_s = state[0];
    assign finished_1 = state[1];
    assign finished_2 = state[2];
    assign finished_3 = state[3];

    always_ff @(posedge clk)
    begin
        case(state)
            // CHECKS
            check_loop_1: begin
                if(request_1) state <= write_set_1;
                else state <= check_loop_2;
            end

            check_loop_2: begin
                if(request_2) state <= read_write_2;
                else state <= check_loop_3;
            end

            check_loop_3: begin
                if(request_3) state <= read_write_3;
                else state <= check_loop_1;
            end

            // READ OR WRITE (does not apply to loop 1)
            read_write_2: begin
                if(wrt_2) state <= write_set_2;
                else state <= read_req_2;
            end

            read_write_3: begin
                if(wrt_3) state <= write_set_3;
                else state <= read_req_3;
            end

            // WRITE
            write_set_1: state <= write_1;
            write_set_2: state <= write_2;
            write_set_3: state <= write_3;

            write_1: state <= finish_1;
            write_2: state <= finish_2;
            write_3: state <= finish_3;


            // READ REQUEST
            read_req_2: state <= wait_read_2;
            read_req_3: state <= wait_read_3;

            // WAIT FOR Q TO UPDATE
            wait_read_2: state <= read_2;
            wait_read_3: state <= read_3;

            // READ
            read_2: state <= finish_2;
            read_3: state <= finish_3;

            // FINISH
            finish_1: state <= check_loop_2;
            finish_2: state <= check_loop_3;
            finish_3: state <= check_loop_1;

            default: state <= check_loop_1; 
        endcase
    end

    always_ff @(posedge clk)
    begin
        case(state)
            write_set_1: begin address_s <= address_1; data_s <= data_1; end
            write_set_2: begin address_s <= address_2; data_s <= data_2; end
            write_set_3: begin address_s <= address_3; data_s <= data_3; end

            read_req_2: address_s <= address_2;
            read_req_3: address_s <= address_3;

            read_2: data_2_out <= q_s;
            read_3: data_3_out <= q_s;

        endcase
    end

endmodule