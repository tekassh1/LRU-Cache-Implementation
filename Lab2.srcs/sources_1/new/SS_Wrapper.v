module SevenSegment(
    input clk,
    
    input wire [7:0] input_number, 
    input wire io_mode,                     // 0 - output, 1 - input
    input wire [2:0] out_mode_selected_idx,
    input wire input_mode_nums_amount,      // 0 - one number, 1 - two numbers input
    
    output reg [7:0] AN,
    output reg CA,
    output reg CB,
    output reg CC,
    output reg CD,
    output reg CE,   
    output reg CF,
    output reg CG,    
    output reg DP
);
    
    reg [7:0]display_out;
    reg [31:0] counter;
    
    always @* begin
        {CA, CB, CC, CD, CE, CF, CG, DP} = display_out;
    end
    
    always @(posedge clk) begin
        counter <= counter + 1;
        if(counter <= 40000) begin                              AN = 8'b11111110;
            case (input_number[3:0])
                4'b0000: display_out = 8'b00000011;
                4'b0001: display_out = 8'b10011111;  //one
                4'b0010: display_out = 8'b00100101;  //two            
                4'b0011: display_out = 8'b00001101;  //three            
                4'b0100: display_out = 8'b10011001;  //four            
                4'b0101: display_out = 8'b01001001;  //five           
                4'b0110: display_out = 8'b01000001;  //six            
                4'b0111: display_out = 8'b00011111;  //seven            
                4'b1000: display_out = 8'b00000001;  //eight            
                4'b1001: display_out = 8'b00001001;  //nine            
                4'b1010: display_out = 8'b00010001;  //A            
                4'b1011: display_out = 8'b11000001;  //b            
                4'b1100: display_out = 8'b01100011;  //C            
                4'b1101: display_out = 8'b10000101;  //d            
                4'b1110: display_out = 8'b01100001;  //E            
                4'b1111: display_out = 8'b01110001;  //F        
            endcase
        end if(counter > 40000 && counter <= 80000) begin       AN = 8'b11111101;         
            case (input_number[7:4])
                4'b0000:            display_out = 8'b00000011;
                4'b0001:            display_out = 8'b10011111;  //one
                4'b0010:            display_out = 8'b00100101;  //two
                4'b0011:            display_out = 8'b00001101;  //three
                4'b0100:            display_out = 8'b10011001;  //four
                4'b0101:            display_out = 8'b01001001;  //five
                4'b0110:            display_out = 8'b01000001;  //six
                4'b0111:            display_out = 8'b00011111;  //seven
                4'b1000:            display_out = 8'b00000001;  //eight
                4'b1001:            display_out = 8'b00001001;  //nine
                4'b1010:            display_out = 8'b00010001;  //A
                4'b1011:            display_out = 8'b11000001;  //b
                4'b1100:            display_out = 8'b01100011;  //C
                4'b1101:            display_out = 8'b10000101;  //d
                4'b1110:            display_out = 8'b01100001;  //E
                4'b1111:            display_out = 8'b01110001;  //F
            endcase    
        end
        if(counter > 80000 && counter <= 120000) begin          AN = 8'b11111011;
             display_out = 8'b00000011;
        end
        if(counter > 120000 && counter <= 160000) begin         AN = 8'b11110111;
             display_out = 8'b00000011;
        end
        if(counter > 160000 && counter <= 200000) begin         AN = 8'b11101111;
            if (io_mode == 1) begin
                case (input_mode_nums_amount)
                    4'b0000:            display_out = 8'b10011111;  //one
                    4'b0001:            display_out = 8'b00100101;  //two
                endcase
            end
            if (io_mode == 0) begin
                case (out_mode_selected_idx)
                    4'b0000:            display_out = 8'b00000011;
                    4'b0001:            display_out = 8'b10011111;  //one
                    4'b0010:            display_out = 8'b00100101;  //two
                    4'b0011:            display_out = 8'b00001101;  //three
                    4'b0100:            display_out = 8'b10011001;  //four
                    4'b0101:            display_out = 8'b01001001;  //five
                    4'b0110:            display_out = 8'b01000001;  //six
                    4'b0111:            display_out = 8'b00011111;  //seven
                endcase    
            end
        end
        if(counter > 200000 && counter <= 240000) begin          AN = 8'b11011111;
            if (io_mode == 1) begin
                display_out = 8'b00110000; // p
            end 
            if (io_mode == 0) begin
                display_out = 8'b11100000; // t
            end
        end
        if(counter > 240000 && counter <= 280000) begin          AN = 8'b10111111;
            if (io_mode == 1) begin
                display_out = 8'b11010101; // n
            end 
            if (io_mode == 0) begin
                display_out = 8'b11000111; // u
            end
        end
        if(counter > 280000 && counter <= 320000) begin          AN = 8'b01111111;
            if (io_mode == 1) begin
                display_out = 8'b10011111; // I
            end 
            if (io_mode == 0) begin
                display_out = 8'b00000011; // O
            end
        end
        if (counter > 320000) begin
            counter <= 0;    
        end
    end
endmodule