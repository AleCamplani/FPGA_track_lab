------------------------------  <-  80 chars  ->  ------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity diagonal_tb is
    
end diagonal_tb;

architecture behav of diagonal_tb is

    signal clock_100           : std_logic                      := '0';
    signal layer_1             : std_logic_vector(7 downto 0)   := (others => '0');
    signal layer_2             : std_logic_vector(7 downto 0)   := (others => '0');
    signal layer_3             : std_logic_vector(7 downto 0)   := (others => '0');
    signal Found_match         : std_logic                      := '0';

    signal counter_100         : integer                        := 0;

begin

    dut: entity work.diagonal
        port map(
            clock_100         => clock_100,
    
            layer_1           => layer_1,
            layer_2           => layer_2,
            layer_3           => layer_3,
    
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
                            "00000100" when (counter_100 > 50) and (counter_100< 1000) else
                            "00000000";
 
    layer_2             <=  "00000000" when counter_100 = 0 else
                            "00000010" when (counter_100 > 50) and (counter_100< 1000) else
                            "00000000";
 
    layer_3             <=  "00000000" when counter_100 = 0 else
                            "00000001" when (counter_100 > 1) and (counter_100< 1000) else
                            "00000000";
 
end behav;
