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
		start_comparison    : in std_logic;
		UseCounts			: in std_logic_vector(shape_count - 1 downto 0);
		
		LED_Compare			: out  std_logic;
		LED_UseCounts		: out  std_logic_vector(shape_count - 1 downto 0);
		
        SSEG_CA 			: out  std_logic_vector(7 downto 0);
        SSEG_AN 			: out  std_logic_vector(3 downto 0);

        HS 					: out STD_LOGIC;
		VS 					: out STD_LOGIC;
		r,g,b 				: out STD_LOGIC_VECTOR(3 downto 0) 	:= (others => '0')

    );
end MasterTrack;

architecture behav of MasterTrack is
	
	signal ready           		: std_logic         := '0';
	
	signal shape_found			: layer_array		:= (others => (others => '0'));
	signal shape_counts			: integer_array		:= (others => 0);
		
	signal Count				: integer			:= 0;

    	
begin
    SSEG: entity work.SSEG
        port map(
            clock_100         	=> clock_100,

			Count 			    => Count,
			
			SSEG_CA				=> SSEG_CA,
			SSEG_AN				=> SSEG_AN
        );
    VGActrl: entity work.VGActrl
        port map(
            clock_100       => clock_100,

            HS 			    => HS,
            VS 			    => VS,
            r               => r,
            g               => g,
            b               => b,

            shape_found     => shape_found
        );

	LED_UseCounts		<= UseCounts;
	LED_Compare			<= start_comparison;

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
	variable var_shape_counts	: integer_array		:= (others => 0);
	variable var_count			: integer			:= 0;

    begin
        if rising_edge(clock_100) then
			if (reset = '1' or ready = '0') then
                --if resetting, set all to 0
				shape_found			<= (others => (others => '0'));
				shape_counts		<= (others => 0);
                Count 				<= 0;
				
			else
				var_shape_counts	:= (others => 0);
				var_count			:= 0;
								
				for i in line_width - 1 downto 0 loop
					for j in shape_count - 1 downto 0 loop
					
						shape_found(j)(i) 	<= CheckShape(shape(j), layer_1, layer_2, layer_3, i);
						
						if shape_found(j)(i) = '1' then
							var_shape_counts(j) := var_shape_counts(j) + 1;
						end if;					
					end loop;
				end loop;
				
				for i in shape_count - 1 downto 0 loop
					if UseCounts(i) = '1' then
						var_count 	:= var_count + var_shape_counts(i);
					end if;
				end loop;

                Count 				<= var_count;
				shape_counts		<= var_shape_counts;
				
			end if;
        end if;
    end process;

end behav;