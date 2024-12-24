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
    reg [CACHE_SIZE-1:0] access_matrix [0:CACHE_SIZE-1];
    
    integer i;
    integer j;
    
    reg [3:0] zeroes_count [7:0];
    reg [3:0] max_zeroes;
    
    reg [$clog2(CACHE_SIZE)-1:0] replace_index;
    
    always @(posedge clk or posedge reset) begin     
        if (reset) begin
            out_valid = 0;   // мы не готовы отдать данные
            in_ready = 1'b0; // мы не готовы принять данные с источника
            
            zeroes_count[0] = 4'b0;
            zeroes_count[1] = 4'b0;
            zeroes_count[2] = 4'b0;
            zeroes_count[3] = 4'b0;
            zeroes_count[4] = 4'b0;
            zeroes_count[5] = 4'b0;
            zeroes_count[6] = 4'b0;
            zeroes_count[7] = 4'b0;
            
            cache_data[0] = 8'b0;
            cache_data[1] = 8'b0;
            cache_data[2] = 8'b0;
            cache_data[3] = 8'b0;
            cache_data[4] = 8'b0;
            cache_data[5] = 8'b0;
            cache_data[6] = 8'b0;
            cache_data[7] = 8'b0;

            access_matrix[0] = 8'b0;
            access_matrix[1] = 8'b0;
            access_matrix[2] = 8'b0;
            access_matrix[3] = 8'b0;
            access_matrix[4] = 8'b0;
            access_matrix[5] = 8'b0;
            access_matrix[6] = 8'b0;
            access_matrix[7] = 8'b0;
            
            max_zeroes = 4'b0;
            replace_index = 3'b0;
            
            in_ready = 1'b1; // мы готовы принять данные с источника
            
        end else begin
            
            if (in_valid && in_ready) begin
                
                // Ищем наименее приоритетный элемент
                replace_index = 3'b0;
                max_zeroes = 4'b0;
                
                for (i = 0; i < 8; i = i + 1) begin
                    zeroes_count[i] = 
                        (access_matrix[i][0] == 0) + 
                        (access_matrix[i][1] == 0) + 
                        (access_matrix[i][2] == 0) + 
                        (access_matrix[i][3] == 0) + 
                        (access_matrix[i][4] == 0) + 
                        (access_matrix[i][5] == 0) + 
                        (access_matrix[i][6] == 0) + 
                        (access_matrix[i][7] == 0);
                end
                
                for (i = 0; i < 8; i = i + 1) begin
                    if (zeroes_count[i] > max_zeroes) begin
                        max_zeroes = zeroes_count[i];
                        replace_index = i;
                    end
                end 
                
                // Обновляем приоритет
                for (i = 0; i < 8; i = i + 1) begin
                    access_matrix[replace_index][i] <= 1'b1;
                    access_matrix[i][replace_index] <= 1'b0;
                end
                access_matrix[replace_index][replace_index] <= 1'b0;
            
                // Обновляем данные в кэше
                cache_data[replace_index] <= in_data;
                in_ready <= 1'b0; // Мы не готовы принять данные с источника

            end
            if (!in_valid) begin
                in_ready <= 1'b1; // мы готовы принять данные с источника
            end
            

            if (out_ready) begin
                
                out_data <= cache_data[access_index];
                
                // обновляем приоритет
                for (i = 0; i < 8; i = i + 1) begin
                    access_matrix[access_index][i] <= 1'b1;
                    access_matrix[i][access_index] <= 1'b0;
                end
                access_matrix[access_index][access_index] <= 1'b0;
                
                out_valid <= 1'b1;          
            end else begin
                out_valid <= 0; // если источник считал прошлые данные, мы не готовы отдавать новые
            end
        end
    end
    
endmodule
