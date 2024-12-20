`timescale 1ns / 1ps

module PriorityMatrix #(
    parameter N = 8
)(
    input clk,
    input reset,
    
    input wire in_valid,     // источник готов отдать данные
    output reg in_ready,     // мы готовы принять данные с источника
    
    input wire out_ready,    // получатель готов принять данные
    output reg out_valid,    // мы готовы отдать данные
    
    input access,
    input [$clog2(N)-1:0] access_index,
    
    input get_raplace,
    output [$clog2(N)-1:0] access_index
);
    reg [N-1:0] priority_matrix [N-1:0];
    
    integer i, j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            in_ready <= 
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    priority_matrix[i][j] <= (i == j) ? 1'b0: 1'b1;
                end
            end
        end else begin
            if (access) begin
                for (i = 0; i < N; i = i + 1) begin
                    if (access_index != i) begin
                        priority_matrix[access_index][i] <= 1'b1;
                        priority_matrix[i][access_index] <= 1'b0;
                    end
                end
            end else if ()
        end
    end


endmodule