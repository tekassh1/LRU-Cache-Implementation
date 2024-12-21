`timescale 1ns / 1ps

module LRU_Buffer #(
    parameter CACHE_SIZE = 8,
    parameter DATA_SIZE = 8,
    parameter MAX_SIZE = 2000
)(
    input wire clk,
    input wire reset,
    
    input wire in_valid,     // источник готов отдать данные
    input wire [DATA_SIZE - 1:0] in_data,
    output reg in_ready,     // мы готовы принять данные с источника
    
    output reg [DATA_SIZE - 1:0] out_data,
    input wire out_ready,    // получатель готов принять данные
    output reg out_valid,    // мы готовы отдать данные
    
    input [$clog2(CACHE_SIZE)-1:0] access_index
);
    
    reg [DATA_SIZE - 1:0] cache_data [0:CACHE_SIZE - 1];
    
    reg [$clog2(MAX_SIZE)-1:0] timestamps[0:CACHE_SIZE - 1];
    
    integer i;
    
    reg [$clog2(CACHE_SIZE)-1:0] replace_index;
    reg [$clog2(MAX_SIZE)-1:0] min_used_time;
    reg [$clog2(MAX_SIZE)-1:0] last_cache_update_time;
    
    always @(posedge clk or posedge reset) begin     
        if (reset) begin
            out_valid <= 0;   // мы не готовы отдать данные
            in_ready <= 1'b0; // мы не готовы принять данные с источника
            
            replace_index = 0;
            min_used_time = 0;
            last_cache_update_time = 0;
            
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                cache_data[i] <= 0;
            end
            
            in_ready <= 1'b1; // мы готовы принять данные с источника
            
        end else begin
            if (in_valid && in_ready) begin
                
                // Ищем наименее приоритетный элемент
                replace_index = 0;
                min_used_time = timestamps[0];
                for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                    if (timestamps[i] < min_used_time) begin
                        min_used_time = timestamps[i];
                        replace_index = i;
                    end
                end
                
                cache_data[replace_index] <= in_data;
                
                // обновляем приоритет
                last_cache_update_time = last_cache_update_time + 1;
                timestamps[replace_index] <= last_cache_update_time;
                
                in_ready <= 1'b0; // мы не готовы принять данные с источника
            end
            if (!in_valid) begin
                in_ready <= 1'b1; // мы готовы принять данные с источника
            end
            

            if (out_ready) begin
                
                out_data <= cache_data[access_index];
                
                // обновляем приоритет
                last_cache_update_time = last_cache_update_time + 1;
                timestamps[access_index] <= last_cache_update_time;
                
                out_valid <= 1'b1;          
            end else begin
                out_valid <= 0; // если источник считал прошлые данные, мы не готовы отдавать новые
            end
        end
    end
    
    // Normalisation to avoid overflow
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                timestamps[i] <= 0;
            end
        end else begin
            if (last_cache_update_time == MAX_SIZE - 1) begin
                for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                    timestamps[i] <= (timestamps[i] / 2048) * CACHE_SIZE;
                end
            end
        end
    end
    
endmodule
