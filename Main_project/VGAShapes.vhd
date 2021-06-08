------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.VGALib.all;

entity VGATest is
    port (
        clock_100           : in  std_logic;
		HS 					: out std_logic; --Horizontal synch, rests 'electrom beam' to the left of the screen
		VS 					: out std_logic; --Vertical synch, rests 'electrom beam' to the top of the screen
		r,g,b 				: out std_logic_vector(3 downto 0) 	:= (others => '0') -- The colours to draw with
    );
end VGATest;

architecture behav of VGATest is
	signal clk_1           	: std_logic                    		:= '0'; -- A slower clock used for drawing to the screen
	signal H_counter_value 	: integer 							:= 0; -- The horisontal position
	signal V_counter_value 	: integer 							:= 0; -- The vertical position
	--signal x 				: integer 							:= 0; -- 
	--signal y 				: integer 							:= 0;
    
begin

    clk_proc: process(clock_100) -- Make a slower clock, this clock is at half speed
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
			
			H_counter_value <= H_counter_value +1; -- Move to the right
			if (H_counter_value >= 800) then --go one row down
				H_counter_value <= 0;
				V_counter_value <= V_counter_value +1;
			end if;
			if (V_counter_value >= 521) then --go back to top
				V_counter_value <= 0;
			end if;
			--x <= H_counter_value-143; --compensate for retrace?
			--y <= V_counter_value-31;
			
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
	
	draw_proc: process(clk_1, H_counter_value, V_counter_value) -- Draw the shapes
	variable Pos_H		: integer		:= 0;
	variable Pos_V		: integer		:= 0;
	begin
		if (H_counter_value >= H_Start
		and H_counter_value <= H_End
		and V_counter_value >= V_Start
		and V_counter_value <= V_End)
		then --then we are within the area of the screen
			Pos_H		:= H_counter_value - H_Start; -- Find the actual positions on the screen
			Pos_V		:= V_counter_value - V_Start;
			
			if (DrawShape(Pos_H,Pos_V,50,50,20,shape_data(1)) = '1'
				or DrawCounts(Pos_H, Pos_V, 150, 150, 20, "00111010") = '1') then -- Test if it should draw a figure in this position
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