------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity SSEG is
    port (
        clock_100         	: in  std_logic;
		
		Count				: in  integer;
		
        SSEG_CA 			: out  std_logic_vector(7 downto 0);
        SSEG_AN 			: out  std_logic_vector(3 downto 0)
    );
end SSEG;

architecture behav of SSEG is
	
	signal clk_1           		: std_logic         := '0';
	
	signal disp  				: integer 			:= 0;
    signal number_disp 			: integer 			:= 0;

    	
begin

    clk_proc: process(clock_100)
    variable clk_count  	: integer := 0;
    begin
        if rising_edge(clock_100) then
            if clk_count = 100000 then
                clk_1	 	<= not clk_1;
                clk_count 	:= 0;
            else
                clk_count 	:= clk_count + 1;
            end if;
        end if;
    end process;

	SSEG_proc: process(clk_1)

    begin
        if rising_edge(clk_1) then
            if disp = 4 then
                disp 	<= 0; --Go back to beginning
            else
                disp 	<= disp + 1; --go to next display
            end if;
            
            
            if disp = 0 then
                number_disp <= Count mod 10;
            elsif disp = 1 then
                number_disp <= (Count / 10) mod 10;
            elsif disp = 2 then
                number_disp <= (Count / 100) mod 10;
            elsif disp = 3 then
                number_disp <= (Count / 1000) mod 10;
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