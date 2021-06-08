------------------------------  <-  80 chars  ->  ------------------------------

--import libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.VGALib.all;
use work.MasterConstants.all;
use work.TetrisLib.all;

--used for drawing on a 640 by 480 pixel screen

entity VGActrl is
    port (
		--in
        clock_100           : in  std_logic; --clock
        shape_found			: in  layer_array; --logic vectros telling us if a shape has been found, and in what location
		draw_tetris			: in  std_logic;
		t_map               : in  tetris_array;
		Piece_x             : in  integer;
		Piece_y             : in  integer;
		Piece_rot           : in  integer;
		Piece_id            : in  integer;
		
		--out
		HS 					: out STD_LOGIC; --Horizontal synch, rests 'electrom beam' to the left of the screen
		VS 					: out STD_LOGIC; --Vertical synch, rests 'electrom beam' to the top of the screen
		r,g,b 				: out STD_LOGIC_VECTOR(3 downto 0) 	:= (others => '0') -- outputs telling the screen what color should be draw at the current 'electrom beam' location.
    );
end VGActrl;

architecture behav of VGActrl is
	signal clk_1           	: std_logic                    		:= '0'; -- generated slower clock
	signal H_counter_value 	: integer 							:= 0; --counters for 'electron beam' location
	signal V_counter_value 	: integer 							:= 0;
    
begin

    clk_proc: process(clock_100) -- process for generating slower clock
    variable clk_count  : integer := 0;
    begin
		--changes slower clock every time clk_count(inceremented on inputted clock rising edge) has reached clk_const
        if rising_edge(clock_100) then
            if clk_count = clk_const then
                clk_1 <= not clk_1;
                clk_count := 0;
            else
                clk_count := clk_count + 1;
            end if;
        end if;
    end process;

    HS_VS_proc: process(clk_1) -- process to set HS and VS correctly, uses generated clock
    begin
        if rising_edge(clk_1) then
			
			H_counter_value <= H_counter_value +1; -- increment where we are on the screen, slower clock is set speceifically so that this is true every clock cycle.
			if (H_counter_value >= 800) then --go one row down of we reach the end, set to 800 since there is also a back porch
				H_counter_value <= 0;
				V_counter_value <= V_counter_value +1;
			end if;
			if (V_counter_value >= 521) then --go back to top, if we reach the top, 521 becuse of the back porch
				V_counter_value <= 0;
			end if;
			
			if (H_counter_value < 96) then --not yet past the first porch, still synching
				HS <= '1';
			else
				HS <= '0';
			end if;
			
			if (V_counter_value < 2) then --not yet past the first porch, still synching
				VS <= '1';
			else
				VS <= '0';
			end if;
		end if;
	end process;
	
	draw_proc: process(clk_1, H_counter_value, V_counter_value) --process for drawing on the screen
	variable Pos_H		  : integer		  := 0; --Where we are on the screen
	variable Pos_V		  : integer		  := 0;
    variable DrawHere     : std_logic     :='0'; --if we should color in
    variable shape_pos_H  : integer       := 0; --where we should draw some shape
    variable shape_pos_V  : integer       := 0;

	begin
		if (H_counter_value >= H_Start
		and H_counter_value <= H_End
		and V_counter_value >= V_Start
		and V_counter_value <= V_End)
		then --then we are within the area of the screen
			--calculate the current position of the 'electron beam' realtive top top left corner of screen
			Pos_H		:= H_counter_value - H_Start; --0 to 639
			Pos_V		:= V_counter_value - V_Start; --0 to 479
			
            DrawHere := '0'; --do not draw as default
            shape_pos_H := 0; --reset where we should draw shapes
            shape_pos_V := 0;

            for i in shape_count - 1 downto 0 loop --we need to draw a shape and a logic vector for each track type defined
				--as default everything is drawn in a line, with the shape just above the logic vector.
				
                shape_pos_H := Offset+boxsize*i*(line_width+1); -- stadard where we want to draw shape number i
                shape_pos_V := Offset;
                
                -- hardcoded max of 2 line changes, if the shape is computed to be drawn to the right of the screen:
                if shape_pos_H + boxsize*line_width > H_end - H_start then -- we are outside box, go down one line
					--calculate new position (with line change):
                    shape_pos_V := shape_pos_V + line_height; 
                    shape_pos_H := shape_pos_H - (boxsize*(line_width+1))*((H_end - H_start) / (boxsize*(line_width+1)));
					
                    if shape_pos_H + boxsize*line_width > H_end - H_start then -- still outside box, go down again
						--calculate new position (with line change):
                        shape_pos_V := shape_pos_V + line_height;
                        shape_pos_H := shape_pos_H - (boxsize*(line_width+1))*((H_end - H_start) / (boxsize*(line_width+1))) ;
                    end if;
                end if;
				
				--Now we call the functions for drawing the relevant shape and logic vector in the VGALib:
                if (DrawShape(Pos_H,Pos_V,shape_pos_H,shape_pos_V,boxsize,shape_data(i)) = '1'
				or DrawCounts(Pos_H, Pos_V,shape_pos_H, shape_pos_V + boxsize*5, boxsize, shape_found(i)) = '1')then
                    DrawHere := '1'; -- if any return true, we want to fill in the pixel
                end if;
            end loop;
			
			if (draw_tetris = '1' and 
			    (DrawTetrisMap(Pos_H, Pos_V, MapStartX, MapStartY, ShowTetrisSize, t_map) = '1' 
			    or DrawTetrisShape(Pos_H, Pos_V, MapStartX + Piece_x * ShowTetrisSize, MapStartY + Piece_y * ShowTetrisSize, ShowTetrisSize, TetrisShapes(Piece_id)(Piece_rot)) = '1')) then -- draw map
				DrawHere := '1';
			end if;

			if (DrawHere = '1')then -- if we wanted to fill in, set to a lovely green color to be displayed
				r <= "0000";
				g <= "1111";
				b <= "0001";
			else -- otherwise set it to black
				r <= "0000";
				g <= "0000";
				b <= "0000";
			end if;
			
		else --black if outside screen
		    r <= "0000";
			g <= "0000";
			b <= "0000";
			
		end if;
	end process;
	
end behav;