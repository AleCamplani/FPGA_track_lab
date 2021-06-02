------------------------------  <-  80 chars  ->  ------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity VGATest_tb is
    
end VGATest_tb;

architecture behav of VGATest_tb is

    signal clock_100           : std_logic                      := '0';

    signal reset                : STD_LOGIC                     := '0';

    signal counter_100         : integer                        := 0;

begin

    dut: entity work.VGATest
        port map(
            clock_100         => clock_100
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
 
end behav;
