------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.TetrisLib.all;

entity Tetris is
    port (
        clock_100           : in  std_logic;
		HS 					: out STD_LOGIC;
		VS 					: out STD_LOGIC;
		r,g,b 				: out STD_LOGIC_VECTOR(3 downto 0) 	:= (others => '0')
    );
end Tetris;

architecture behav of Tetris is
	signal clk_1           	: std_logic                    		:= '0';
	signal move_clk_1		: std_logic							:= '0';
	signal H_counter_value 	: integer 							:= 0;
	signal V_counter_value 	: integer 							:= 0;
	signal x 				: integer 							:= 0;
	signal y 				: integer 							:= 0;
	signal t_map			: tetris_array						:= (others => '0');
	signal Piece_x			: integer							:= 0;
	signal Piece_y			: integer							:= 0;
	signal Piece_id			: integer							:= 0;
	signal Piece_rot		: integer							:= 0;
    
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
			x <= H_counter_value-143; --compensate for retrace?
			y <= V_counter_value-31;
			
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
	
	draw_proc: process(clk_1, H_counter_value, V_counter_value)
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

			if (DrawTetrisMap(Pos_H, Pos_V, MapStartX, MapStartY, ShowTetrisSize, t_map) = '1') then -- draw map
				r <= "0000";
				g <= "0110";
				b <= "0001";
			end if;
			
			-- Draw the piece
			if (DrawTetrisShape(Pos_H, Pos_V, MapStartX + Piece_x * ShowTetrisSize, MapStartY + Piece_y * ShowTetrisSize, ShowTetrisSize, TetrisShapes(Piece_id)(Piece_rot)))
				r <= "0000";
				g <= "0110";
				b <= "0001";
			end if;
		else
		    r <= "0000";
			g <= "0000";
			b <= "0000";
			
		end if;
	end process;
	
	move_clk_proc: process(clock_100)
    variable move_clk_count  : integer := 0;
    begin
        if rising_edge(clock_100) then
            if move_clk_count = move_clk_const then
                move_clk_1 <= not move_clk_1;
                move_clk_count := 0;
            else
                move_clk_count := move_clk_count + 1;
            end if;
        end if;
    end process;
	
	move_proc: process(move_clk_1)
	variable collision		: std_logic := '0';
	variable var_piece_y	: integer	:= 0;
	begin
		-- Move piece
		var_piece_y 		:= Piece_y + 1;
	
		-- check for collision
		if (var_piece_y + TetrisShapeSize > TetrisHeight) then
			collision		:= '1';
		elsif then
			
		else
			collision		:= '0';
		end if;
	end process;
end behav;