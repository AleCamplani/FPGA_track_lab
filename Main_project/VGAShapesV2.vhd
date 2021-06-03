------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.VGALib.all;
use work.MasterConstants.all;


entity VGATest is
    port (
        clock_100           : in  std_logic;
		HS 					: out STD_LOGIC;
		VS 					: out STD_LOGIC;
		r,g,b 				: out STD_LOGIC_VECTOR(3 downto 0) 	:= (others => '0')
    );
end VGATest;

architecture behav of VGATest is
	signal clk_1           	: std_logic                    		:= '0';
	signal H_counter_value 	: integer 							:= 0;
	signal V_counter_value 	: integer 							:= 0;
	signal x 				: integer 							:= 0;
	signal y 				: integer 							:= 0;
    
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
	variable Pos_H		  : integer		  := 0;
	variable Pos_V		  : integer		  := 0;
    variable DrawHere     : std_logic     :='0';
    variable shape_pos_H  : integer       := 0;
    variable shape_pos_V  : integer       := 0;

	begin
		if (H_counter_value >= H_Start
		and H_counter_value <= H_End
		and V_counter_value >= V_Start
		and V_counter_value <= V_End)
		then --then we are within the area of the screen
			Pos_H		:= H_counter_value - H_Start;
			Pos_V		:= V_counter_value - V_Start;
			
            DrawHere := '0';
            shape_pos_H := 0;
            shape_pos_V := 0;

            for i in shape_count - 1 downto 0 loop
                shape_pos_H := Offset+boxsize*i*(line_width+1); -- stadard where we want to draw
                shape_pos_V := Offset;
                
                -- hardcoded max of 2 line changes:
                if shape_pos_H + boxsize*line_width > H_end - H_start then -- we are outside box
                    shape_pos_V := shape_pos_V + line_height; -- go down one line
                    shape_pos_H := shape_pos_H - (boxsize*(line_width+1))*((H_end - H_start) / (boxsize*(line_width+1)));
                    if shape_pos_H + boxsize*line_width > H_end - H_start then -- still outside box
                        shape_pos_V := shape_pos_V + line_height; -- go down one line
                        shape_pos_H := shape_pos_H - (boxsize*(line_width+1))*((H_end - H_start) / (boxsize*(line_width+1))) ;
                    end if;
                end if;

                if (DrawShape(Pos_H,Pos_V,shape_pos_H,shape_pos_V,boxsize,shape_data(i)) = '1'
				or DrawCounts(Pos_H, Pos_V,shape_pos_H, shape_pos_V + boxsize*5, boxsize, "00111010") = '1')then
                    DrawHere := '1';
                end if;
            end loop;


			if (DrawHere = '1')then
				r <= "0000";
				g <= "1111";
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
	
end behav;