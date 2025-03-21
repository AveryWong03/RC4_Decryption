module fsm_key_control(
    input clk,
    input update_request_1, update_request_2, update_request_3, update_request_4,
    input end_3_1, end_3_2, end_3_3, end_3_4,
    output reg [23:0] key, // to fsm 2 and 7seg decoder
    output reg [23:0] key_1, key_2, key_3, key_4,

    output start_loop_1, start_loop_2, start_loop_3, start_loop_4,    // to fsm 1
    output reg led0,
    output reg led9 
);

    reg [9:0] state;

    parameter [9:0] check_core_1      = 10'b000000_0000;
    parameter [9:0] check_core_2      = 10'b000001_0000;
    parameter [9:0] check_core_3      = 10'b000010_0000;
    parameter [9:0] check_core_4      = 10'b000011_0000;

    parameter [9:0] check_key_1       = 10'b000100_0000;
    parameter [9:0] check_key_2       = 10'b000101_0000;
    parameter [9:0] check_key_3       = 10'b000110_0000;
    parameter [9:0] check_key_4       = 10'b000111_0000;

    parameter [9:0] increment_key_1   = 10'b001000_0000;
    parameter [9:0] increment_key_2   = 10'b001001_0000;
    parameter [9:0] increment_key_3   = 10'b001010_0000;
    parameter [9:0] increment_key_4   = 10'b001011_0000;

    parameter [9:0] start_next_key_1  = 10'b001100_0001;
    parameter [9:0] start_next_key_2  = 10'b001101_0010;
    parameter [9:0] start_next_key_3  = 10'b001110_0100;
    parameter [9:0] start_next_key_4  = 10'b001111_1000;

    parameter [9:0] end_routine       = 10'b010000_0000;
    parameter [9:0] no_key            = 10'b010001_0000;

    assign start_loop_1 = state[0];
    assign start_loop_2 = state[1];
    assign start_loop_3 = state[2];
    assign start_loop_4 = state[3];

    always_ff @(posedge clk)
    begin
        case(state)

            check_core_1: begin
                if(update_request_1) state <= check_key_1;
                else if(end_3_1) state <= end_routine;
                else state <= check_core_2;
            end

            check_core_2: begin
                if(update_request_2) state <= check_key_2;
                else if(end_3_2) state <= end_routine;
                else state <= check_core_3;
            end

            check_core_3: begin
                if(update_request_3) state <= check_key_3;
                else if(end_3_3) state <= end_routine;
                else state <= check_core_4;
            end

            check_core_4: begin
                if(update_request_4) state <= check_key_4;
                else if(end_3_4) state <= end_routine;
                else state <= check_core_1;
            end

            check_key_1: begin 
                if(key == 24'h3FFFFF) // first 2 MSB are 0
                    state <= no_key; // tried the last key, no luck
                else
                    state <= increment_key_1;
            end

            check_key_2: begin 
                if(key == 24'h3FFFFF) // first 2 MSB are 0
                    state <= no_key; // tried the last key, no luck
                else
                    state <= increment_key_2;
            end

            check_key_3: begin 
                if(key == 24'h3FFFFF) // first 2 MSB are 0
                    state <= no_key; // tried the last key, no luck
                else
                    state <= increment_key_3;
            end

            check_key_4: begin 
                if(key == 24'h3FFFFF) // first 2 MSB are 0
                    state <= no_key; // tried the last key, no luck
                else
                    state <= increment_key_4;
            end

            increment_key_1: state <= start_next_key_1;
            increment_key_2: state <= start_next_key_2;
            increment_key_3: state <= start_next_key_3;
            increment_key_4: state <= start_next_key_4;

            start_next_key_1: state <= check_core_2; // Check next request
            start_next_key_2: state <= check_core_3;
            start_next_key_3: state <= check_core_4;
            start_next_key_4: state <= check_core_1;

            // End states
            end_routine: state <= end_routine;
            no_key: begin
                if(end_3_1 | end_3_2  | end_3_3 | end_3_4)
                    state <= end_routine;
                else
                    state <= no_key;
            end

            default: state <= check_core_1; 

        endcase
    end
    
    // Handles individual core key updates
    always_ff @(posedge clk)
    begin
        case(state)
            start_next_key_1: key_1 <= key;
            start_next_key_2: key_2 <= key;
            start_next_key_3: key_3 <= key;
            start_next_key_4: key_4 <= key;
            default: begin
                key_1 <= key_1;
                key_2 <= key_2;
                key_3 <= key_3;
                key_4 <= key_4;
            end
        endcase
    end


    // Handles key updates
    always_ff @(posedge clk)
    begin
        case(state)
            increment_key_1: key <= key + 24'b1;
            increment_key_2: key <= key + 24'b1;
            increment_key_3: key <= key + 24'b1;
            increment_key_4: key <= key + 24'b1;

            end_routine:
            begin
                if(end_3_1)
                    key <= key_1;
                else if (end_3_2)
                    key <= key_2;
                else if (end_3_3)
                    key <= key_3;
                else
                    key <= key_4;
            end

            default: key <= key;
        endcase
    end

    // Handles end states
    always_ff @(posedge clk)
    begin
        case(state)
            no_key: begin 
                led0 <= 1'b1;
                led9 <= 1'b0;
            end
            end_routine: begin
                led9 <= 1'b1;
                led0 <= 1'b0;
            end

            default: begin
                led0 <= 1'b0;
                led9 <= 1'b0;
            end
        endcase
    end


endmodule