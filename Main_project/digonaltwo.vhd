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

        Found_match         : out std_logic := '0' -- Whether it found a track or not
    );
end diagonal;

architecture behav of diagonal is
	
	signal output_right       : std_logic_vector(7 downto 0)    := (others => '0'); -- Where on the board it found right diagonal tracks
    signal output_left        : std_logic_vector(7 downto 0)    := (others => '0'); -- Where on the board it found left diagonal tracks

begin

    process(clock_100) -- Main process where it looks for tracks
    begin
        if rising_edge(clock_100) then
            for i in 7 downto 0 loop -- Loop through all of the possible positions
                if (layer_1(i) and layer_2(i)) then -- Look for a bend track
                    if 7-i>=1 then -- if it is not at the last position look for a right bend
				        output_right(i) <= layer_2(i) and layer_3(i+1);
				    end if;
                    if i>=1 then -- if it is not at the first position look for a left bend
                        output_left(i) <= layer_2(i) and layer_3(i-1);
                    end if;
                end if;
                if 7-i>=1 then -- If it is not at the last position look for a right fork or a right diagonal
                    if (layer_1(i) and layer_2(i+1)) then
                        if 7-i>=2 then -- if there is space for a right diagonal look for it
                            output_right(i) <= (layer_2(i+1) and layer_3(i+2)) or output_right(i);
                        end if;
                        output_right(i) <= (layer_2(i+1) and layer_3(i+1)) or output_right(i); -- look for a right fork
                    end if;
                end if;
                if i>=1 then -- if it is not at the first position look for a left fork
                    if (layer_1(i) and layer_2(i+1)) then
                        if i>=2 then -- if there is space for a left diagonal look for it
                            output_left(i) <= (layer_2(i-1) and layer_3(i-2)) or output_left(i);
                        end if;
                        output_left(i) <= (layer_2(i-1) and layer_3(i-1)) or output_left(i); -- look for a left fork
                end if;
			end loop;
			
			Found_match <= or_reduce(output_left) or or_reduce(output_right); -- Check whether it found a match
        end if;
    end process;

end behav;