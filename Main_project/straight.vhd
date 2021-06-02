------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity straight is
    port (
        clock_100           : in  std_logic;
        
        JA             		: in  std_logic_vector(7 downto 0);
        JB             		: in  std_logic_vector(7 downto 0);
		JC					: in  std_logic_vector(7 downto 0);
		
		reset               : in std_logic;
		start_comparison    : in std_logic;

        Found_match         : out std_logic := '0';
		Comparing           : out std_logic := '0'
    );
end straight;

architecture behav of straight is
	
	signal ready            : std_logic                       := '0';
	signal output_vec       : std_logic_vector(7 downto 0)    := (others => '0');

	
	signal layer_1			: std_logic_vector(7 downto 0)	:= (others => '0');
	signal layer_2			: std_logic_vector(7 downto 0)	:= (others => '0'); 
	signal layer_3			: std_logic_vector(7 downto 0)	:= (others => '0'); 
begin

	Comparing <= start_comparison;

    synch_proc: process(clock_100)
    begin
        if rising_edge(clock_100) then
			layer_3 <= JA;
			layer_2 <= JB;
			layer_1 <= JC;
		end if;
	end process;

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
				output_vec 	<= (others => '0');
				Found_match <= '0';
			elsif ready = '1' then
				for i in 7 downto 0 loop
					output_vec(i) <= layer_1(i) and layer_2(i) and layer_3(i);
				end loop;
				Found_match <= or_reduce(output_vec);
			else
				output_vec <= (others => '0');
				Found_match <= '0';
			end if;
        end if;
    end process;

end behav;