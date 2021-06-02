------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;
use work.MasterConstants.all;

entity MasterTrack is
    port (
        clock_100         	: in  std_logic;
        
        layer_1             : in  layer;
        layer_2             : in  layer;
		layer_3				: in  layer;
		
		reset               : in std_logic;
		start_comparison    : in std_logic
    );
end MasterTrack;

architecture behav of MasterTrack is
	
	signal ready           		: std_logic         := '0';
	
	signal shape_found			: layer_array		:= (others => (others => '0'));
	signal shape_counts			: integer_array		:= (others => 0);
	
    signal counts          		: integer       	:= 0;
    	
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
    variable var_counts	 		: integer 			:= 0;
	variable var_shape_counts	: integer_array		:= (others => 0);

    begin
        if rising_edge(clock_100) then
			if (reset = '1' or ready = '0') then
                --if resetting, set all to 0
				shape_found			<= (others => (others => '0'));
				shape_counts		<= (others => 0);
                counts 				<= 0;
				
			else
				var_counts			:= 0;
				var_shape_counts	:= (others => 0);
								
				for i in line_width - 1 downto 0 loop
					for j in shape_count - 1 downto 0 loop
					
						shape_found(j)(i) 	<= CheckShape(shape(j), layer_1, layer_2, layer_3, i);
						
						if shape_found(j)(i) = '1' then
							var_shape_counts(j) := var_shape_counts(j) + 1;
						    var_counts			:= var_counts + 1;
						end if;					
					end loop;
				end loop;

                counts 				<= var_counts;
				shape_counts		<= var_shape_counts;
				

				
			end if;
        end if;
    end process;

end behav;