`timescale 1ns / 1ps

module Module_Wrapper (          
    input  wire CLK100MHZ,
    input  wire CPU_RESETN,
    
    input wire BTND, // change mode (Input, Output)
    input wire BTNR, // increase number (Input mode - one or two numbers input, Output mode - out index)
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
    
    wire BTND_debounced;
    wire BTNR_debounced;
    wire BTNC_debounced;
    
    Debouncer BTND_deb (.clk(clk), .reset(reset), .btn_in(BTND), .btn_out(BTND_debounced));
    Debouncer BTNR_deb (.clk(clk), .reset(reset), .btn_in(BTNR), .btn_out(BTNR_debounced));
    Debouncer BTNC_deb (.clk(clk), .reset(reset), .btn_in(BTNC), .btn_out(BTNC_debounced));
    
    reg io_mode; // 1 - input, 0 - output
    
    wire [7:0] first_number = SW[7:0];
    wire [7:0] second_number = SW[15:8];
    
    reg out_ready; // мы готовы принять данные
    reg in_valid;  // мы готовы отдать данные
    
    wire out_valid; // подмодуль готов отдать данные
    wire in_ready;  // подмодуль готов принять данные
    
    wire [$clog2(8)-1:0] access_index;
    
    wire [7:0] buffer_out_data;
    reg [7:0] buffer_in_data;
    
    // Seven Segment bus
    reg [7:0] input_number; 
    reg [2:0] out_mode_selected_idx;
    
    reg input_mode_nums_amount;      // 0 - one number, 1 - two numbers input
    reg first_number_written;
    
    LRU_Buffer #(
        .CACHE_SIZE(8),
        .DATA_SIZE(8),
        .MAX_SIZE(2000)
    ) buffer (
        .clk(CLK100MHZ),
        .reset(reset),
        .in_valid(in_valid),
        .in_data(buffer_in_data),
        .in_ready(in_ready),
        .out_data(buffer_out_data),
        .out_ready(out_ready),
        .out_valid(out_valid),
        .access_index(out_mode_selected_idx)
    );
    
    SevenSegment s_segment (
        .clk(CLK100MHZ),
         
        .input_number(buffer_out_data), 
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
            in_valid <= 0;
            out_ready <= 0;
            io_mode <= 1'b1;
            first_number_written <= 0;
        end else begin
        
            if (BTND_debounced) begin
                io_mode <= ~io_mode;
                out_ready <= 0;
                in_valid <= 0;
            end
            if (BTNR_debounced) begin
                if (io_mode == 0) begin                   // Output
                    if (out_mode_selected_idx == 7) begin
                        out_mode_selected_idx <= 0;
                    end else begin
                        out_mode_selected_idx <= out_mode_selected_idx + 1;
                    end
                end else begin                            // Input
                    input_mode_nums_amount <= ~input_mode_nums_amount;
                end
            end
            
            // Main logic processing
            if (BTNC_debounced) begin
                if (io_mode) begin                                             // Input mode
                    if (in_ready) begin
                        if (!input_mode_nums_amount) begin // Input one number
                            buffer_in_data <= first_number;
                            in_valid <= 1;
                        end else begin                                         // Input two numbers
                            if (!first_number_written) begin
                                buffer_in_data <= first_number;
                                in_valid <= 1;
                                first_number_written <= 1'b1;
                            end else begin
                                buffer_in_data <= second_number;
                                in_valid <= 1;
                                first_number_written <= 0;
                            end
                        end
                    end else begin
                        in_valid <= 0;
                    end
                end else begin                                                 // Output mode
                    out_ready <= 1;
                    if (out_valid) begin
                        out_ready <= 0;
                    end
                end
            end
        end
    end
    
endmodule
