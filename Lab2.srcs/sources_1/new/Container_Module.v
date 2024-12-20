//`timescale 1ns / 1ps

//module Container_Module(
//    input clk,
//    input reset,
    
//    output [6:0] seven_segment,
      
//    input in_valid, // источник готов отдать данные
//    output in_ready, // мы готовы принять данные с источника
    
//    output out_valid, // мы готовы отдать данные
//    input out_ready, // получатель готов принять данные
      
//    input [15:0] sw   
//);
    
//assign first_number = sw[7:0];
//assign second_number = sw[15:8];

//wire [7:0] in_data;
//wire [7:0] out_data;

//wire [2:0] req_idx;

//LRU_Buffer #(
//    .CACHE_SIZE(8), 
//    .DATA_SIZE(8)
//) lru_buffer (
//    .clk(clk),
//    .reset(reset),
//    .in_valid(in_valid),
//    .in_data(in_data),
//    .in_ready(in_ready),
//    .out_valid(out_valid),
//    .out_ready(out_ready),
//    .req_idx(req_idx),
//    .out_data(out_data)
//);
 
//endmodule
