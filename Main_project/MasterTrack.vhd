------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use ieee.math_real.all;
library work;

entity MasterTrack is
    port (
        clock_100           : in  std_logic;
        
        layer_1             : in  std_logic_vector(7 downto 0);
        layer_2             : in  std_logic_vector(7 downto 0);
		layer_3				: in  std_logic_vector(7 downto 0);
		
		reset               : in std_logic;
		start_comparison    : in std_logic;
        
        SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
        SSEG_AN 		: out  STD_LOGIC_VECTOR (3 downto 0)
    
    );
end MasterTrack;

architecture behav of MasterTrack is
	signal clk_1           : std_logic                       := '0';
	signal ready           : std_logic                       := '0';
	signal diag_right      : std_logic_vector(7 downto 0)    := (others => '0');
	signal diag_left       : std_logic_vector(7 downto 0)    := (others => '0');
    signal straight        : std_logic_vector(7 downto 0)    := (others => '0');
    signal bend_left       : std_logic_vector(7 downto 0)    := (others => '0');
    signal bend_right      : std_logic_vector(7 downto 0)    := (others => '0');
    signal fork_left       : std_logic_vector(7 downto 0)    := (others => '0');
    signal fork_right      : std_logic_vector(7 downto 0)    := (others => '0');
    signal counts            : std_logic_vector(6 downto 0)    := (others => '0');
    
    signal disp  : integer := 0;
    signal number_disp : integer :=0;
    
begin

    clk_proc: process(clock_100)
    variable clk_count  : integer := 0;
    begin
        if rising_edge(clock_100) then
            if clk_count = 100000 then
                clk_1 <= not clk_1;
                clk_count := 0;
            else
                clk_count := clk_count + 1;
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
    variable Match_count : unsigned(6 downto 0) := "0000000";
    begin
    Match_count := "0000000";
        if rising_edge(clock_100) then
			if reset = '1' then
                --if resetting, set all to 0
				diag_right     <= (others => '0');
                diag_left      <= (others => '0');
                straight       <= (others => '0');
                bend_left      <= (others => '0');
                bend_right     <= (others => '0');
                fork_left      <= (others => '0');
                fork_right     <= (others => '0');
				Match_count    := (others => '0');
			elsif ready = '1' then
                --Set all to 0, later we turn on if there is a match
                Match_count := (others => '0');
                diag_right     <= (others => '0');
                diag_left      <= (others => '0');
                straight       <= (others => '0');
                bend_left      <= (others => '0');
                bend_right     <= (others => '0');
                fork_left      <= (others => '0');
                fork_right     <= (others => '0');
				for i in 7 downto 0 loop
					--Do actual check
                    
                    if layer_1(i) = '1' then --First check if there is a signal on first layer
                        --Go up one layer
                        if layer_2(i) = '1' then --perhaps a straight or a bend
                             -- we have a straight:
                            straight(i) <= layer_3(i);
                            Match_count := Match_count + ("000000" & straight(i));
                            
                            if i >= 1 then --there can be bend to the left
                                --bend to the left
                                bend_left(i) <= layer_3(i-1);
                                Match_count := Match_count + ("000000" & bend_left(i));
                            end if;

                            if i <= 6 then --there can be bend to the right
                                --bend to the right
                                bend_right(i) <= layer_3(i+1);
                                Match_count := Match_count + ("000000" & bend_right(i));
                            end if;

                        end if;
                        
                        if i >= 1 then --there can be a fork or diagonal to the left

                            if layer_2(i-1) = '1' then
                                --set fork
                                fork_left(i) <= layer_3(i-1);
                                Match_count := Match_count + ("000000" & fork_left(i));
                                
                                if i >= 2 then --check diagonal
                                    diag_left(i) <= layer_3(i-2);
                                    Match_count := Match_count + ("000000" & diag_left(i));
                                end if;
                            end if;
                        end if;

                        if i <= 6 then --there can be a fork or diagonal to the right
                            if layer_2(i+1) = '1' then
                                --set fork
                                fork_right(i) <= layer_3(i+1);
                                Match_count := Match_count + ("000000" & fork_right(i));
                                
                                if i <= 5 then --check diagonal
                                    diag_right(i) <= layer_3(i+2);
                                    Match_count := Match_count + ("000000" & diag_right(i));
                                end if;
                            end if;
                        end if;
                    end if;                    
				end loop;
                counts <= std_logic_vector(Match_count);
			else
                --if not ready, set all to 0
                diag_right     <= (others => '0');
                diag_left      <= (others => '0');
                straight       <= (others => '0');
                bend_left      <= (others => '0');
                bend_right     <= (others => '0');
                fork_left      <= (others => '0');
                fork_right     <= (others => '0');
				Match_count    := (others => '0');
                counts <= std_logic_vector(Match_count);
			end if;
		end if;
    end process;

    

    SSEG_proc: process(clk_1)

    variable counts_integer : integer := 0;
    begin
        if rising_edge(clk_1) then
            if disp=4 then
                disp <= 0; --Go back to beginning
            else
                disp <= disp +1; --go to next display
            end if;
            
            counts_integer := TO_INTEGER(unsigned(counts));
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
            
     SSEG_AN <=     "1110" when disp=1 else
                    "1101" when disp=2 else
                    "1011" when disp=3 else
                    "0111" when disp=4 else
                    "1111";
    
    
end behav;