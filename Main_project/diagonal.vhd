------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity diagonal is
    port (
        clock_100           : in  std_logic;
        
        layer_1             : in  std_logic_vector(7 downto 0);
        layer_2             : in  std_logic_vector(7 downto 0);
		layer_3				: in  std_logic_vector(7 downto 0);
		
		reset               : in std_logic;
		start_comparison    : in std_logic;

        Found_match            : out std_logic := '0'
    );
end diagonal;

architecture behav of diagonal is
	
	signal ready            : std_logic                       := '0';
	signal output_right     : std_logic_vector(7 downto 0)    := (others => '0');
	signal output_left      : std_logic_vector(7 downto 0)    := (others => '0');

begin

    ready_proc: process(clock_100)
    begin
        if rising_edge(clock_100) then
			if reset = '1' then
				ready <= '0';
			else
				ready <= start_comparison;
			end if;
		end if;
	end process;
	
    comp_proc: process(clock_100)
    begin
        if rising_edge(clock_100) then
			if reset = '1' then
				output_left 	<= (others => '0');
				output_right 	<= (others => '0');
				Found_match <= '0';
			elsif ready = '1' then
				for i in 7 downto 0 loop
					if i <= 5 then
                        output_right(i) <= layer_1(i) and layer_2(i+1) and layer_3(i+2);
                    else 
                        output_right(i) <= '0';
                    end if;
                    if i>=2 then
                        output_left(i) <= layer_1(i) and layer_2(i-1) and layer_3(i-2);
                    else 
                        output_left(i) <= '0';
                    end if;
				end loop;
				Found_match <= or_reduce(output_left) or or_reduce(output_right);
			else
                output_left <= (others => '0');
                output_right <= (others => '0');
				Found_match <= '0';
			end if;
        end if;
    end process;

end behav;