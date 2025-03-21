module fsm_loop_3(
    input clk,
    input start,
    input stop,

    // To fsm_mem
    output request,
    output write,
    input request_finished,

    output reg [7:0] address,
    input [7:0] data_in,
    output reg [7:0] data,

    // Key fsm
    output finished,
    output update_key,
    input new_loop,

    // D mem: 
    output [7:0] address_d,
    output [7:0] data_d,
    output wren_d,

    // M mem: (Only ever need to read)
    output [7:0] address_m,
    input [7:0] q_m,

    // can set these as just reg, set as output for debugging
    output reg [4:0] k, // Up to 32  
    output reg [7:0] i,
    output reg [7:0] j,
    
    output reg [7:0] f, // putting f here since its not an index, but a data value
    output reg [7:0] data_i,
    output reg [7:0] data_j,
    //output reg [7:0] data_d,
    output reg [7:0] data_m

);

// Instanciating d, m memory, since only loop3 uses them, keeping them localized here


    wire [7:0] data_m_signal; 
    assign data_m_signal = q_m;

    assign address_m = k; 
    assign address_d = k; 

    reg [9:0] state;
    parameter [9:0] first         = 10'b00000_00_0_0_0;
    parameter [9:0] idle          = 10'b00001_00_0_0_0;
    parameter [9:0] assign_i      = 10'b00010_00_0_0_0;
    parameter [9:0] read_i        = 10'b00011_01_0_0_0;
    parameter [9:0] assign_j      = 10'b00100_00_0_0_0;
    parameter [9:0] read_j        = 10'b00101_01_0_0_0;
    parameter [9:0] write_i_to_j  = 10'b00110_11_0_0_0;
    parameter [9:0] write_j_to_i  = 10'b00111_11_0_0_0;
    parameter [9:0] read_f        = 10'b01000_01_0_0_0;
    parameter [9:0] decrypt_reg   = 10'b01001_00_0_0_0;
    parameter [9:0] check_finish  = 10'b01011_00_0_0_1;
    parameter [9:0] assign_k      = 10'b01010_00_0_0_0;
    parameter [9:0] reset         = 10'b01100_00_0_1_0;
    parameter [9:0] finish        = 10'b01101_00_1_0_0;
    

    // M mem
    assign wren_d = state[0];

    // Key control
    assign update_key = state[1];
    assign finished = state[2];

    // Mem fsm
    assign request = state[3];
    assign write = state[4];

    

    always_ff @(posedge clk)
    begin
        case(state)
            first: if(start) state <= idle; 
            idle: state <= assign_i;
            assign_i: state <= read_i;
            read_i: if(request_finished) state <= assign_j;
            assign_j: state <= read_j;
            read_j: if(request_finished) state <= write_i_to_j;
            write_i_to_j: if(request_finished) state <= write_j_to_i;
            write_j_to_i: if(request_finished) state <= read_f;
            read_f: if(request_finished) state <= decrypt_reg;
            decrypt_reg: state <= check_finish; 

            check_finish: begin 
                                
                if(( 8'd122 < data_d || data_d < 8'd97) && data_d != 8'd32)
                    state <= reset;
                else if(k == 5'd31)
                    state <= finish;
                else
                    state <= assign_k;
            end

            reset: if(new_loop) state <= first;

            assign_k: state <= idle; // end of for loop
            finish: state <= finish;

            default: state <= first;

        endcase
    end

    // Assign i,j,k
    always_ff @(posedge clk)
    begin
        case(state)
            assign_i: i <= i + 1'b1;
            assign_j: j <= j + data_i;
            assign_k: k <= k + 1'b1;
            first: begin
                k <= 5'b0;
                i <= 8'b0;
                j <= 8'b0;
            end
            default: begin
                i <= i;
                j <= j;
                k <= k;
            end

        endcase
    end

    always_ff @(posedge clk)
    begin
        case(state)
            read_i: begin
                address <=  i;
                data_i <= data_in;
            end
            read_j: begin
                address <= j;
                data_j <= data_in;
            end
            
            write_i_to_j: begin
                data <= data_i;
                address <= j; // address should already be j but good to double check?
            end
            write_j_to_i: begin
                data <= data_j;
                address <= i;
            end

            read_f: begin
                address <= data_i + data_j;
                f <= data_in;
            end

            default: 
            begin
                address <= address;
                data_i <= data_i;
                data_j <= data_j;
                data <= data;
                f <= f;
            end

        endcase
    end

    always_ff @(posedge clk)
    begin
        case(state)
            decrypt_reg: begin data_d <= f ^ data_m; end
            default: begin data_d <= data_d; end
        endcase     

    end

    always_ff @(posedge clk)
    begin
        data_m <= data_m_signal;
    end


endmodule