------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity MasterTrack is
    port (
        clock_100           : in  std_logic;
        
        layer_1             : in  std_logic_vector(7 downto 0);
        layer_2             : in  std_logic_vector(7 downto 0);
		layer_3				: in  std_logic_vector(7 downto 0);
		
		reset               : in std_logic;
		start_comparison    : in std_logic
    );
end MasterTrack;

architecture behav of MasterTrack is
	
	signal ready           : std_logic                       := '0';
	signal diag_right      : std_logic_vector(7 downto 0)    := (others => '0');
	signal diag_left       : std_logic_vector(7 downto 0)    := (others => '0');
    signal straight        : std_logic_vector(7 downto 0)    := (others => '0');
    signal bend_left       : std_logic_vector(7 downto 0)    := (others => '0');
    signal bend_right      : std_logic_vector(7 downto 0)    := (others => '0');
    signal fork_left       : std_logic_vector(7 downto 0)    := (others => '0');
    signal fork_right      : std_logic_vector(7 downto 0)    := (others => '0');
    signal counts            : std_logic_vector(6 downto 0)    := (others => '0');
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

end behav;