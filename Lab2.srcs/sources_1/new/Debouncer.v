`timescale 1ns / 1ps

module Debouncer(
    input clk,
    input reset,
    
    input btn_in,
    output reg btn_out
);

    reg [17:0] counter;
    reg btn_in_d1;
    reg btn_in_d2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            btn_in_d1 <= 0;
            btn_in_d2 <= 0;
            btn_out <= 0;
        end else begin
        
            btn_in_d1 <= btn_in;
            btn_in_d2 <= btn_in_d1;

            if (btn_in_d2 == btn_in_d1) begin
                if (counter < 100000) begin
                    counter <= counter + 1;
                end else begin
                    btn_out <= btn_in_d2;
                end
            end else begin
                counter <= 0;
            end
        end
    end

endmodule
