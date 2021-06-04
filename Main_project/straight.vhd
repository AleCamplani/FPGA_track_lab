------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity straight is
    port (
        clock_100           : in  std_logic;
        
        JA             		: in  std_logic_vector(7 downto 0); -- The first layer of LED's '1' if LED is on
        JB             		: in  std_logic_vector(7 downto 0); -- The second layer of LED's '1' if LED is on
		JC					: in  std_logic_vector(7 downto 0); -- The third layer of LED's '1' if LED is on
		
		reset               : in std_logic; -- Button which resets system when pressed
		start_comparison    : in std_logic; -- Switch which needs to be on for comparisons to occur

        Found_match         : out std_logic := '0'; -- Whether it found a track
		Comparing           : out std_logic := '0' -- If it is comparing (to turn on LED)
    );
end straight;

architecture behav of straight is
	
	signal ready            : std_logic                       := '0'; -- Whether it is ready to look for tracks
	signal output_vec       : std_logic_vector(7 downto 0)    := (others => '0'); -- Where it found tracks

	
	signal layer_1			: std_logic_vector(7 downto 0)	:= (others => '0'); -- Just renaming JA
	signal layer_2			: std_logic_vector(7 downto 0)	:= (others => '0'); -- Just renaming JB
	signal layer_3			: std_logic_vector(7 downto 0)	:= (others => '0'); -- Just renaming JC
begin

	Comparing <= start_comparison; -- Control comparing LED

    synch_proc: process(clock_100) -- Sync the layer data
    begin
        if rising_edge(clock_100) then
			layer_3 <= JA;
			layer_2 <= JB;
			layer_1 <= JC;
		end if;
	end process;

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
	
    comp_proc: process(clock_100) -- Main process to look for tracks
    begin
        if rising_edge(clock_100) then
			if ready = '1' then -- Look for tracks
				for i in 7 downto 0 loop -- Loop through all the positions
					output_vec(i) <= layer_1(i) and layer_2(i) and layer_3(i); -- Check whether there is a track
				end loop;
				Found_match <= or_reduce(output_vec); -- Check if it found a track
			else -- It is nopt comparing and needs to reset all values
				output_vec <= (others => '0');
				Found_match <= '0';
			end if;
        end if;
    end process;

end behav;