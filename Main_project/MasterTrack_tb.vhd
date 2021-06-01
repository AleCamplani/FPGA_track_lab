------------------------------  <-  80 chars  ->  ------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity MasterTrack_tb is
    
end MasterTrack_tb;

architecture behav of MasterTrack_tb is

    signal clock_100           : std_logic                      := '0';

    signal layer_1             : std_logic_vector(7 downto 0)   := (others => '0');
    signal layer_2             : std_logic_vector(7 downto 0)   := (others => '0');
    signal layer_3             : std_logic_vector(7 downto 0)   := (others => '0');

    signal reset               : std_logic                      := '0';
    signal start_comparison    : std_logic                      := '0';

    signal counter_100         : integer                        := 0;

begin

    dut: entity work.MasterTrack
        port map(
            clock_100         => clock_100,
    
            layer_1           => layer_1,
            layer_2           => layer_2,
            layer_3           => layer_3,
			
			reset             => reset,
            start_comparison  => start_comparison
        );

-- Clock generator 100 MHz
    sim_basics_clk100 : entity work.simulation_basics
        generic map (
            reset_duration => 10,
            clk_offset     => 5 ns,
            clk_period     => 10 ns
        )
        port map (
            clk     => clock_100,
            rst     => open,
            counter => counter_100
        );
 
    layer_1             <=  "00000000" when counter_100 = 0 else
                            "00000001" when (counter_100 > 100) and (counter_100 < 999) else
                            "00001111" when (counter_100 > 1000) and (counter_100< 1500) else
                            "00000000";
 
    layer_2             <=  "00000000" when counter_100 = 0 else
                            "00000001" when (counter_100 > 150) and (counter_100< 999) else
                            "00010010" when (counter_100 > 1000) and (counter_100< 1500) else
                            "00000000";
 
    layer_3             <=  "00000000" when counter_100 = 0 else
                            "00000001" when (counter_100 > 200) and (counter_100< 999) else
                            "00000101" when (counter_100 > 1000) and (counter_100< 1500) else
                            "00000000";
							
    reset               <=  '0' when counter_100 = 0 else
                            '1' when (counter_100 > 1) and (counter_100< 40) else
                            '0';

    start_comparison    <=   '1' when (counter_100 > 70) and (counter_100< 2000) else
                             '0';
 
end behav;
