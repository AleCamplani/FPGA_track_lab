------------------------------  <-  80 chars  ->  ------------------------------
--! Design     : Tb 
--! Author     : Alessandra Camplani
--! Email      : alessandra.camplani@cern.ch
--! Created    : 14.12.2020
--! Comments   : NBI project
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity example_tb is

end example_tb;

architecture behav of example_tb is

    signal clock_100        : std_logic             := '0';
    signal input_A          : std_logic             := '0';
    signal input_B          : std_logic             := '0';
    signal output_C         : std_logic             := '0';

    signal counter_100      : integer               := 0;

begin

    dut: entity work.example
        port map(
            clock_100         => clock_100,
    
            input_A           => input_A,
            input_B           => input_B,
            output_C          => output_C
        );

-- Clock generator 100 MHz
    sim_basics_clk100 : entity work.simulation_basics
        generic map (
            reset_duration => 0,
            clk_offset     => 5 ns,
            clk_period     => 10 ns
        )
        port map (
            clk     => clock_100,
            rst     => open,
            counter => counter_100
        );

    input_A             <=  '0' when counter_100 = 0 else
                            '1' when (counter_100 > 50) and (counter_100< 1000) else
                            '0';
 
    input_B             <=  '0' when counter_100 = 0 else
                            '1' when (counter_100 > 50) and (counter_100< 1000) else
                            '0';

end behav;
