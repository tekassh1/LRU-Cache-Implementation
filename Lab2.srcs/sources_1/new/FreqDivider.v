`timescale 1ns / 1ps

module FreqDivider(
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg toggle;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            toggle <= 1'b0;
            clk_out <= 1'b0;
        end else begin
            toggle <= ~toggle;
            clk_out <= toggle;
        end
    end
endmodule