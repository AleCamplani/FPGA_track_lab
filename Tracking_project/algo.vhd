------------------------------  <-  80 chars  ->  ------------------------------
--! Design     : Algorithm
--! Email      : alessandra.camplani@cern.ch
--! Created    : 14.12.2020
--! Comments   : NBI project
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity algo is
    port (
        clock_100           : in  std_logic; -- 100MHz oscillator connected to pin W5
        reset               : in  std_logic; -- button W19
        
        start_comparison    : in std_logic; -- Switch V17

        layer_1             : in  std_logic_vector(7 downto 0);
        layer_2             : in  std_logic_vector(7 downto 0);
        layer_3             : in  std_logic_vector(7 downto 0);
        
        -- 
        found_match         : out std_logic := '0'-- LED U16 
    );
end algo;

architecture behav of algo is

begin
--------------------------------------------------------------------------------
------------------ Algorithm for single hit per layer --------------------------
--------------------------------------------------------------------------------

--- o - o - X - o - o - o ---
---
--- o - o - X - o - o - o ---
---
--- o - o - X - o - o - o ---


    process(clock_100)
    begin
        if rising_edge(clock_100) then
            if reset = '1' then 

            elsif start_comparison = '1' then
                --
                -- YOUR ALGORITHM IMPLEMENTATION
                --
                
            end if;
        end if;
    end process;

end behav;
