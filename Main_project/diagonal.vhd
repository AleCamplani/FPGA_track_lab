------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity diagonal is
    port (
        clock_100           : in  std_logic;
        
        layer_1             : in  std_logic_vector(7 downto 0); -- The first layer of LED's '1' if LED is on
        layer_2             : in  std_logic_vector(7 downto 0); -- The second layer of LED's '1' if LED is on
		layer_3				: in  std_logic_vector(7 downto 0); -- The third layer of LED's '1' if LED is on
		
		reset               : in std_logic; -- Button which resets system when pressed
		start_comparison    : in std_logic; -- Switch which needs to be on for comparisons to occur

        Found_match         : out std_logic := '0' -- Whether a match was found or not
    );
end diagonal;

architecture behav of diagonal is
	
	signal ready            : std_logic                       := '0'; -- '1' when the FPGA should look for tracks
	signal output_right     : std_logic_vector(7 downto 0)    := (others => '0'); -- Where on the board it found right diagonal tracks
	signal output_left      : std_logic_vector(7 downto 0)    := (others => '0'); -- Where on the board it found left diagonal tracks

begin

    ready_proc: process(clock_100) -- The process to check if it should be comparing
    begin
        if rising_edge(clock_100) then
			if reset = '1' then -- If it is reseting then it should not be comparing
				ready <= '0';
			else -- If it is not resetting then the behavior is determined by start_comparison
				ready <= start_comparison;
			end if;
		end if;
	end process;
	
    comp_proc: process(clock_100) -- The main process in which comparisons are made
    begin
        if rising_edge(clock_100) then
			if reset = '1' then -- If it is resetting then set all values to default
				output_left 	<= (others => '0');
				output_right 	<= (others => '0');
				Found_match <= '0';
			elsif ready = '1' then -- If it is ready then look for tracks
				for i in 7 downto 0 loop -- Look at all positions on the board 
					if i <= 5 then -- If we are not at the last 2 positions then look for a right diagonal
                        output_right(i) <= layer_1(i) and layer_2(i+1) and layer_3(i+2);
                    else -- If we are at one of the last 2 positions then a diagonal right is impossible since there is not space
                        output_right(i) <= '0';
                    end if;
                    if i>=2 then -- If we are not at the first 2 positions then look for a left diagonal
                        output_left(i) <= layer_1(i) and layer_2(i-1) and layer_3(i-2);
                    else -- If we are at one of the first 2 positions then a diagonal left is impossible since there is not space
                        output_left(i) <= '0';
                    end if;
				end loop;
				Found_match <= or_reduce(output_left) or or_reduce(output_right); -- Check if it found a match
			else -- If it is not ready then also reset to default values
                output_left <= (others => '0');
                output_right <= (others => '0');
				Found_match <= '0';
			end if;
        end if;
    end process;

end behav;