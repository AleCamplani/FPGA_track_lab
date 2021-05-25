------------------------------  <-  80 chars  ->  ------------------------------
--! Design     : examplerithm
--! Email      : alessandra.camplani@cern.ch
--! Created    : 25.5.2021
--! Comments   : NBI project
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity example is
    port (
        clock_100           : in  std_logic;
        
        input_A             : in  std_logic;
        input_B             : in  std_logic;

        output_C            : out std_logic := '0'
    );
end example;

architecture behav of example is

begin

    process(clock_100)
    begin
        if rising_edge(clock_100) then
            output_C <= input_A and input_B;
        end if;
    end process;

end behav;
