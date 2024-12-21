`timescale 1ns / 1ps

module Module_Wrapper (
    input  wire [15:0] SW,           
    input  wire CLK100MHZ,
    input  wire CPU_RESETN,

    output wire CA,
    output wire CB,
    output wire CC,
    output wire CD,
    output wire CE,
    output wire CF,
    output wire CG,
    output wire [7:0] AN
);

    wire clk = CLK100MHZ;
    wire reset = ~CPU_RESETN;
    
    wire in_valid = SW[0];
    wire [7:0] in_data = SW[8:1];
    wire out_ready = SW[9];
    wire [$clog2(8)-1:0] access_index = SW[12:10];
    
    wire [7:0] out_data;
    wire out_valid;
    wire in_ready;

    LRU_Buffer #(
        .CACHE_SIZE(8),
        .DATA_SIZE(8),
        .MAX_SIZE(2000)
    ) buffer_inst (
        .clk(clk),
        .reset(reset),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_ready(in_ready),
        .out_data(out_data),
        .out_ready(out_ready),
        .out_valid(out_valid),
        .access_index(access_index)
    );

endmodule
