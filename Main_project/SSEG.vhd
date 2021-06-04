------------------------------  <-  80 chars  ->  ------------------------------

--import libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity SSEG is
    port (
		--inputs
        clock_100         	: in  std_logic; --clock
		Count				: in  integer; --the number we want to display (can be larger than 9)
		
        SSEG_CA 			: out  std_logic_vector(7 downto 0); --signal to SSEG cathodes (commom for all four displays)
        SSEG_AN 			: out  std_logic_vector(3 downto 0) --signal to SSEG anodes (seperate)
    );
end SSEG;

architecture behav of SSEG is
	
	signal clk_1           		: std_logic         := '0'; -- slower clock, since the multiplexing cannot go faster than 1kHz
	signal disp  				: integer 			:= 0; -- what display to activate
    signal number_disp 			: integer 			:= 0; --what number (0 to 9) to write in the active display

    	
begin

    clk_proc: process(clock_100) -- generate slower clock, done exactl as in VGActrl.
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
	
	-- procees for determining the number to be displayed on the active display, and incrementing what display is active
	-- we could have split this into two processes.
	SSEG_proc: process(clk_1) 

    begin
        if rising_edge(clk_1) then
			--check if we are at the end of the displays, and increment if not:
            if disp = 4 then
                disp 	<= 0; --Go back to beginning (only 4 displays)
            else
                disp 	<= disp + 1; --go to next display
            end if;
            
            --Determine what number (0 to 9) to write on the active display
            if disp = 0 then --ones
                number_disp <= Count mod 10;
            elsif disp = 1 then --tens
                number_disp <= (Count / 10) mod 10;
            elsif disp = 2 then --hundreds
                number_disp <= (Count / 100) mod 10;
            elsif disp = 3 then --thousands
                number_disp <= (Count / 1000) mod 10;
            end if;
                        
        end if;
    end process;
    
	--Outside the clock, we map the number to be displayed and the acitve display to a combination of 
	--Cathodes to set high/low and Anodes to set high/low. Note that the signal to the anode gets inverted.
	
	SSEG_CA <=          "11000000" when number_disp = 0 else
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
            
	SSEG_AN <=      	"1110" when disp = 1 else -- delayed one value of disp, since signas take one clock-cycle before they are set.
						"1101" when disp = 2 else
						"1011" when disp = 3 else
						"0111" when disp = 4 else
						"1111";


end behav;