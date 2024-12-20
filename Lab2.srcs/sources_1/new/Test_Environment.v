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
    
    integer i;
    
    initial begin
        reset = 1;
        in_valid = 0;
        out_ready = 0;
        access_index = 0;
        #10;
        reset = 0;
        
        // Test buffer load sequentially
        $display("Test 1: buffer loading sequentially");
        #10;
        
        for (i = 1; i <= 8; i = i + 1) begin
            in_data = 8'h0 + i;
            in_valid = 1;
            #10;
            in_valid = 0;
            #10;
        end
        
        for (i = 0; i < 8; i = i + 1) begin
            access_index = i;
            out_ready = 1;
            #10;
        
            if (out_valid && out_data == (8'h0 + i + 1)) begin
                $display("Test 1: buffer[%0d] = %h - passed", i, out_data);
            end else begin
                $display("Test 1: buffer[%0d] = %h - failed!", i, out_data);
            end
            out_ready = 0;
        end


        
        // Test buffer correct displacement
        $display("Test 2: correct displacement");

        #10;
        in_data = 8'd52;
        in_valid = 1;
        #10;
        in_valid = 0;
        #10;

        access_index = 0;
        out_ready = 1;
        #10;
        if (out_valid && out_data == 8'd52) begin
            $display("Test 2: buffer[%0d] = %h - passed", access_index, out_data);
        end else begin
            $display("Test 2: buffer[%0d] = %h - failed!", access_index, out_data);
        end
        
        // 3x access to 2'nd element
        for (i = 0; i < 3; i = i + 1) begin
            access_index = 1;
            out_ready = 1;
            #10;
        end
        
        // now buffer must replace 3'rd element
        in_data = 8'd62;
        in_valid = 1;
        #10;
        in_valid = 0;
        #10;
        
        access_index = 2;
        out_ready = 1;
        #10;
        if (out_valid && out_data == 8'd62) begin
            $display("Test 2: buffer[%0d] = %h - passed", access_index, out_data);
        end else begin
            $display("Test 2: buffer[%0d] = %h - passed", access_index, out_data);
        end
        out_ready = 0;
        
        $stop;
    end
endmodule
`endif