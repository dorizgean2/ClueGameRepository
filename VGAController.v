`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	input BTND, 
	input BTNU, 
	input BTNL, 
	input BTNR,
	input BTNC,
	input [3:0] SW,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/jtf45/Desktop/ClueGameRepository-main/Sprites/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd, busy, error;
	wire[9:0] x, square1_topx, square2_topx;
	wire[8:0] y, square1_topy, square2_topy;

	reg[9:0] square1_x, square2_x, square3_x, square4_x;
	reg[9:0] square1_y, square2_y, square3_y, square4_y;
	reg btnd_press, btnu_press, btnl_press, btnr_press;
	reg[7:0] hold_scan;
	reg square1, square2, square3, square4;
	wire data_rdy;
	wire[7:0] ascii_value, sprite1, sprite2, scan_code;
	reg square1_move, square2_move, square3_move, square4_move;
	wire BTND_out, BTNU_out, BTNL_out, BTNR_out, button_out;
	wire[31:0] processor_return;
	reg[31:0] processor_other;
	
    assign square1_topx = x-(square1_x-20);
    assign square1_topy = y-(square1_y-20);
    assign square2_topx = x-(square2_x-20);
    assign square2_topy = y-(square2_y-20);
    
	debounce_better_version debouncey1(.pb_1(BTND), .clk(clk), .pb_out(BTND_out));
	debounce_better_version debouncey2(.pb_1(BTNU), .clk(clk), .pb_out(BTNU_out));
	debounce_better_version debouncey3(.pb_1(BTNL), .clk(clk), .pb_out(BTNL_out));
	debounce_better_version debouncey4(.pb_1(BTNR), .clk(clk), .pb_out(BTNR_out));
	assign button_out = {BTND_out || BTNU_out || BTNL_out || BTNR_out};
	Wrapper proc (.clock(clk), .reset(reset), .button_in(button_out), .processor_out(processor_return));
    
	initial begin
		square1_x = 400;
		square1_y = 30;
		
		square2_x = 240;
		square2_y = 30;
				
		square3_x = 520;
		square3_y = 150;
		
		square4_x = 180;
		square4_y = 300;
		
		square1_move = 0;
		square2_move = 0;
		square3_move = 0;
		square4_move = 0;
		
		processor_other = 32'b0;
	end
	
	
	always @(posedge screenEnd) begin
	   if (SW[0] == 1'b1)
	       square1_move = 1'b1;
	   if (SW[0] == 1'b0)
	       square1_move = 1'b0;       
	   if (SW[1] == 1'b1)
	       square2_move = 1'b1;
	   if (SW[1] == 1'b0)
	       square2_move = 1'b0;
	   if (SW[2] == 1'b1)
	       square3_move = 1'b1; 
	   if (SW[2] == 1'b0)
	       square3_move = 1'b0;    
	   if (SW[3] == 1'b1)
	       square4_move = 1'b1;
	   if (SW[3] == 1'b0)
	       square4_move = 1'b0;
	     
	end
	
	always @(posedge screenEnd) begin //need to find a way so that the sprites only move one grid when pressed down
	   if (BTND == 1'b1)
	       btnd_press = 1'b1;
	   if (BTND == 1'b0)
	       btnd_press = 1'b0;       
	   if (BTNU == 1'b1)
	       btnu_press = 1'b1;
	   if (BTNU == 1'b0)
	       btnu_press = 1'b0;
	   if (BTNL == 1'b1)
	       btnl_press = 1'b1; 
	   if (BTNL == 1'b0)
	       btnl_press = 1'b0;    
	   if (BTNR == 1'b1)
	       btnr_press = 1'b1;
	   if (BTNR == 1'b0)
	       btnr_press = 1'b0;
	     
	end
	
	   always @(posedge screenEnd) begin
            if (square1_move == 1'b1) begin
                if(BTND == 1'b1) 
                    square1_y = square1_y + 1;
                    
                if(BTNU == 1'b1) 
                    square1_y = square1_y - 1;
                    
                if(BTNL == 1'b1) 
                    square1_x = square1_x - 1;
                    
                if(BTNR == 1'b1) 
                    square1_x = square1_x + 1;
	   end
	end
	
		always @(posedge screenEnd) begin
            if (square2_move == 1'b1) begin
                if(BTND == 1'b1) 
                    square2_y = square2_y + 1;
                    
                if(BTNU == 1'b1) 
                    square2_y = square2_y - 1;
                    
                if(BTNL == 1'b1) 
                    square2_x = square2_x - 1;
                    
                if(BTNR == 1'b1) 
                    square2_x = square2_x + 1;
	   end
	end
	
	
	
    always @(posedge screenEnd) begin
        if (square3_move == 1'b1) begin
            if(BTND == 1'b1) 
                square3_y = square3_y + 1;
                
            if(BTNU == 1'b1) 
                square3_y = square3_y - 1;
                
            if(BTNL == 1'b1) 
                square3_x = square3_x - 1;
                
            if(BTNR == 1'b1) 
                square3_x = square3_x + 1;
	   end
	end
	
	
	
	always @(posedge screenEnd) begin
	   if (square4_move == 1'b1) begin
            if(BTND == 1'b1) 
                square4_y = square4_y + 1;
                
            if(BTNU == 1'b1) 
                square4_y = square4_y - 1;
                
            if(BTNL == 1'b1) 
                square4_x = square4_x - 1;
                
            if(BTNR == 1'b1) 
                square4_x = square4_x + 1;
       end
	end
	
	always @(posedge screenEnd) begin
	   if (BTND == 1'b1) 
	       processor_other = 32'b0;
	   if (BTND == 1'b1) 
	       processor_other = 32'b1;
	      
	end
	
	
	
    
	always @(posedge screenEnd) begin
	   if (square1 == 1'b1) begin
           if (processor_other == 32'b1)
                to_appear = sprite_1_data;
           else 
                to_appear = 12'd5;
           end
    end
	
	assign to_appear_sprite_1 = to_appear;
	
//	Ps2Interface ps2(ps2_clk, ps2_data, clk, 1'b0, 1'b0, 1'b0, scan_code, data_rdy, busy, error);
	
//	always @(posedge clk) begin
//	   if (data_rdy == 1'b1)
//	       hold_scan = scan_code;
//	end
	
//    RAM #(.DATA_WIDTH(7), .ADDRESS_WIDTH(8), .DEPTH(256), .MEMFILE("ascii.mem")) ram_ascii(clk, 1'b0, hold_scan, 1'b0, ascii_value);

//  if ( x == 1 ) 
//      if(left button)
//          x = 4 
//  if (x < 4) 
//      if (right button)
//          x = x + 1 
//      if (left button)
//          x = x - 1 
//  if x = 4 
//      if (right button)
//          x = 1 
//  if (btnc) 
//     wrapper ( clk, reset, button_in = x, processor_return = accusionation correct or not)
	always @(posedge clk25) begin
		if (x < square1_x + 10  && y < square1_y + 10 && x > square1_x - 10 && y > square1_y - 10)
            square1 = 1'b1;         
		else
			square1 = 1'b0;
	end
	
	always @(posedge clk25) begin
		if (x < square2_x + 10  && y < square2_y + 10 && x > square2_x - 10 && y > square2_y - 10)
            square2 = 1'b1;                
		else
			square2 = 1'b0;
	end
	
	always @(posedge clk25) begin
		if (x < square3_x + 10  && y < square3_y + 10 && x > square3_x - 10 && y > square3_y - 10)
            square3 = 1'b1;                
		else
			square3 = 1'b0;
	end
	
		always @(posedge clk25) begin
		if (x < square4_x + 10  && y < square4_y + 10 && x > square4_x - 10 && y > square4_y - 10)
            square4 = 1'b1;                
		else
			square4 = 1'b0;
	end

	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	

    wire[PIXEL_ADDRESS_WIDTH-1:0] sprite_1_Address, sprite_2_Address, sprite_3_Address, sprite_4_Address;  
    wire[PALETTE_ADDRESS_WIDTH-1:0] sprite_1_colorAddr, sprite_2_colorAddr, sprite_3_colorAddr, sprite_4_colorAddr, dice_prompt_colorAddr;
    wire[BITS_PER_COLOR-1:0] sprite_1_data, sprite_2_data, sprite_3_data, sprite_4_data, to_appear_sprite_1;
    reg[BITS_PER_COLOR-1:0] to_appear;
    assign sprite_1_Address = ((x-square1_x-10)) + ((y-square1_y+10)*20);	
    assign sprite_2_Address = ((x-square2_x-10)) + ((y-square2_y+10)*20);	
    assign sprite_3_Address = ((x-square3_x-10)) + ((y-square3_y+10)*20);	
    assign sprite_4_Address = ((x-square4_x-10)) + ((y-square4_y+10)*20);	

    RAM #(.DATA_WIDTH(PALETTE_ADDRESS_WIDTH), .ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH), .DEPTH(400), .MEMFILE("red_sprite_image.mem")) ram_sprites1(.clk(clk), .wEn(1'b0), .addr(sprite_1_Address), .dataOut(sprite_1_colorAddr));
    RAM #(.DATA_WIDTH(12), .ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH), .DEPTH(256), .MEMFILE("red_sprite_colors.mem")) ram_sprites_color1(.clk(clk), .wEn(1'b0), .addr(sprite_1_colorAddr), .dataOut(sprite_1_data));
    
    RAM #(.DATA_WIDTH(PALETTE_ADDRESS_WIDTH), .ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH), .DEPTH(400), .MEMFILE("purple_sprite_image.mem")) ram_sprites2(.clk(clk), .wEn(1'b0), .addr(sprite_2_Address), .dataOut(sprite_2_colorAddr));
    RAM #(.DATA_WIDTH(12), .ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH), .DEPTH(256), .MEMFILE("purple_sprite_colors.mem")) ram_sprites_color2(.clk(clk), .wEn(1'b0), .addr(sprite_2_colorAddr), .dataOut(sprite_2_data));
   
    RAM #(.DATA_WIDTH(PALETTE_ADDRESS_WIDTH), .ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH), .DEPTH(400), .MEMFILE("green_sprite_image.mem")) ram_sprites3(.clk(clk), .wEn(1'b0), .addr(sprite_3_Address), .dataOut(sprite_3_colorAddr));
    RAM #(.DATA_WIDTH(12), .ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH), .DEPTH(256), .MEMFILE("green_sprite_colors.mem")) ram_sprites_color3(.clk(clk), .wEn(1'b0), .addr(sprite_3_colorAddr), .dataOut(sprite_3_data));
    
    RAM #(.DATA_WIDTH(PALETTE_ADDRESS_WIDTH), .ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH), .DEPTH(400), .MEMFILE("pink_sprite_image.mem")) ram_sprites4(.clk(clk), .wEn(1'b0), .addr(sprite_4_Address), .dataOut(sprite_4_colorAddr));
    RAM #(.DATA_WIDTH(12), .ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH), .DEPTH(256), .MEMFILE("pink_sprite_colors.mem")) ram_sprites_color4(.clk(clk), .wEn(1'b0), .addr(sprite_4_colorAddr), .dataOut(sprite_4_data));
    
    // prompts
//    RAM #(.DATA_WIDTH(PALETTE_ADDRESS_WIDTH), .ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH), .DEPTH(400), .MEMFILE("dice_prompt_image.mem")) dice_prompt(.clk(clk), .wEn(1'b0), .addr(sprite_4_Address), .dataOut(dice_prompt_colorAddr));
//    RAM #(.DATA_WIDTH(12), .ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH), .DEPTH(256), .MEMFILE("dice_prompt_colors.mem")) ram_sprites_color4(.clk(clk), .wEn(1'b0), .addr(sprite_4_colorAddr), .dataOut(sprite_4_data));
	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? colorData : 12'd0; // When not active, output black
	// Quickly assign the output colors to their channels using active

	assign {VGA_R, VGA_G, VGA_B} = square1 ? to_appear_sprite_1 : square2 ? sprite_2_data : square3 ? sprite_3_data : square4 ? sprite_4_data : colorOut;
	//assign {VGA_R, VGA_G, VGA_B} = 12'd0;
endmodule