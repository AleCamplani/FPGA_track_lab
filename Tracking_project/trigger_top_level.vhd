------------------------------  <-  80 chars  ->  ------------------------------
--! Design     : Top level simple trigger 
--! Email      : alessandra.camplani@cern.ch
--! Created    : 14.12.2020
--! Comments   : NBI project
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity trigger_top_level is
    port (
        clock_100           : in  std_logic; -- 100MHz oscillator connected to pin W5
        reset               : in  std_logic; -- button W19
        
        layer_1             : in  std_logic_vector(7 downto 0); -- J1, L2, J2, G2, H1, K2, H2, G3,
        layer_2             : in  std_logic_vector(7 downto 0); -- A14, A16, B15, B16, A15, A17, C15, C16,
        layer_3             : in  std_logic_vector(7 downto 0); -- K17, M18, N17 P18, L17, M19, P17, R18
        
        start_comparison    : in std_logic; -- Switch V17
        
        -- 
        found_match         : out std_logic -- LED U16 

    );
end trigger_top_level;

architecture behav of trigger_top_level is

    signal layer_1_i                    : std_logic_vector(7 downto 0);
    signal layer_2_i                    : std_logic_vector(7 downto 0);
    signal layer_3_i                    : std_logic_vector(7 downto 0);
    signal start_comparison_i           : std_logic;

    attribute mark_debug                : string;
    attribute mark_debug of layer_1_i   : signal is "true";
    attribute mark_debug of layer_2_i   : signal is "true";
    attribute mark_debug of layer_3_i   : signal is "true";


begin
--------------------------------------------------------------------------------
------------------ Algorithm for single hit per layer --------------------------
--------------------------------------------------------------------------------

--- o - o - X - o - o - o ---
---
--- o - o - X - o - o - o ---
---
--- o - o - X - o - o - o ---

-- Let's clock the signals
    clocking : process(clock_100)
    begin
        if rising_edge(clock_100) then
            start_comparison_i  <= start_comparison;
            layer_1_i           <= layer_1;
            layer_2_i           <= layer_2;
            layer_3_i           <= layer_3;
        end if;
    end process;

    inst_ent: entity work.algo
        port map(
            clock_100         => clock_100,
            reset             => reset,
    
            start_comparison  => start_comparison,
            layer_1           => layer_1_i,
            layer_2           => layer_2_i,
            layer_3           => layer_3_i,
    
            found_match       => found_match
        );

end behav;
