library ieee;
use ieee.std_logic_1164.all;
library work;
use work.MasterConstants.all;

package VGALib is
	constant H_Start 	: integer := 146;
	constant H_End		: integer := 785;
	constant V_Start	: integer := 35;
	constant V_End		: integer := 514;
	constant clk_const	: integer := 1;
	
	type draw_vector 	is array (2 downto 0) of integer;
	type draw_vector_array is array (6 downto 0) of draw_vector;
	
	constant shape_data : draw_vector_array	:= ((2,1,0),
												(0,1,2),
												(2,2,1),
												(0,0,1),
												(2,1,1),
												(0,1,1),
												(1,1,1));
	
	function DrawShape( H_counter 	: integer;
						V_counter 	: integer;
						H_0		  	: integer;
						V_0 	  	: integer;
						size 	  	: integer;
						shape     	: draw_vector) return std_logic;
	
	function DrawCounts(H_counter 	: integer;
						V_counter 	: integer;
						H_0		  	: integer;
						V_0 	  	: integer;
						size 	  	: integer;
						shape_counts: layer) return std_logic;
	
end VGALib;

package body VGALib is
	function DrawShape( H_counter 	: integer;
						V_counter 	: integer;
						H_0		  	: integer;
						V_0 	  	: integer;
						size 	  	: integer; --size of each box
						shape     	: draw_vector) return std_logic is
			
			variable	Draw	  	: std_logic	:= '0';
		begin
			--check what layer we are in:
			for LayerCount in 2 downto 0 loop
				for PosCount in 2 downto 0 loop
					if (V_counter - V_0 >= LayerCount * size and V_counter - V_0 < (LayerCount + 1) * size) then
						if (H_counter - H_0 >= PosCount * size and H_counter - H_0 < (PosCount + 1) * size) then
							if (shape(LayerCount) = PosCount) then
								Draw := '1';
							end if;
						end if;
					end if;
				end loop;
			end loop;
			
			return Draw;
		end function;
		
		function DrawCounts(H_counter 	: integer;
							V_counter 	: integer;
							H_0		  	: integer;
							V_0 	  	: integer;
							size 	  	: integer;
							shape_counts: layer) return std_logic is
			
			variable		Draw		: std_logic := '0';
		begin
			
			for PosDraw in (line_width - 1) downto 0 loop -- Loop over boxes
				if (H_counter - H_0 >= PosDraw * size -- Check if we are in box number PosDraw
					and H_counter - H_0 < (PosDraw + 1) * size
					and V_counter - V_0 >= 0
					and V_counter - V_0 < size) then
					
					if shape_counts(PosDraw) = '1' then -- If needed to draw then draw
						Draw 	:= '1';

					elsif (H_counter - H_0 = PosDraw * size -- If on border then draw it
						   or H_counter - H_0 = (PosDraw + 1) * size - 1
						   or V_counter - V_0 = 0
						   or V_counter - V_0 = size - 1) then
						Draw:= '1';
					end if;
				end if;
			end loop;

			return Draw;
		end function;
end package body VGALib;