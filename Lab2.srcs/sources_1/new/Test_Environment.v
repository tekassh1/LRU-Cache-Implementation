`timescale 1ns / 1ps

`ifndef SYNTHESIS
module Test_Environment();

    parameter CACHE_SIZE = 8;
    parameter DATA_SIZE = 8;

    reg clk;
    reg reset;
    reg in_valid;
    reg [DATA_SIZE - 1:0] in_data;
    reg out_ready;
    reg [$clog2(CACHE_SIZE)-1:0] access_index;

    wire in_ready;
    wire [DATA_SIZE - 1:0] out_data;
    wire out_valid;

    LRU_Buffer #(
        .CACHE_SIZE(CACHE_SIZE),
        .DATA_SIZE(DATA_SIZE)
    ) uut (
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

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Переключение через 5 нс
    end

    initial begin
        reset = 1;
        in_valid = 0;
        out_ready = 0;
        access_index = 0;
        #10;
        reset = 0;

        #10;
        in_valid = 1;
        in_data = 8'hAA;
        #10;
        in_valid = 0;
        #10;

        out_ready = 1;
        access_index = 0;
        #10;

        if (out_valid && out_data == 8'hAA) begin
            $display("Test 1 Passed: Read data %h", out_data);
        end else begin
            $display("Test 1 Failed: Read data %h", out_data);
        end

        #10;
        in_valid = 1;
        in_data = 8'hBB;
        #10;
        in_valid = 0;
        #10;

        access_index = 1;
        out_ready = 1;
        #10;

        if (out_valid && out_data == 8'hBB) begin
            $display("Test 2 Passed: Read data %h", out_data);
        end else begin
            $display("Test 2 Failed: Read data %h", out_data);
        end

        #10;
        in_valid = 1;
        in_data = 8'hCC;
        #10;
        in_valid = 0;
        #10;

        access_index = 0;
        out_ready = 1;
        #10;

        if (out_valid && out_data == 8'hAA) begin
            $display("Test 3 Passed: Read old data %h", out_data);
        end else begin
            $display("Test 3 Failed: Read old data %h", out_data);
        end

        $stop;
    end
endmodule
`endif