------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity straight is
    port (
        clock_100           : in  std_logic;
        
        layer_1             : in  std_logic_vector(7 downto 0);
        layer_2             : in  std_logic_vector(7 downto 0);
		layer_3				: in  std_logic_vector(7 downto 0);

        Found_match            : out std_logic := '0'
    );
end straight;

architecture behav of straight is
	
	signal output_vec       : std_logic_vector(7 downto 0)    := (others => '0');

begin

    process(clock_100)
    begin
        if rising_edge(clock_100) then
            for i in 7 downto 0 loop
				output_vec(i) <= layer_1(i) and layer_2(i) and layer_3(i);
			end loop;
			
			Found_match <= or_reduce(output_vec);
        end if;
    end process;

end behav;