------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;

entity VGATest is
    port (
        clock_100           : in  std_logic;
		HS : out STD_LOGIC;
		VS : out STD_LOGIC;
		r,g,b : out STD_LOGIC_VECTOR(3 downto 0) := (others => '0')
    );
end VGATest;

architecture behav of VGATest is
	signal clk_1           : std_logic                       := '0';
	signal H_counter_value : integer :=0;
	signal V_counter_value : integer :=0;
	signal x : integer :=0;
	signal y : integer :=0;
    
begin

    clk_proc: process(clock_100)
    variable clk_count  : integer := 0;
    begin
        if rising_edge(clock_100) then
            if clk_count = 1 then
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
			if (H_counter_value = 800) then --go one row down
				H_counter_value <= 0;
				V_counter_value <= V_counter_value +1;
			end if;
			if (V_counter_value = 521) then --go back to top
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
	begin
		if (H_counter_value >= 144
		and H_counter_value < 783
		and V_counter_value >=31
		and V_counter_value <510)
		then --then we are within the area of the screen
			
			r <= "0110";
			g <= "0000";
			b <= "0000";
		else
		    r <= "0000";
			g <= "0000";
			b <= "0000";
			
		end if;
	end process;
	
end behav;