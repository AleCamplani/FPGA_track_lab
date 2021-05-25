-------------------------------------------------------------------------------
-- Design     : simulation_basics.vhd
-- Author     : Steffen Staerz
-- Maintainer : Alessandra Camplani
-- Email      : alessandra.camplani@cern.ch
-- Comments   : Basic module for any simulation creating clk, rst and counter
-------------------------------------------------------------------------------
-- Details    :
-- Generates the basic required signals for any simulation
-- Creates a clock with clk_period defined via generic
-- Creates reset at the first 10 clock cycles
-- Provides a common counter for own testbench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity SIMULATION_BASICS is
generic (
    constant RESET_DURATION : natural := 40; -- in clk cycles
    constant CLK_OFFSET     : time := 0 ns;
    constant CLK_PERIOD     : time := 6.4 ns
);
port (
    -- clk  
    signal CLK              : out std_logic := '0';
    signal RST              : out std_logic := '0'; -- synch reset with clk
    signal COUNTER          : out integer := 0
);
end SIMULATION_BASICS;
 
architecture behavior of SIMULATION_BASICS is 

    signal CLK_I        : std_logic := '0';
    signal RST_I        : std_logic := '0';
    signal GBLCNT       : integer := 0;
    signal COUNTER_I    : integer := 0;

begin
    CLK     <= CLK_I;
    RST     <= RST_I;
    COUNTER <= COUNTER_I;

    -- Clock process definitions
    CLK_PROCESS : process
    begin
    --! wait for the offset
        wait for CLK_OFFSET;
        loop
        --! and then start with a rising edge
            CLK_I <= '1';
            GBLCNT <= GBLCNT + 1;
            wait for CLK_PERIOD/2;
            CLK_I <= '0';
            wait for CLK_PERIOD/2;
        end loop;
    end process; 

    RST_I <= '1' when gBLCNT < RESET_DURATION else '0';

    COUNTING: process(CLK_I)
    begin
        if rising_edge(CLK_I) then
            if RST_I = '1' then
                COUNTER_I <= 0;
            else
                COUNTER_I <= COUNTER_I + 1;
            end if;
        end if;
    end process;
end;