`timescale 1ns / 1ps

module LRU_Buffer #(
    parameter CACHE_SIZE = 8,
    parameter DATA_SIZE = 8
)(
    input wire clk,
    input wire reset,
    
    input wire in_valid,     // источник готов отдать данные
    input wire [7:0] in_data,
    output reg in_ready,     // мы готовы принять данные с источника
    
    output reg [7:0] out_data,
    input wire out_ready,    // получатель готов принять данные
    input wire [2:0] req_idx,
    output reg out_valid     // мы готовы отдать данные
);

    reg [7:0] in_data_reg [0:CACHE_SIZE-1];
    reg [7:0] out_data_reg [0:CACHE_SIZE-1];
    reg [7:0] cache_data [0:CACHE_SIZE-1];
    reg [2:0] req_idx_reg;
    
    integer i;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            req_idx_reg <= 0;
            in_ready <= 1'b1;
            out_valid <= 0;
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                in_data_reg[i] <= 0;
                out_data_reg[i] <= 0;
                cache_data[i] <= 0;
            end
        end else begin
            if (in_valid) begin
                out_valid <= 0;
                in_ready <= 0;
                
                // process...
                            
                out_valid <= 1'b1;
                in_ready <= 1'b1;
            end
            if (out_ready) begin
                out_valid <= 0;
                in_ready <= 0;
                
                out_data <= cache_data[req_idx_reg];
                
                out_valid <= 1'b1;
                in_ready <= 1'b1;
            end
        end
    end

endmodule
