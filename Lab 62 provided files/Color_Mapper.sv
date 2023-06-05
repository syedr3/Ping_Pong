module  color_mapper ( input [9:0] BallX, BallY, DrawX, DrawY, Ball_size, LeftPaddleY, RightPaddleY, PaddleWidth, PaddleHeight, Paddle1x, Paddle2x,
							  input [1:0] Display,
							  input frame_clk, blank,
							  input [8:0] score_1, score_2,
                output logic [7:0]  Red, Green, Blue ); 

logic ball_on; 
logic [3:0] RedME, GreenME, BlueME, RedMM, GreenMM, BlueMM, RedMH, GreenMH, BlueMH, RedP1, GreenP1, BlueP1, RedP2, GreenP2, BlueP2;

// Sprite Instantiation for Menu
menu_example ME(.vga_clk(frame_clk),
				.DrawX(DrawX),
				.DrawY(DrawY),
				.blank(blank),
				.red(RedME),
				.green(GreenME),
				.blue(BlueME));

// Sprite Instantiation for P1 Win Screen				
P1wins_example P1(.vga_clk(frame_clk),
				  .DrawX(DrawX),
				  .DrawY(DrawY),
				  .blank(blank),
				  .red(RedP1),
				  .green(GreenP1),
				  .blue(BlueP1));						

// Sprite Instantiation for P2 Win Screen	  
P2Wins_example P2(.vga_clk(frame_clk),
				  .DrawX(DrawX),
				  .DrawY(DrawY),
				  .blank(blank),
				  .red(RedP2),
				  .green(GreenP2),
				  .blue(BlueP2));

	// Helps determine ball position
    int DistX, DistY, Size;
	assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;

	// Helps Instantiate Score Sprites
	logic shape_on;
	logic [10:0] shape_x = 300;
	logic [10:0] shape_y = 10;
	logic [10:0] shape_size_x = 8; //Same for everything
	logic [10:0] shape_size_y = 16;//Same for everything
	logic [10:0] sprite_addr;
	logic [7:0] sprite_data;
	logic [10:0] sprite_addr2;
	logic [7:0] sprite_data2;
	font_rom asd(.addr(sprite_addr), .data(sprite_data));
	logic shape_on_2;
	logic [10:0] shape_x_2 = 332;
	
	
	// Logic for displaying scores on screen
	always_comb begin:numbers
		if (DrawX >= shape_x && DrawX < shape_x + shape_size_x && DrawY >= shape_y && DrawY < shape_y + shape_size_y) begin
			shape_on = 1'b1;
			sprite_addr = (DrawY-shape_y + 16*(48+score_1));
			shape_on_2 = 1'b0;
		
		end else if (DrawX >= shape_x_2 && DrawX < shape_x_2 + shape_size_x && DrawY >= shape_y && DrawY < shape_y + shape_size_y) begin
			shape_on_2 = 1'b1;
			sprite_addr = (DrawY-shape_y + 16*(48+score_2));
			shape_on = 1'b0;
		
		end else begin
			shape_on = 1'b0;
			sprite_addr = 10'b0;
			shape_on_2 = 1'b0;
		end
	end
	  
	// Logic for displaying Ball on screen (Makes it a square)
    always_comb begin:Ball_on_proc
    	if (DistX >= -Size/2 && DistX <= Size/2 && DistY >= -Size/2 && DistY <= Size/2) begin
    		ball_on = 1'b1;
   		end else begin
    		ball_on = 1'b0;
    	end
  	end
	always_comb begin : RGB_Display
		if (Display == 2'b01 && ball_on) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		
		end else if (Display == 2'b01 && (DrawX >= Paddle1x && DrawX < Paddle1x + PaddleWidth && DrawY >= LeftPaddleY && DrawY < LeftPaddleY + PaddleHeight)) begin
			// Displays left paddle on screen
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		
		end else if (Display == 2'b01 && (DrawX >= Paddle2x && DrawX < Paddle2x + PaddleWidth && DrawY >= RightPaddleY && DrawY < RightPaddleY + PaddleHeight)) begin
			// Displays right paddle on screen
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
     
		end else if (Display == 2'b01 && (DrawY < 5 || DrawY >= 473)) begin
			// White border at top and bottom edges
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;

		end else if (Display == 2'b01 && (DrawX == 320 && DrawY % 10 < 5)) begin
			// Dotted line at middle of screen
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;

		end else if (Display == 2'b01 && ((shape_on == 1'b1) && (sprite_data[7-(DrawX - shape_x)]) == 1'b1)) begin
			// Displays P1 points on screen
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;

		end else if (Display == 2'b01 && ((shape_on_2 == 1'b1) && (sprite_data[7-(DrawX - shape_x_2)]) == 1'b1)) begin
			// Displays P2 points on screen
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		
		end else if(Display == 2'b00) begin
			// Displays main menu
			Red[7:4] = RedME;
			Green[7:4] = GreenME;
			Blue[7:4] = BlueME;
			Red[3:0] = 4'b0;
			Green[3:0] = 4'b0;
			Blue[3:0] = 4'b0;
	  
		end else if(Display == 2'b10) begin
			// Displays P1 win screen
			Red[7:4] = RedP1;
			Green[7:4] = GreenP1;
			Blue[7:4] = BlueP1;
			Red[3:0] = 4'b0;
			Green[3:0] = 4'b0;
			Blue[3:0] = 4'b0;
		
		end else if(Display == 2'b11) begin
			// Displays P2 win screen
			Red[7:4] = RedP2;
			Green[7:4] = GreenP2;
			Blue[7:4] = BlueP2;
			Red[3:0] = 4'b0;
			Green[3:0] = 4'b0;
			Blue[3:0] = 4'b0;
		
		end else begin
			// Makes remaining pixels black if they do not satisfy above if conditions
			Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h00;
	  	end 
	end
endmodule
