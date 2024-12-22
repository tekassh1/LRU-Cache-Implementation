`timescale 1ns / 1ps

module Module_Wrapper (          
    input  wire CLK100MHZ,
    input  wire CPU_RESETN,
    
    input wire BTND, // change mode (Input, Output)
    input wire BTNR, // increase buffer index to output (Input mode - one or two numbers input, Output mode - out index)
    input wire BTNC, // Input / Output
    
    input  wire [15:0] SW,
    
    output wire CA,
    output wire CB,
    output wire CC,
    output wire CD,
    output wire CE,
    output wire CF,
    output wire CG,
    output wire DP,
    output wire [7:0] AN
);

    wire clk = CLK100MHZ;
    wire reset = ~CPU_RESETN;
    
    wire io_mode = 1; // 1 - input, 0 - output
    
    wire BTND_debounced;
    wire BTNR_debounced;
    wire BTNC_debounced;
    
    Debouncer BTND_deb (.clk(clk), .reset(reset), .btn_in(BTND), .btn_out_(BTND_debounced));
    Debouncer BTNR_deb (.clk(clk), .reset(reset), .btn_in(BTNR), .btn_out_(BTNR_debounced));
    Debouncer BTNC_deb (.clk(clk), .reset(reset), .btn_in(BTNC), .btn_out_(BTNC_debounced));
    
    wire [7:0] first_number = SW[7:0];
    wire [7:0] second_number = SW[15:8];
    
    wire out_ready; // мы готовы принять данные
    wire in_valid;  // мы готовы отдать данные
    
    wire out_valid; // подмодуль готов отдать данные
    wire in_ready;  // подмодуль готов принять данные
    
    wire [$clog2(8)-1:0] access_index = SW[12:10];
    
    wire [7:0] out_data;

    // Seven Segment bus
    wire [7:0] input_number; 
    wire [3:0] out_mode_selected_idx;
    wire input_mode_nums_amount;      // 0 - one number, 1 - two numbers input


    
    LRU_Buffer #(
        .CACHE_SIZE(8),
        .DATA_SIZE(8),
        .MAX_SIZE(2000)
    ) buffer (
        .clk(CLK100MHZ),
        .reset(reset),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_ready(in_ready),
        .out_data(out_data),
        .out_ready(out_ready),
        .out_valid(out_valid),
        .access_index(access_index)
    );
    
    SevenSegment s_segment (
        .clk(CLK100MHZ),
         
        .input_number(input_number), 
        .io_mode(io_mode),                                    // 1 - input, 0 - output
        .out_mode_selected_idx(out_mode_selected_idx),
        .input_mode_nums_amount(input_mode_nums_amount),      // 0 - one number, 1 - two numbers input
        
        .AN(AN),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),   
        .CF(CF),
        .CG(CG),    
        .DP(DP)
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
        end else begin
            if (io_mode) begin // Input mode
                
            end else begin // Output mode
                
            end 
        end
    end
end
    
endmodule
