module decryption_core(

    input clk,
    input start,
    input [23:0] key_ctrl,

    output update_key_o,
    output end_3_o,
    input start_loop_i,

    // S mem:
    output [7:0] address_s_o,
    output [7:0] data_s_o,
    output wren_s_o,
    input [7:0] q_s_i,

    // D mem: 
    output [7:0] address_d_o,
    output [7:0] data_d_o,
    output wren_d_o,
    // dont actually need this one
    // input [7:0] q_d_o,

    // M mem: (Only ever need to read)
    output [7:0] address_m_o,
    input [7:0] q_m_i
);

    fsm_mem mem_inst (
        .clk(clk),
        // S mem, direct output
        .wren_s(wren_s_o),
        .q_s(q_s_i),
        .data_s(data_s_o),
        .address_s(address_s_o), 

        .data_1(data_1_signal),
        .data_2(data_2_signal),
        .data_3(data_3_signal),
        .data_2_out(data_2_in_signal),
        .data_3_out(data_3_in_signal),
        .address_1(address_1_signal),
        .address_2(address_2_signal),
        .address_3(address_3_signal),
        .request_1(request_1_signal),
        .request_2(request_2_signal),
        .request_3(request_3_signal),
        .wrt_2(write_2_signal),
        .wrt_3(write_3_signal),
        .finished_1(request_finish_1_signal),
        .finished_2(request_finish_2_signal),
        .finished_3(request_finish_3_signal)
    );

    // To fsm_mem
    wire request_finish_1_signal;
    wire request_1_signal;
    wire [7:0] address_1_signal;
    wire [7:0] data_1_signal; 

    // To loop 2 fsm
    wire finished_loop_1;

    fsm_loop_1 loop_1_inst (
        .clk(clk), 
        .start(start), 
        .start_next_loop(start_loop_i), // Direct input
        .request_finished(request_finish_1_signal), 
        .request(request_1_signal), 
        .address(address_1_signal), 
        .data(data_1_signal),
        .finished(finished_loop_1)
    );

    // To fsm_mem
    wire request_2_signal;
    wire write_2_signal;
    wire request_finish_2_signal;
    wire [7:0] address_2_signal;
    wire [7:0] data_2_in_signal;
    wire [7:0] data_2_signal; 

    // To loop 3 fsm
    wire finished_loop_2;

    fsm_loop_2 loop_2_inst (
        .clk(clk), 
        .key(key_ctrl), // key_control_signal when ready to test.
        .start(finished_loop_1), //finished_loop_1
        .request(request_2_signal), 
        .write(write_2_signal), 
        .request_finished(request_finish_2_signal), 
        .address(address_2_signal), 
        .data_in(data_2_in_signal), 
        .data(data_2_signal),
        .finished(finished_loop_2) // Out to loop 3 fsm
    );

    // To fsm_mem
    wire request_3_signal;
    wire write_3_signal;
    wire request_finish_3_signal;
    wire [7:0] address_3_signal;
    wire [7:0] data_3_in_signal;
    wire [7:0] data_3_signal; 

    fsm_loop_3 loop_3_inst (
        .clk(clk),
        .start(finished_loop_2),
        .request(request_3_signal),
        .write(write_3_signal),
        .request_finished(request_finish_3_signal),
        .address(address_3_signal),
        .data_in(data_3_in_signal),
        .data(data_3_signal),
        .finished(end_3_o),
        .update_key(update_key_o),
        .new_loop(start_loop_i),
        // D mem
        .address_d(address_d_o),
        .data_d(data_d_o),
        .wren_d(wren_d_o),
        // Q mem
        .address_m(address_m_o),
        .q_m(q_m_i)
    );

endmodule