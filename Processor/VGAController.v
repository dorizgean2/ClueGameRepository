`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 25 MHz System Clock
	input reset, 		// Reset Signal
	input BTND_in,         // Debounced BTND
	input BTNU_in,         // Debounced BTNU
	input BTNL_in,         // Debounced BTNL
	input BTNR_in,         // Debounced BTNR
	input BTNC_in,         // Debounced BTNC
	input [3:0] SW,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data,
	input from_processor,
	output to_processor);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/jtf45/Desktop/ClueGameRepository-main/Sprites/";
	
	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480, // Standard VGA Height
		MAX_MOVEMENT = 5,
		LOWER_Y_BOUNDARY = 30,
		UPPER_Y_BOUNDARY = 450,
	    LOWER_X_BOUNDARY = 100,
	    UPPER_X_BOUNDARY = 520;

	wire active, screenEnd, busy, error;
	wire[9:0] x, square1_topx, square2_topx;
	wire[8:0] y, square1_topy, square2_topy;

	reg[9:0] square1_x, square2_x, square3_x, square4_x, dice_prompt_x, dice_data_x;
	reg[9:0] square1_y, square2_y, square3_y, square4_y, dice_prompt_y, dice_data_y;
	
    reg[9:0] hall_x, study_x, lounge_x, kitchen_x, library_x, billard_x, conservatory_x, ballroom_x, dining_x;
	reg[9:0] hall_y, study_y, lounge_y, kitchen_y, library_y, billard_y, conservatory_y, ballroom_y, dining_y;
	
	reg btnd_press, btnu_press, btnl_press, btnr_press;
	reg[7:0] hold_scan;
	
	reg square1, square2, square3, square4, roll_dice_ques, show_dice;
	reg show_hall, show_study, show_lounge, show_kitchen, show_library, show_billard, show_conservatory, show_ballroom, show_dining;
	
	reg dice1, dice2, dice3, dice4, dice5, dice6;
	wire data_rdy;
	wire[7:0] ascii_value, sprite1, sprite2, scan_code;
	reg square1_move, square2_move, square3_move, square4_move;
	reg[31:0] processor_return;

    // HALL : 100 x 150
    always @(posedge clk) begin
	   if (x < hall_x + 50 && y < hall_y + 75 && x > hall_x - 50 && y > hall_y - 75)
            show_hall = 1'b1;                
		else
			show_hall = 1'b0;
	end
	
    // STUDY : 100 x 150
    always @(posedge clk) begin
	   if (x < study_x + 75 && y < study_y + 50 && x > study_x - 75 && y > study_y - 50)
            show_study = 1'b1;                
		else
			show_study = 1'b0;
	end
	
    // LOUNGE : 100 x 100
    always @(posedge clk) begin
	   if (x < lounge_x + 50 && y < lounge_y + 50 && x > lounge_x - 50 && y > lounge_y - 50)
            show_lounge = 1'b1;                
		else
			show_lounge = 1'b0;
	end
	
    // KITCHEN : 150 x 100
    always @(posedge clk) begin
	   if (x < kitchen_x + 75 && y < kitchen_y + 75 && x > kitchen_x - 50 && y > kitchen_y - 75)
            show_kitchen = 1'b1;                
		else
			show_kitchen = 1'b0;
	end
	
    // LIBRARY : 100 x 150
    always @(posedge clk) begin
	   if (x < library_x + 75 && y < library_y + 50 && x > library_x - 75 && y > library_y - 50)
            show_library = 1'b1;                
		else
			show_library = 1'b0;
	end
	
    // BILLARD ROOM : 100 x 100
    always @(posedge clk) begin
	   if (x < billard_x + 50 && y < billard_y + 50 && x > billard_x - 50 && y > billard_y - 50)
            show_billard = 1'b1;                
		else
			show_billard = 1'b0;
	end
	
    // CONSERVATORY : 100 x 100
    always @(posedge clk) begin
	   if (x < conservatory_x + 75 && y < conservatory_y + 75 && x > conservatory_x - 50 && y > conservatory_y - 75)
            show_conservatory = 1'b1;                
		else
			show_conservatory = 1'b0;
	end
	
    // BALL ROOM : 150 x 150
    always @(posedge clk) begin
	   if (x < ballroom_x + 75 && y < ballroom_y + 50 && x > ballroom_x - 75 && y > ballroom_y - 50)
            show_ballroom = 1'b1;                
		else
			show_ballroom = 1'b0;
	end
	
    // DINING ROOM : 100 x 150
    always @(posedge clk) begin
	   if (x < dining_x + 75 && y < dining_y + 50 && x > dining_x - 75 && y > dining_y - 50)
            show_dining = 1'b1;                
		else
			show_dining = 1'b0;
	end
    

	initial begin
		square1_x = 400;
		square1_y = 30;
		
		square2_x = 280;
		square2_y = 440;
				
		square3_x = 520;
		square3_y = 150;
		
		square4_x = 120;
		square4_y = 340;
		
		hall_x = 320;
		hall_y = 75;
		
		study_x = 150;
		study_y = 50;
		
		lounge_x = 475;
		lounge_y = 75;
	   
	    kitchen_x = 480;
		kitchen_y = 415;
		
		library_x = 160;
		library_y = 180;
		
		billard_x = 160;
		billard_y = 280;
		
		conservatory_x = 135;
		conservatory_y = 440;
		
		ballroom_x = 320;
		ballroom_y = 375;
		
		dining_x = 480;
		dining_y = 230;
		
		dice_prompt_x = VIDEO_WIDTH/2;
		dice_prompt_y = VIDEO_HEIGHT/2;
				
		dice_data_x = 611;
		dice_data_y = 25;
		
		square1_move = 0;
		square2_move = 0;
		square3_move = 0;
		square4_move = 0;
		
		dice1 = 1'b0;
        dice2 = 1'b0;
        dice3 = 1'b0;
        dice4 = 1'b0;
        dice5 = 1'b0;
        dice6 = 1'b0;
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
	
	   always @(posedge screenEnd) begin
            if (square1_move == 1'b1) begin
                if(BTND_in == 1'b1) 
                    if(square1_y + 1 < UPPER_Y_BOUNDARY)
                        square1_y = square1_y + MAX_MOVEMENT;
                if(BTNU_in == 1'b1) 
                    if(square1_y - 1 > LOWER_Y_BOUNDARY)
                        square1_y = square1_y - MAX_MOVEMENT;
                if(BTNL_in == 1'b1) 
                    if(square1_x - 1 > LOWER_X_BOUNDARY)
                        square1_x = square1_x - MAX_MOVEMENT;
                if(BTNR_in == 1'b1) 
                    if(square1_x + 1 < UPPER_X_BOUNDARY)
                        square1_x = square1_x + MAX_MOVEMENT;
	   end
	end
	
		always @(posedge screenEnd) begin
            if (square2_move == 1'b1) begin
                if(BTND_in == 1'b1) 
                    if(square2_y + 1 < UPPER_Y_BOUNDARY)
                        square2_y = square2_y + MAX_MOVEMENT;
                        
                if(BTNU_in == 1'b1) 
                    if(square2_y - 1 > LOWER_Y_BOUNDARY)
                        square2_y = square2_y - MAX_MOVEMENT;
                    
                if(BTNL_in == 1'b1) 
                    if(square2_x - 1 > LOWER_X_BOUNDARY)
                        square2_x = square2_x - MAX_MOVEMENT;
                    
                if(BTNR_in == 1'b1) 
                    if(square2_x + 1 < UPPER_X_BOUNDARY)
                        square2_x = square2_x + MAX_MOVEMENT;
	   end
	end
	
	
    always @(posedge screenEnd) begin
        if (square3_move == 1'b1) begin
            if(BTND_in == 1'b1) 
                if(square3_y + 1 < UPPER_Y_BOUNDARY)
                    square3_y = square3_y + MAX_MOVEMENT;
                
            if(BTNU_in == 1'b1) 
                if(square3_y - 1 > LOWER_Y_BOUNDARY)
                    square3_y = square3_y - MAX_MOVEMENT;
                
            if(BTNL_in == 1'b1) 
                if(square3_x - 1 > LOWER_X_BOUNDARY)
                square3_x = square3_x - MAX_MOVEMENT;
                
            if(BTNR_in == 1'b1) 
                if(square3_x + 1 < UPPER_X_BOUNDARY)
                    square3_x = square3_x + MAX_MOVEMENT;
	   end
	end 
	
	
	always @(posedge screenEnd) begin
	   if (square4_move == 1'b1) begin
            if(BTND_in == 1'b1) 
                if(square4_y + 1 < UPPER_Y_BOUNDARY)
                    square4_y = square4_y + MAX_MOVEMENT;
                
            if(BTNU_in == 1'b1) 
                if(square4_y - 1 > LOWER_Y_BOUNDARY)
                    square4_y = square4_y - MAX_MOVEMENT;
                
            if(BTNL_in == 1'b1) 
                if(square4_x - 1 > LOWER_X_BOUNDARY)
                    square4_x = square4_x - MAX_MOVEMENT;
                
            if(BTNR_in == 1'b1) 
                if(square4_x + 1 < UPPER_X_BOUNDARY)
                    square4_x = square4_x + MAX_MOVEMENT;
       end
	end
	
	
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

	always @(posedge clk) begin
		if (x < square1_x + 10  && y < square1_y + 10 && x > square1_x - 10 && y > square1_y - 10)
            square1 = 1'b1;         
		else
			square1 = 1'b0;
	end
	
	always @(posedge clk) begin
		if (x < square2_x + 10  && y < square2_y + 10 && x > square2_x - 10 && y > square2_y - 10)
            square2 = 1'b1;                
		else
			square2 = 1'b0;
	end
	
	always @(posedge clk) begin
		if (x < square3_x + 10  && y < square3_y + 10 && x > square3_x - 10 && y > square3_y - 10)
            square3 = 1'b1;                
		else
			square3 = 1'b0;
	end
	
	always @(posedge clk) begin
		if (x < square4_x + 10  && y < square4_y + 10 && x > square4_x - 10 && y > square4_y - 10)
            square4 = 1'b1;                
		else
			square4 = 1'b0;
	end
	
	always @(posedge clk) begin
		if (x < dice_prompt_x + 106 && y < dice_prompt_y + 28 && x > dice_prompt_x - 106 && y > dice_prompt_y - 28 && from_processor == 32'b0)
            roll_dice_ques = 1'b1;                
		else
			roll_dice_ques = 1'b0;
	end
	
	always @(posedge clk) begin
		if (x < dice_data_x + 29 && y < dice_data_y + 25 && x > dice_data_x - 29 && y > dice_data_y - 25)
            show_dice = 1'b1;                
		else
			show_dice = 1'b0;
	end
	

	
    always @(posedge clk) begin
        if (from_processor != 32'b0)
	       processor_return = from_processor;
	end
	
	always @(posedge clk) begin
	  
        if (processor_return == 32'd1) begin
            dice1 = 1'b1;
            dice2 = 1'b0;
            dice3 = 1'b0;
            dice4 = 1'b0;
            dice5 = 1'b0;
            dice6 = 1'b0;
        end
            
        if (processor_return == 32'd2) begin
            dice1 = 1'b0;
            dice2 = 1'b1;
            dice3 = 1'b0;
            dice4 = 1'b0;
            dice5 = 1'b0;
            dice6 = 1'b0;
        end
            
        if (processor_return == 32'd3) begin
            dice1 = 1'b0;
            dice2 = 1'b0;
            dice3 = 1'b1;
            dice4 = 1'b0;
            dice5 = 1'b0;
            dice6 = 1'b0;
        end 
            
        if (processor_return == 32'd4) begin
            dice1 = 1'b0;
            dice2 = 1'b0;
            dice3 = 1'b0;
            dice4 = 1'b1;
            dice5 = 1'b0;
            dice6 = 1'b0;
        end
            
        if (processor_return == 32'd5) begin
            dice1 = 1'b0;
            dice2 = 1'b0;
            dice3 = 1'b0;
            dice4 = 1'b0;
            dice5 = 1'b1;
            dice6 = 1'b0;
        end
            
        if (processor_return == 32'd6) begin
            dice1 = 1'b0;
            dice2 = 1'b0;
            dice3 = 1'b0;
            dice4 = 1'b0;
            dice5 = 1'b0;
            dice6 = 1'b1;
        end
       
	end

<<<<<<< HEAD
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   
=======
	// VGATimingGenerator #(
	// 	.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
	// 	.WIDTH(VIDEO_WIDTH))
	// Display( 
	// 	.clk25(clk),  	   // 25MHz Pixel Clock
	// 	.reset(reset),		   // Reset Signal
	// 	.screenEnd(screenEnd), // High for one cycle when between two frames
	// 	.active(active),	   // High when drawing pixels
	// 	.hSync(hSync),  	   // Set Generated H Signal
	// 	.vSync(vSync),		   // Set Generated V Signal
	// 	.x(x), 				   // X Coordinate (from left)
	// 	.y(y)); 			   // Y Coordinate (from top)	   
>>>>>>> ed0da3f (new dice mem)

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

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel


    wire[PIXEL_ADDRESS_WIDTH-1:0] sprite_1_Address, sprite_2_Address, sprite_3_Address, sprite_4_Address, dice_roll_Address, dice_Address;  
    wire[PIXEL_ADDRESS_WIDTH-1:0] dice1_Address, dice2_Address, dice3_Address, dice4_Address, dice5_Address, dice6_Address, clue_Address;
    wire[PALETTE_ADDRESS_WIDTH-1:0] sprite_1_colorAddr, sprite_2_colorAddr, sprite_3_colorAddr, sprite_4_colorAddr, dice_prompt_colorAddr, dice_colorAddr;
    wire[BITS_PER_COLOR-1:0] sprite_1_data, sprite_2_data, sprite_3_data, sprite_4_data, to_appear_sprite_1, dice_prompt_data, dice_data;
	wire[BITS_PER_COLOR-1:0] hall_data, study_data, lounge_data, kitchen_data, library_data, billard_data, conservatory_data, ballroom_data, dining_data;
    
    assign sprite_1_Address = ((x-square1_x-10)) + ((y-square1_y+10)*20);	
    assign sprite_2_Address = ((x-square2_x-10)) + ((y-square2_y+10)*20);	
    assign sprite_3_Address = ((x-square3_x-10)) + ((y-square3_y+10)*20);	
    assign sprite_4_Address = ((x-square4_x-10)) + ((y-square4_y+10)*20);	
    
    assign dice_roll_Address = ((x-dice_prompt_x-106)) + ((y-dice_prompt_y+28)*212);
    
    assign dice1_Address = ((x-dice_data_x-29)) + ((y-dice_data_y+25)*58);
    assign dice2_Address = ((x-dice_data_x-29)) + ((y-dice_data_y+75)*58);
    assign dice3_Address = ((x-dice_data_x-29)) + ((y-dice_data_y+125)*58);
    assign dice4_Address = ((x-dice_data_x-29)) + ((y-dice_data_y+175)*58);
    assign dice5_Address = ((x-dice_data_x-29)) + ((y-dice_data_y+225)*58);
    assign dice6_Address = ((x-dice_data_x-29)) + ((y-dice_data_y+275)*58);
    
    assign dice_Address = dice1 ? dice1_Address : dice2 ? dice2_Address : dice3 ? dice3_Address : dice4 ? dice4_Address : dice5 ? dice5_Address : dice6_Address;
	
	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	
	assign colorOut = active ? colorData : 12'd0; // When not active, output black

	assign hall_data = 12'd10;
	assign study_data = 12'd50;
	assign lounge_data = 12'd100;
	assign kitchen_data = 12'd500;
	assign library_data = 12'd1000;
	assign billard_data = 12'd1500;
	assign conservatory_data = 12'd2000;
	assign billard_data = 12'd2500;
	assign dining_data = 12'd3000;
	
	
//	wire random;
//	assign random = 1'b1;
	// Quickly assign the output colors to their channels using active
	
	assign {VGA_R, VGA_G, VGA_B} = show_dice ? dice_data : roll_dice_ques ? dice_prompt_data : square1 ? sprite_1_data : square2 ? sprite_2_data : square3 ? sprite_3_data : square4 ? sprite_4_data : colorOut;
//	assign {VGA_R, VGA_G, VGA_B} = show_hall ? hall_data : show_study ? study_data : show_lounge ? lounge_data : show_kitchen ? kitchen_data : show_library ? library_data : show_billard ? billard_data : show_conservatory ? conservatory_data : show_ballroom ? ballroom_data : show_dining ? dining_data : colorOut;
<<<<<<< HEAD
endmodule
=======
endmodule
>>>>>>> ed0da3f (new dice mem)
