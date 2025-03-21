module ksa(
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output [9:0] LEDR,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5
);
    ////////////////////////////////////////////////////
    ////////////////////// CORE_1 //////////////////////
    ////////////////////////////////////////////////////

    decryption_core core_1 (
        .clk(CLOCK_50),
        .start(!KEY[3]),
        .key_ctrl(key_control_signal_1),
        .update_key_o(update_key_signal_1),
        .end_3_o(end_3_signal_1),
        .start_loop_i(start_loop_signal_1),
        .address_s_o(address_s_signal_1),
        .data_s_o(data_s_signal_1),
        .wren_s_o(wren_s_signal_1),
        .q_s_i(q_s_signal_1),
        .address_d_o(address_d_signal_1),
        .data_d_o(data_d_signal_1),
        .wren_d_o(wren_d_signal_1),
        .address_m_o(address_m_signal_1),
        .q_m_i(q_m_signal_1)
    );
    // S mem
    wire [7:0] address_s_signal_1;
    wire [7:0] data_s_signal_1;
    wire [7:0] q_s_signal_1;
    wire wren_s_signal_1;
    // D mem
    wire [7:0] address_d_signal_1;
    wire [7:0] data_d_signal_1;
    wire wren_d_signal_1;
    // M mem
    wire [7:0] address_m_signal_1;
    wire [7:0] q_m_signal_1;

    s_memory mem_s_1(
        .address(address_s_signal_1),
        .clock(CLOCK_50),
        .data(data_s_signal_1),
        .wren(wren_s_signal_1),
        .q(q_s_signal_1)
    );

    m_memory mem_m_1(
        .address(address_m_signal_1),
        .clock(CLOCK_50),
        .q(q_m_signal_1)
    );

    d_memory mem_d_1(
        .address(address_d_signal_1),
        .clock(CLOCK_50),
        .data(data_d_signal_1),
        .wren(wren_d_signal_1), // Only have to write to d_mem
    );

    // Key control wires
    wire update_key_signal_1;
    wire end_3_signal_1;
    wire [23:0] key_control_signal_1; 
    wire start_loop_signal_1;

    ////////////////////////////////////////////////////
    ////////////////////// CORE_2 //////////////////////
    ////////////////////////////////////////////////////

    decryption_core core_2 (
        .clk(CLOCK_50),
        .start(!KEY[3]), 
        .key_ctrl(key_control_signal_2),
        .update_key_o(update_key_signal_2),
        .end_3_o(end_3_signal_2),
        .start_loop_i(start_loop_signal_2),
        .address_s_o(address_s_signal_2),
        .data_s_o(data_s_signal_2),
        .wren_s_o(wren_s_signal_2),
        .q_s_i(q_s_signal_2),
        .address_d_o(address_d_signal_2),
        .data_d_o(data_d_signal_2),
        .wren_d_o(wren_d_signal_2),
        .address_m_o(address_m_signal_2),
        .q_m_i(q_m_signal_2)
    );
    // S mem
    wire [7:0] address_s_signal_2;
    wire [7:0] data_s_signal_2;
    wire [7:0] q_s_signal_2;
    wire wren_s_signal_2;
    // D mem
    wire [7:0] address_d_signal_2;
    wire [7:0] data_d_signal_2;
    wire wren_d_signal_2;
    // M mem
    wire [7:0] address_m_signal_2;
    wire [7:0] q_m_signal_2;

    s_memory mem_s_2(
        .address(address_s_signal_2),
        .clock(CLOCK_50),
        .data(data_s_signal_2),
        .wren(wren_s_signal_2),
        .q(q_s_signal_2)
    );

    m_memory mem_m_2(
        .address(address_m_signal_2),
        .clock(CLOCK_50),
        .q(q_m_signal_2)
    );

    d_memory mem_d_2(
        .address(address_d_signal_2),
        .clock(CLOCK_50),
        .data(data_d_signal_2),
        .wren(wren_d_signal_2), // Only have to write to d_mem
    );

    // Key control wires
    wire update_key_signal_2;
    wire end_3_signal_2;
    wire [23:0] key_control_signal_2; 
    wire start_loop_signal_2;

    ////////////////////////////////////////////////////
    ////////////////////// CORE_3 //////////////////////
    ////////////////////////////////////////////////////

    decryption_core core_3 (
        .clk(CLOCK_50),
        .start(!KEY[3]), 
        .key_ctrl(key_control_signal_3),
        .update_key_o(update_key_signal_3),
        .end_3_o(end_3_signal_3),
        .start_loop_i(start_loop_signal_3),
        .address_s_o(address_s_signal_3),
        .data_s_o(data_s_signal_3),
        .wren_s_o(wren_s_signal_3),
        .q_s_i(q_s_signal_3),
        .address_d_o(address_d_signal_3),
        .data_d_o(data_d_signal_3),
        .wren_d_o(wren_d_signal_3),
        .address_m_o(address_m_signal_3),
        .q_m_i(q_m_signal_3)
    );
    // S mem
    wire [7:0] address_s_signal_3;
    wire [7:0] data_s_signal_3;
    wire [7:0] q_s_signal_3;
    wire wren_s_signal_3;
    // D mem
    wire [7:0] address_d_signal_3;
    wire [7:0] data_d_signal_3;
    wire wren_d_signal_3;
    // M mem
    wire [7:0] address_m_signal_3;
    wire [7:0] q_m_signal_3;

    s_memory mem_s_3(
        .address(address_s_signal_3),
        .clock(CLOCK_50),
        .data(data_s_signal_3),
        .wren(wren_s_signal_3),
        .q(q_s_signal_3)
    );

    m_memory mem_m_3(
        .address(address_m_signal_3),
        .clock(CLOCK_50),
        .q(q_m_signal_3)
    );

    d_memory mem_d_3(
        .address(address_d_signal_3),
        .clock(CLOCK_50),
        .data(data_d_signal_3),
        .wren(wren_d_signal_3), // Only have to write to d_mem
    );

    // Key control wires
    wire update_key_signal_3;
    wire end_3_signal_3;
    wire [23:0] key_control_signal_3; 
    wire start_loop_signal_3;

    ////////////////////////////////////////////////////
    ////////////////////// CORE_4 //////////////////////
    ////////////////////////////////////////////////////

    decryption_core core_4 (
        .clk(CLOCK_50),
        .start(!KEY[3]), 
        .key_ctrl(key_control_signal_4),
        .update_key_o(update_key_signal_4),
        .end_3_o(end_3_signal_4),
        .start_loop_i(start_loop_signal_4),
        .address_s_o(address_s_signal_4),
        .data_s_o(data_s_signal_4),
        .wren_s_o(wren_s_signal_4),
        .q_s_i(q_s_signal_4),
        .address_d_o(address_d_signal_4),
        .data_d_o(data_d_signal_4),
        .wren_d_o(wren_d_signal_4),
        .address_m_o(address_m_signal_4),
        .q_m_i(q_m_signal_4)
    );
    // S mem
    wire [7:0] address_s_signal_4;
    wire [7:0] data_s_signal_4;
    wire [7:0] q_s_signal_4;
    wire wren_s_signal_4;
    // D mem
    wire [7:0] address_d_signal_4;
    wire [7:0] data_d_signal_4;
    wire wren_d_signal_4;
    // M mem
    wire [7:0] address_m_signal_4;
    wire [7:0] q_m_signal_4;

    s_memory mem_s_4(
        .address(address_s_signal_4),
        .clock(CLOCK_50),
        .data(data_s_signal_4),
        .wren(wren_s_signal_4),
        .q(q_s_signal_4)
    );

    m_memory mem_m_4(
        .address(address_m_signal_4),
        .clock(CLOCK_50),
        .q(q_m_signal_4)
    );

    d_memory mem_d_4(
        .address(address_d_signal_4),
        .clock(CLOCK_50),
        .data(data_d_signal_4),
        .wren(wren_d_signal_4), // Only have to write to d_mem
    );

    // Key control wires
    wire update_key_signal_4;
    wire end_3_signal_4;
    wire [23:0] key_control_signal_4; 
    wire start_loop_signal_4;

    ////////////////////////////////////////////////////
    ///////////////////// KEY_CTRL /////////////////////
    ////////////////////////////////////////////////////

    fsm_key_control uut (
        .clk(CLOCK_50),
        .update_request_1(update_key_signal_1),
        .update_request_2(update_key_signal_2),
        .update_request_3(update_key_signal_3),
        .update_request_4(update_key_signal_4),
        .end_3_1(end_3_signal_1),
        .end_3_2(end_3_signal_2),
        .end_3_3(end_3_signal_3),
        .end_3_4(end_3_signal_4),
        .key(key_control_global),
        .key_1(key_control_signal_1),
        .key_2(key_control_signal_2),
        .key_3(key_control_signal_3),
        .key_4(key_control_signal_4),
        .start_loop_1(start_loop_signal_1),
        .start_loop_2(start_loop_signal_2),
        .start_loop_3(start_loop_signal_3),
        .start_loop_4(start_loop_signal_4),
        .led0(LEDR[0]),
        .led9(LEDR[1])
    );

    // 7 Seg Displays

    wire [3:0] digit_5;
    wire [3:0] digit_4;
    wire [3:0] digit_3;
    wire [3:0] digit_2;
    wire [3:0] digit_1;
    wire [3:0] digit_0;
    wire [23:0] key_control_global;

    assign digit_5 = key_control_global[23:20];
    assign digit_4 = key_control_global[19:16];
    assign digit_3 = key_control_global[15:12];
    assign digit_2 = key_control_global[11:8];
    assign digit_1 = key_control_global[7:4];
    assign digit_0 = key_control_global[3:0];

    SevenSegmentDisplayDecoder d5(
        .ssOut(HEX5),
        .nIn(digit_5)
    );
    
    SevenSegmentDisplayDecoder d4(
        .ssOut(HEX4),
        .nIn(digit_4)
    );

    SevenSegmentDisplayDecoder d3(
        .ssOut(HEX3),
        .nIn(digit_3)
    );

    SevenSegmentDisplayDecoder d2(
        .ssOut(HEX2),
        .nIn(digit_2)
    );

    SevenSegmentDisplayDecoder d1(
        .ssOut(HEX1),
        .nIn(digit_1)
    );

    SevenSegmentDisplayDecoder d0(
        .ssOut(HEX0),
        .nIn(digit_0)
    );
    

endmodule