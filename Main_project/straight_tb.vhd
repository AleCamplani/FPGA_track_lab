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

entity straight_tb is
    
end straight_tb;

architecture behav of straight_tb is

    signal clock_100           : std_logic                      := '0';

    signal layer_1             : std_logic_vector(7 downto 0)   := (others => '0');
    signal layer_2             : std_logic_vector(7 downto 0)   := (others => '0');
    signal layer_3             : std_logic_vector(7 downto 0)   := (others => '0');

    signal reset               : std_logic                      := '0';
    signal start_comparison    : std_logic                      := '0';

    signal Found_match         : std_logic                      := '0';

    signal counter_100         : integer                        := 0;

begin

    dut: entity work.straight
        port map(
            clock_100         => clock_100,
    
            layer_1           => layer_1,
            layer_2           => layer_2,
            layer_3           => layer_3,
			
			reset             => reset,
            start_comparison  => start_comparison,
    
            Found_match       => Found_match
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
                            "00000001" when (counter_100 > 50) and (counter_100< 1000) else
                            "00000000";
 
    layer_2             <=  "00000000" when counter_100 = 0 else
                            "00000001" when (counter_100 > 50) and (counter_100< 1000) else
                            "00000000";
 
    layer_3             <=  "00000000" when counter_100 = 0 else
                            "00000010" when (counter_100 > 1) and (counter_100< 1000) else
                            "00000000";
							
    reset               <=  '0' when counter_100 = 0 else
                            '1' when (counter_100 > 1) and (counter_100< 40) else
                            '0';

    start_comparison    <=   '1' when (counter_100 > 70) and (counter_100< 1000) else
                             '0';
 
end behav;
