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
		
        SSEG_CA 			: out  std_logic_vector(7 downto 0);
        SSEG_AN 			: out  std_logic_vector(3 downto 0)
    );
end MasterTrack;

architecture behav of MasterTrack is
	
	signal clk_1           		: std_logic         := '0';
	
	signal ready           		: std_logic         := '0';
	
	signal shape_found			: layer_array		:= (others => (others => '0'));
	signal shape_counts			: integer_array		:= (others => 0);
	
    signal counts          		: integer       	:= 0;
	
	signal disp  				: integer 			:= 0;
    signal number_disp 			: integer 			:= 0;

    	
begin

    clk_proc: process(clock_100)
    variable clk_count  	: integer := 0;
    begin
        if rising_edge(clock_100) then
            if clk_count = 10 then
                clk_1	 	<= not clk_1;
                clk_count 	:= 0;
            else
                clk_count 	:= clk_count + 1;
            end if;
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
	
	SSEG_proc: process(clk_1)

    variable counts_integer : integer := 0;
    begin
        if rising_edge(clk_1) then
            if disp = 4 then
                disp 	<= 0; --Go back to beginning
            else
                disp 	<= disp + 1; --go to next display
            end if;
            
            counts_integer := counts;
            if disp = 0 then
                number_disp <= counts_integer mod 10;
            elsif disp = 1 then
                number_disp <= (counts_integer / 10) mod 10;
            elsif disp = 2 then
                number_disp <= (counts_integer / 100) mod 10;
            elsif disp = 3 then
                number_disp <= (counts_integer / 1000) mod 10;
            end if;
                        
        end if;
    end process;
    
     SSEG_CA <=         "11000000" when number_disp = 0 else
                        "11111001" when number_disp = 1 else
                        "10100100" when number_disp = 2 else
                        "10110000" when number_disp = 3 else
                        "10011001" when number_disp = 4 else
                        "10010010" when number_disp = 5 else
                        "10000010" when number_disp = 6 else
                        "11111000" when number_disp = 7 else
                        "10000000" when number_disp = 8 else
                        "10011000" when number_disp = 9 else
                        "01111111";
            
     SSEG_AN <=     "1110" when disp = 1 else
                    "1101" when disp = 2 else
                    "1011" when disp = 3 else
                    "0111" when disp = 4 else
                    "1111";


end behav;