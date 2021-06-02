------------------------------  <-  80 chars  ->  ------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;

entity anyline is
    port (
        clock_100           : in  std_logic;
        
        layer_1             : in  std_logic_vector(7 downto 0);
        layer_2             : in  std_logic_vector(7 downto 0);
		layer_3				: in  std_logic_vector(7 downto 0);
		
		reset               : in std_logic;
		start_comparison    : in std_logic;

        Found_match         : out std_logic := '0'
    );
end anyline;

architecture behav of anyline is
    -- Define constants and types
    -- The number og shapes to look for
    --constant SHAPECOUNT : integer   := 4;
    
    -- integer array
    --type integer_vector is array((SHAPECOUNT - 1) downto 0) of integer;
    
    -- The leth of the layers
    --constant LAYERLEN   : integer     := 8;
    --constant LAYERCOUNT : integer 
    
    -- The sizes of the lines
    --constant SIZES      : integer_vector := (1, 2, 2, 3);
    --constant START      : integer_vector := (0, 1, 3, 5);
    --constant SHAPELEN   : integer        := 8;
    
    -- shape of the lines
    --constant SHAPES     : std_logic_vector((3 * SHAPELEN - 1) downto 0) := "111101001100101100010001";

	-- Function to look for matches
	type pos_vector is array(1 downto 0) of integer;
	
	function CheckShape(Shape    : pos_vector := (0,0);
						Layer1   : std_logic_vector := "00000000";
						Layer2   : std_logic_vector := "00000000";
						Layer3   : std_logic_vector := "00000000";
						Position : integer          := 0) return std_logic is
		
		variable        Match    : std_logic        := '0';
	begin
		if (Position + pos_vector(1) < 0 or Position + pos_vector(1) > 7) then
			Match := Layer1(Position) and Layer2(Position + Shape(0)) and Layer3(Position + Shape(1));
		end if;
		
		return Match;
	end function;

	signal ready        : std_logic := '0';
    signal match        : std_logic := '0';

begin

    ready_proc: process(clock_100)
    begin
        if rising_edge(clock_100) then
			if reset = '1' then
				ready <= '0';
			else
				ready <= start_comparison;
			end if;
		end if;
	end process;
	
    comp_right_proc: process(clock_100)
    begin
        if rising_edge(clock_100) then
			match <= '0';
			
			if ready = '1' then
				for i in 7 downto 0 loop
					match <= match or CheckShape(Shape    => "111",
															 Size     => 1,
															 Position => i,
															 Layer1   => layer_1,
															 Layer2   => layer_2,
															 Layer3   => layer_3);
				end loop;
			end if;
        end if;
        
        Found_match <= match;
    end process;

end behav;