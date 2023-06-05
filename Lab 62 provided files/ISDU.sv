module ISDU (   input logic         Clk, Reset, //(already dealt this)
					 input logic[31:0]   keycode, //(already dealt this)
					 input logic[8:0]		score_1, score_2, // (already dealt this)
				    output logic[1:0]	Display, // 00 means Main Menu, 01 means Game, 10 means P1 Wins, 11 means P2 Wins (Please do this)
					 output logic[2:0] 	Mode,    // 000 means don't play, 001 means play easy, 010 means play medium, 011 means play hard, 100 means play AI.
					 output logic 			valid);

	parameter [8:0] MaxScore = 10;
				
	enum logic [3:0] {Main_Menu,
							Easy_Mode_,
							Easy_Mode,
							Medium_Mode_,
							Medium_Mode,
							Hard_Mode_,
							Hard_Mode,
							AI_Mode,
							AI_Mode_,
							Player_One_Wins,
							Player_Two_Wins}   State, Next_state;
		
	
	always_ff @ (posedge Clk) begin
		if (Reset || ((keycode[7:0] == 8'h29) || (keycode[15:8] == 8'h29) || (keycode[23:16] == 8'h29) || (keycode[31:24] == 8'h29))) 
			State <= Main_Menu;
		else 
			State <= Next_state;
	end
   
	always_comb begin 
		Next_state = State;
		Display = 2'b00;
		Mode = 3'b000;
		valid = 1'b0;
		unique case (State)
			Main_Menu : 
				if (((keycode[7:0] == 8'h1E) || (keycode[15:8] == 8'h1E) || (keycode[23:16] == 8'h1E) || (keycode[31:24] == 8'h1E))) 
					Next_state = Easy_Mode;
				else if (((keycode[7:0] == 8'h1F) || (keycode[15:8] == 8'h1F) || (keycode[23:16] == 8'h1F) || (keycode[31:24] == 8'h1F)))
					Next_state = Medium_Mode;
				else if (((keycode[7:0] == 8'h20) || (keycode[15:8] == 8'h20) || (keycode[23:16] == 8'h20) || (keycode[31:24] == 8'h20)))
					Next_state = Hard_Mode;
				else if (((keycode[7:0] == 8'h21) || (keycode[15:8] == 8'h21) || (keycode[23:16] == 8'h21) || (keycode[31:24] == 8'h21)))
					Next_state = AI_Mode;
				else
					Next_state = Main_Menu;
			Easy_Mode:
				if (keycode == 0)
					Next_state = Easy_Mode_;
				else
					Next_state = Easy_Mode;
			Easy_Mode_ :
				if (score_1 == MaxScore)
					Next_state = Player_One_Wins;
				else if (score_2 == MaxScore)
					Next_state = Player_Two_Wins;
				else
					Next_state = Easy_Mode_;
			Medium_Mode:
				if (keycode == 0)
					Next_state = Medium_Mode_;
				else
					Next_state = Medium_Mode;
			Medium_Mode_ :
				if (score_1 == MaxScore)
					Next_state = Player_One_Wins;
				else if (score_2 == MaxScore)
					Next_state = Player_Two_Wins;
				else
					Next_state = Medium_Mode_;
			Hard_Mode:
				if (keycode == 0)
					Next_state = Hard_Mode_;
				else
					Next_state = Hard_Mode;
			Hard_Mode_ :
				if (score_1 == MaxScore)
					Next_state = Player_One_Wins;
				else if (score_2 == MaxScore)
					Next_state = Player_Two_Wins;
				else
					Next_state = Hard_Mode_;
			AI_Mode:
				if (keycode == 0)
					Next_state = AI_Mode_;
				else
					Next_state = AI_Mode;
			AI_Mode_ :
				if (score_1 == MaxScore)
					Next_state = Player_One_Wins;
				else if (score_2 == MaxScore)
					Next_state = Player_Two_Wins;
				else
					Next_state = AI_Mode_;
			Player_One_Wins :
				Next_state = Player_One_Wins;
			Player_Two_Wins :
				Next_state = Player_Two_Wins;
			default :
				Next_state = Main_Menu;
		endcase
		
		// Assign control signals based on current state
		case (State)
			Main_Menu : 
				begin 
					Display = 2'b00;
					Mode = 3'b000;
				end
			Easy_Mode :
				begin
					Display = 2'b01;
					Mode = 3'b001;
					valid = 1'b0;
				end
			Easy_Mode_ :
				begin
					Display = 2'b01;
					Mode = 3'b001;
					valid = 1'b1;
				end
			Medium_Mode : 
			   begin
					Display = 2'b01;
					Mode = 3'b010;
					valid = 1'b0;
				end
			Medium_Mode_ : 
			   begin
					Display = 2'b01;
					Mode = 3'b010;
					valid = 1'b1;
				end
			Hard_Mode :
				begin
					Display = 2'b01;
					Mode = 3'b011;
					valid = 1'b0;
				end
			Hard_Mode_ :
				begin
					Display = 2'b01;
					Mode = 3'b011;
					valid = 1'b1;
				end
			AI_Mode :
				begin
					Display = 2'b01;
					Mode = 3'b100;
					valid = 1'b0;
				end
			AI_Mode_ :
				begin
					Display = 2'b01;
					Mode = 3'b100;
					valid = 1'b1;
				end
			Player_One_Wins :
				begin
					Display = 2'b10;
					Mode = 3'b000;
				end
			Player_Two_Wins :
				begin
					Display = 2'b11;
					Mode = 3'b000;
				end
			default : Next_state = Main_Menu;
		endcase
	end 

	
endmodule