module fsm_loop_1(
    input clk,
    input start,
    input start_next_loop, 
    input request_finished,
    output request,
    output finished,
    output reg [7:0] address,
    output reg [7:0] data
);
    reg [5:0] state;
    reg [7:0] count;

    parameter [5:0] first = 6'b0000_00;
    parameter [5:0] send_request = 6'b0001_00;
    parameter [5:0] wait_request = 6'b0010_10;
    parameter [5:0] increment = 6'b0011_00;
    parameter [5:0] check_finish = 6'b0100_00;
    parameter [5:0] finish = 6'b0101_01;
    parameter [5:0] idle = 6'b0110_00;
    parameter [5:0] finish_increment = 6'b0111_00;

    parameter [5:0] wait_next_loop = 6'b1000_00;

    assign finished = state[0];
    assign request = state[1];


    always_ff @(posedge clk)
    begin
        case(state)
            first: if(start) state <= send_request;
            wait_next_loop: if(start_next_loop) state <= send_request;


            idle: state <= send_request;
            send_request: state <= wait_request;
            wait_request: if(request_finished) state <= check_finish;
            check_finish: begin 
                if(count == 8'd255)
                    state <= finish;
                else 
                    state <= increment; 
            end
            increment: state <= finish_increment;
            finish_increment: state <= idle; 
            
            finish: state <= wait_next_loop; 
            default: state <= first;
        endcase
    end

    always_ff @(posedge clk)
    begin
        case(state)
            increment: count <= count + 8'b1;
            wait_next_loop: count <= 8'b0;
            default: count <= count;
        endcase
    end

    always_ff @(posedge clk)
    begin
        case(state)
            send_request:
            begin
                address <= count;
                data <= count; 
            end
            wait_next_loop: begin
                address <= 8'b0;
                data <= 8'b0;
            end
            default: begin
                address <= address;
                data <= data;
            end
        endcase
        
    end

endmodule