------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library work;
use work.TetrisLib.all;
use work.VGALib.all;

entity Tetris is
    port (
        clock_100           : in  std_logic;
		
		BTN_Reset			: in  std_logic;
		BTN_MoveLeft		: in  std_logic;
		BTN_MoveRight		: in  std_logic;
		BTN_RotateCCW		: in  std_logic;
		BTN_RotateCW		: in  std_logic;
		
		HS 					: out STD_LOGIC;
		VS 					: out STD_LOGIC;
		r,g,b 				: out STD_LOGIC_VECTOR(3 downto 0) 	:= (others => '0')
    );
end Tetris;

architecture behav of Tetris is
	signal clk_1           	: std_logic                    		:= '0';
	signal H_counter_value 	: integer 							:= 0;
	signal V_counter_value 	: integer 							:= 0;
	signal t_map			: tetris_array						:= (others => (others => '0'));
	signal Piece_x			: integer							:= 0;
	signal Piece_y			: integer							:= 0;
	signal Piece_id			: integer							:= 0;
	signal Piece_rot		: integer							:= 0;
	signal RNG_Value		: integer							:= 1;
	signal TetrisReset		: std_logic							:= '1';
	signal TetrisNewPiece	: std_logic							:= '1';
	signal Score			: integer							:= 0;
    
begin

    clk_proc: process(clock_100)
    variable clk_count  : integer := 0;
    begin
        if rising_edge(clock_100) then
            if clk_count = clk_const then
                clk_1 <= not clk_1;
                clk_count := 0;
            else
                clk_count := clk_count + 1;
            end if;
        end if;
    end process;

    HS_VS_proc: process(clk_1) -- find if we are at the right place to write or not
    begin
        if rising_edge(clk_1) then
			
			H_counter_value <= H_counter_value +1;
			if (H_counter_value >= 800) then --go one row down
				H_counter_value <= 0;
				V_counter_value <= V_counter_value +1;
			end if;
			if (V_counter_value >= 521) then --go back to top
				V_counter_value <= 0;
			end if;
			
			if (H_counter_value < 96) then --not yet past the first porch
				HS <= '1';
			else
				HS <= '0';
			end if;
			
			if (V_counter_value < 2) then
				VS <= '1';
			else
				VS <= '0';
			end if;
		end if;
	end process;
	
	draw_proc: process(clk_1)
	variable Pos_H		: integer		:= 0;
	variable Pos_V		: integer		:= 0;
	begin
		if (H_counter_value >= H_Start
		and H_counter_value <= H_End
		and V_counter_value >= V_Start
		and V_counter_value <= V_End)
		then --then we are within the area of the screen
			Pos_H		:= H_counter_value - H_Start;
			Pos_V		:= V_counter_value - V_Start;			

			if (DrawTetrisMap(Pos_H, Pos_V, MapStartX, MapStartY, ShowTetrisSize, t_map) = '1') 
			    or DrawTetrisShape(Pos_H, Pos_V, MapStartX + Piece_x * ShowTetrisSize, MapStartY + Piece_y * ShowTetrisSize, ShowTetrisSize, TetrisShapes(Piece_id)(Piece_rot)) = '1' then -- draw map
				r <= "0000";
				g <= "0110";
				b <= "0001";
			else
			    r <= "0000";
                g <= "0000";
                b <= "0000";
			end if;
		else
		    r <= "0000";
			g <= "0000";
			b <= "0000";
			
		end if;
	end process;
	
	RNG_proc: process(clock_100)
	begin
		if rising_edge(clock_100) then
		    RNG_Value     <=  (RNG_Value + 1) mod RNG_Mod;
		end if;
	end process;
	
	main_proc: process(clock_100)
	variable collision			: std_logic := '0';
	variable var_t_map			: tetris_array:= (others => (others => '0'));
	variable var_piece_x		: integer	:= 0;
	variable var_piece_y		: integer	:= 0;
	variable var_rot_id			: integer	:= 0;
	variable var_piece_id		: integer	:= 0;
	variable var_score			: integer	:= 0;
	
	variable var2_piece_y		: integer	:= 0;
	variable var2_piece_x		: integer	:= 0;
	variable var2_rot_id		: integer	:= 0;

	variable move_clk_count  	: integer 	:= 0;
	variable control_clk_count	: integer	:= 0;
	
	variable ReadyLeft  	    : std_logic := '1';
	variable ReadyRight         : std_logic := '1';
	variable ReadyCCW           : std_logic := '1';
	variable ReadyCW            : std_logic := '1';
	
	variable ReadyReset    		: std_logic     := '1';
	
	begin
		if rising_edge(clock_100) then		
			if control_clk_count = control_clk_const then
				control_clk_count := 0;
				var_t_map		:= t_map;
				var_piece_x		:= Piece_x;
				var_piece_y		:= Piece_y;
				var_rot_id		:= Piece_rot;
				var_piece_id	:= Piece_id;
				var_score		:= Score;

				if TetrisReset = '1' then
					-- Reset the board
					var_t_map			:= (others => (others => '0'));
					
					-- Reset score
					var_score			:= 0;
					
					TetrisReset			<= '0';
				end if;
				
				if (ReadyReset = '1' and BTN_Reset = '1') then
					TetrisReset			<= '1';
					TetrisNewPiece		<= '1';
					ReadyReset          := '0';
				elsif BTN_Reset = '0' then
					ReadyReset          := '1';
				end if;
			
				if TetrisNewPiece = '1' then
					-- Create a new piece
					var_rot_id		:= 0;
					var_piece_id	:= RNG_Value mod TetrisShapeCount;
					
					-- Place the new piece
					var_piece_y		:= TetrisFirstY;
					var_piece_x		:= TetrisFirstX;
					
					TetrisNewPiece	<= '0';
				end if;
				
				--button stuff:
			
				if (ReadyLeft = '1' and BTN_MoveLeft = '1') then
					var2_piece_x	:= var_piece_x - 1;
					ReadyLeft       := '0';
				elsif (ReadyRight = '1' and BTN_MoveRight = '1') then
					var2_piece_x	:= var_piece_x + 1;
					ReadyRight      := '0';
				else
					var2_piece_x	:= var_piece_x;
				end if;
				
				if BTN_MoveLeft = '0' then
					ReadyLeft := '1';
				end if;
				
				if BTN_MoveRight = '0' then
					ReadyRight := '1';
				end if;
				
				if (ReadyCW = '1' and BTN_RotateCW = '1') then
					if var_rot_id = 0 then
						var2_rot_id	:= 3;
					else
						var2_rot_id	:= var_rot_id - 1;
					end if;
					ReadyCW := '0';
				elsif (ReadyCCW = '1' and BTN_RotateCCW = '1') then
					if var_rot_id = 3 then
						var2_rot_id	:= 0;
					else
						var2_rot_id	:= var_rot_id + 1;
					end if;
					ReadyCCW := '0';
				else
					var2_rot_id		:= var_rot_id;
				end if;
				
				if BTN_RotateCW = '0' then
					ReadyCW := '1';
				end if;
				
				if BTN_RotateCCW = '0' then
					ReadyCCW := '1';
				end if;
				
				if CheckCollision(var_t_map, TetrisShapes(var_piece_id)(var2_rot_id), var2_piece_x, var_piece_y) = '0' then
					var_piece_x		:= var2_piece_x;
					var_rot_id		:= var2_rot_id;
				end if;
				
				
				if move_clk_count = move_clk_const then --do process
					move_clk_count := 0;
					-- Move piece
					var2_piece_y 		:= var_piece_y + 1;
				
					-- check for collision
					if CheckCollision(var_t_map, TetrisShapes(var_piece_id)(var_rot_id), var_piece_x, var2_piece_y) = '1' then
						-- place the piece
						for x in TetrisShapeSize - 1 downto 0 loop
							for y in TetrisShapeSize - 1 downto 0 loop
								-- Check if game should reset
								if TetrisShapes(var_piece_id)(var_rot_id)(y * TetrisShapeSize + x) = '1' then
									if var_piece_y + y < 0 then
										TetrisReset				<= '1';
									else
										var_t_map(var_piece_y + y)(var_piece_x + x)	:= '1';
									end if;
								end if;
							end loop;
						end loop;
						
						TetrisNewPiece		<= '1';
						
						-- remove full lines
						for y in 0 to TetrisHeight - 1 loop
							if and_reduce(var_t_map(y)) = '1' then
								if y > 0 then
									for y_move in y - 1 downto 0 loop
										var_t_map(y_move + 1)	:= var_t_map(y_move);
									end loop;
								end if;
								
								var_t_map(0)					:= (others => '0');
								var_score						:= var_score + 1;
							end if;
						end loop;
					else -- move the piece
						var_piece_y			:= var2_piece_y;
					end if;
				else
					move_clk_count := move_clk_count + 1;
				end if;
				
				t_map			<= var_t_map;
				Piece_x			<= var_piece_x;
				Piece_y			<= var_piece_y;
				Piece_rot		<= var_rot_id;
				Piece_id		<= var_piece_id;
				Score			<= var_score;
			
			else
				control_clk_count := control_clk_count + 1;
			end if;
		end if;
	end process;
	
end behav;