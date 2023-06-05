module pong(
    input Reset, frame_clk, valid,
    input [31:0] keycode,
	input [2:0] Mode,
    output reg [9:0] BallX, BallY, BallSize, 
    output reg [9:0] Paddle1Y, Paddle2Y, 
    output reg [8:0] Score1, Score2,
	output reg [9:0] PaddleWidth_, PaddleHeight_, Paddle1x_, Paddle2x_
);
    parameter [9:0] BallXCenter = 320;
    parameter [9:0] BallYCenter = 240;
    parameter [9:0] BallXMin = 0;
    parameter [9:0] BallXMax = 639;
    parameter [9:0] BallYMin = 5; 
    parameter [9:0] BallYMax = 473; 
    parameter [9:0] BallXStep = 2;
    parameter [9:0] BallYStep = 2;
    parameter [9:0] PaddleWidth = 10;
    parameter [9:0] PaddleHeight = 50;
    parameter [9:0] Paddle1X = 10;
    parameter [9:0] Paddle2X = 620;

    reg [9:0] BallXPos, BallYPos, BallXMotion, BallYMotion, BallSpeed;
    reg [9:0] Paddle1YPos, Paddle2YPos, Paddle2Y_AI;
    reg [8:0] Score1Reg, Score2Reg;
    reg start_game;
	 reg last_paddle_hit;
    assign BallSize = 4;
    
	always_ff @(posedge Reset or posedge frame_clk) begin
        //Reset Condition 
		if (Reset) begin
            BallXMotion <= 0;
            BallYMotion <= 0;
            BallXPos <= BallXCenter;
            BallYPos <= BallYCenter;
            Paddle1YPos <= BallYCenter;
            Paddle2YPos <= BallYCenter;
            Score1Reg <= 0;
            Score2Reg <= 0;
            start_game <= 0;
        end
        else begin
            // If Start, Player 1/2 Win Page, initialize all components
			if (Mode == 3'b00) begin
				BallXMotion <= 0;
				BallYMotion <= 0;
				BallXPos <= BallXCenter;
				BallYPos <= BallYCenter;
				Paddle1YPos <= BallYCenter;
				Paddle2YPos <= BallYCenter;
				Score1Reg <= 0;
				Score2Reg <= 0;
				start_game <= 0;
				BallSpeed <= 0;
			end

            else if (!start_game && (keycode != 0) && valid != 0) begin // Resets positions until a key is pressed (reset after each point)
				if (Mode == 3'b001) begin // Easy Mode Logic
                	start_game <= 1;               
					if (Score1 == Score2) begin // Determines where ball starts
						BallXMotion <= -BallXStep;
						BallYMotion <= -BallYStep;
					end
					
					else if (Score1 > Score2) begin
						if (Paddle2YPos < 240) begin
							BallXMotion <= BallXStep;
							BallYMotion <= -BallYStep;
						end

						else begin
							BallXMotion <= BallXStep;
							BallYMotion <= BallYStep;
						end
					end
					
					else if (Score1 < Score2) begin
						if (Paddle1YPos < 240) begin
							BallXMotion <= -BallXStep;
							BallYMotion <= -BallYStep;
						end

						else begin
							BallXMotion <= -BallXStep;
							BallYMotion <= BallYStep;
						end
					end
					// Which player gets point
					last_paddle_hit <= 1; 
					BallSpeed <= 2'b01;

				end 
						
				else if (Mode == 3'b010) begin // Medium Mode Logic
					start_game <= 1;

					if (Score1 == Score2) begin
						BallXMotion <= -BallXStep;
						BallYMotion <= -BallYStep;
					end

					else if (Score1 > Score2) begin
						if (Paddle2YPos < 240) begin
							BallXMotion <= BallXStep;
							BallYMotion <= -BallYStep;
						end

						else begin
							BallXMotion <= BallXStep;
							BallYMotion <= BallYStep;
						end
					end

					else if (Score1 < Score2) begin
						if (Paddle1YPos < 240) begin
							BallXMotion <= -BallXStep;
							BallYMotion <= -BallYStep;
						end
						
						else begin
							BallXMotion <= -BallXStep;
							BallYMotion <= BallYStep;
						end
					end

					 last_paddle_hit <= 1;
					 BallSpeed <= 2'b10;
				end 

				else if (Mode == 3'b011) begin // Hard Mode Logic
					start_game <= 1;

					if (Score1 == Score2) begin
						BallXMotion <= -BallXStep;
						BallYMotion <= -BallYStep;
					end

					else if (Score1 > Score2) begin
						if (Paddle2YPos < 240) begin
							BallXMotion <= BallXStep;
							BallYMotion <= -BallYStep;
						end
						else begin
							BallXMotion <= BallXStep;
							BallYMotion <= BallYStep;
						end
					end

					else if (Score1 < Score2) begin
						if (Paddle1YPos < 240) begin
							BallXMotion <= -BallXStep;
							BallYMotion <= -BallYStep;
						end
						else begin
							BallXMotion <= -BallXStep;
							BallYMotion <= BallYStep;
						end
					end
					 last_paddle_hit <= 1;
					 BallSpeed <= 2'b11;
				end

				else begin //AI Mode (Easter Egg)
					start_game <= 1; 
					
					if (Score1 == Score2) begin
						BallXMotion <= -BallXStep;
						BallYMotion <= -BallYStep;
					end

					else if (Score1 > Score2) begin
						if (Paddle2YPos < 240) begin
							BallXMotion <= BallXStep;
							BallYMotion <= -BallYStep;
						end
						else begin
							BallXMotion <= BallXStep;
							BallYMotion <= BallYStep;
						end
					end

					else if (Score1 < Score2) begin
						if (Paddle1YPos < 240) begin
							BallXMotion <= -BallXStep;
							BallYMotion <= -BallYStep;
						end
						else begin
							BallXMotion <= -BallXStep;
							BallYMotion <= BallYStep;
						end
					end
					
					last_paddle_hit <= 1;
					BallSpeed <= 2'b10;
				end
			end

            // Update ball position
			if (Mode != 3'b00) begin
				BallXPos <= BallXPos + (BallXMotion * BallSpeed);
				BallYPos <= BallYPos + (BallYMotion * BallSpeed);
			end

            // Check for ball collision with walls
			if ((Mode != 3'b00) && (BallYPos + BallSize) >= BallYMax )  // Ball is at the bottom edge, BOUNCE!
				BallYMotion <= (~ (BallYStep) + 1'b1);  // 2's complement.
					  
			else if ( (Mode != 2'b00) && (BallYPos - BallSize) <= BallYMin )  // Ball is at the top edge, BOUNCE!
				BallYMotion <= BallYStep;




            // Checks if ball is out of bounds & updates score
            if ((Mode != 3'b0) && (BallXPos <= BallXMin || BallXPos >= BallXMax) && last_paddle_hit) begin
            	Score2Reg <= Score2Reg + 1;
			end
				
			if ((Mode != 3'b00) && (BallXPos <= BallXMin || BallXPos >= BallXMax) && !last_paddle_hit) begin
				Score1Reg <= Score1Reg + 1;
			end
				
			if ((Mode != 3'b00) && (BallXPos <= BallXMin || BallXPos >= BallXMax)) begin
				BallXPos <= BallXCenter;
				BallYPos <= BallYCenter;
				BallXMotion <= 0;
				BallYMotion <= 0;
				start_game <= 0;
			end

			// Checks for collision with left paddle
            if ((Mode != 3'b00) && (BallXPos - BallSize <= Paddle1X + PaddleWidth) && (BallYPos >= Paddle1YPos) && (BallYPos <= Paddle1YPos + PaddleHeight) && (Mode != 2'b00)) begin
                BallXMotion <= BallXStep;
				last_paddle_hit <= 0;
            end

			// Checks for collision with right paddle
            if ((Mode != 3'b00) && (BallXPos + BallSize >= Paddle2X) && (BallYPos >= Paddle2YPos) && (BallYPos <= Paddle2YPos + PaddleHeight) && (Mode != 2'b00)) begin
                BallXMotion <= -BallXStep;
				last_paddle_hit <= 1;
            end

			// update paddle positions based on keyboard input
			if ((Mode != 3'b00) && ((keycode[7:0] == 8'h16) || (keycode[15:8] == 8'h16) || (keycode[23:16] == 8'h16) || (keycode[31:24] == 8'h16)) && Paddle1YPos < BallYMax - PaddleHeight) begin
				Paddle1YPos <= Paddle1YPos + 5; //S
			end
			
			if ((Mode != 3'b00) && ((keycode[7:0] == 8'h1A) || (keycode[15:8] == 8'h1A) || (keycode[23:16] == 8'h1A) || (keycode[31:24] == 8'h1A)) && Paddle1YPos > 0) begin
				Paddle1YPos <= Paddle1YPos - 5; //W 8'h1A
			end

			if ((Mode != 3'b00) && (Mode != 3'b100) && ((keycode[7:0] == 8'h0F) || (keycode[15:8] == 8'h0F) || (keycode[23:16] == 8'h0F) || (keycode[31:24] == 8'h0F)) && Paddle2YPos < BallYMax - PaddleHeight) begin
				Paddle2YPos <= Paddle2YPos + 5; //L 8'h0F
			end
			  
			if ((Mode != 3'b00) && (Mode != 3'b100) && ((keycode[7:0] == 8'h12) || (keycode[15:8] == 8'h12) || (keycode[23:16] == 8'h12) || (keycode[31:24] == 8'h12)) && Paddle2YPos > 0) begin
				Paddle2YPos <= Paddle2YPos - 5; //O 8'h12
			end
			  
			if (Mode == 3'b100) begin
				if (BallYPos < Paddle2YPos + PaddleHeight/2) begin
					Paddle2Y_AI = Paddle2YPos - 5; // AI Paddle  logic (up)
				end

				else if (BallYPos > Paddle2YPos + PaddleHeight/2) begin
					Paddle2Y_AI = Paddle2YPos + 5; // AI Paddle logic (down)
				end

				if (Paddle2Y_AI > Paddle2YPos) begin
					Paddle2YPos <= Paddle2YPos + 5; // AI Paddle delay logic (down)
				end

				else if (Paddle2Y_AI < Paddle2YPos) begin
					Paddle2YPos <= Paddle2YPos - 5; // AI Paddle delay logic (up)
				end
			end
		 end
	end

	assign BallX = BallXPos;
	assign BallY = BallYPos;
	assign Paddle1Y = Paddle1YPos;
	assign Paddle2Y = Paddle2YPos;
	assign Score1 = Score1Reg;
	assign Score2 = Score2Reg;
	assign PaddleWidth_ =  PaddleWidth;
	assign PaddleHeight_ = PaddleHeight;
	assign Paddle1x_ =  Paddle1X;
	assign Paddle2x_ = Paddle2X;

endmodule

