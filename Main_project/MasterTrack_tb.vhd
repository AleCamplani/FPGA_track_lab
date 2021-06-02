------------------------------  <-  80 chars  ->  ------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.MasterConstants.all;

entity MasterTrack_tb is
    
end MasterTrack_tb;

architecture behav of MasterTrack_tb is

    signal clock_100            : std_logic                     := '0';

    signal layer_1              : layer                         := (others => '0');
    signal layer_2              : layer                         := (others => '0');
    signal layer_3              : layer                         := (others => '0');

    signal reset                : std_logic                     := '0';
    signal start_comparison     : std_logic                     := '0';

    signal counter_100          : integer                       := 0;

begin

    dut: entity work.MasterTrack
        port map(
            clock_100         	=> clock_100,
    
            layer_1           	=> layer_1,
            layer_2           	=> layer_2,
            layer_3           	=> layer_3,
			
			reset             	=> reset,
            start_comparison  	=> start_comparison
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
                            "00010000" when (counter_100 > 0) and (counter_100< 100) else
							"00010000" when (counter_100 > 100) and (counter_100< 200) else
							"00010000" when (counter_100 > 200) and (counter_100< 300) else
							"00010000" when (counter_100 > 300) and (counter_100< 400) else
							"00010000" when (counter_100 > 400) and (counter_100< 500) else
							"00010000" when (counter_100 > 500) and (counter_100< 600) else
							"00010000" when (counter_100 > 600) and (counter_100< 700) else
                            "00000000";
 
    layer_2             <=  "00000000" when counter_100 = 0 else
                            "00010000" when (counter_100 > 0) and (counter_100< 100) else
							"00010000" when (counter_100 > 100) and (counter_100< 200) else
							"00010000" when (counter_100 > 200) and (counter_100< 300) else
							"00001000" when (counter_100 > 300) and (counter_100< 400) else
							"00100000" when (counter_100 > 400) and (counter_100< 500) else
							"00001000" when (counter_100 > 500) and (counter_100< 600) else
							"00100000" when (counter_100 > 600) and (counter_100< 700) else
                            "00000000";
 
    layer_3             <=  "00000000" when counter_100 = 0 else
                            "00010000" when (counter_100 > 0) and (counter_100< 100) else
							"00001000" when (counter_100 > 100) and (counter_100< 200) else
							"00100000" when (counter_100 > 200) and (counter_100< 300) else
							"00001000" when (counter_100 > 300) and (counter_100< 400) else
							"00100000" when (counter_100 > 400) and (counter_100< 500) else
							"00000100" when (counter_100 > 500) and (counter_100< 600) else
							"01000000" when (counter_100 > 600) and (counter_100< 700) else
                            "00000000";
							
    reset               <=  '0' when counter_100 = 0 else
                            '1' when (counter_100 > 1) and (counter_100< 40) else
                            '0';

    start_comparison    <=   '1' when (counter_100 > 70) and (counter_100< 2000) else
                             '0';
 
end behav;
