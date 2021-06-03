library ieee;
use ieee.std_logic_1164.all;

package VGALib is
	constant TetrisWidth	: integer		:= 10;
	constant TetrisHeight	: integer		:= 20;
	constant TetrisShapeSize: integer		:= 3;
	
	subtype tetris_array is std_logic_vector(TetrisHeight * TetrisWidth - 1 downto 0);
	subtype tetris_shape is std_logic_vector(TetrisShapeSize * TetrisShapeSize - 1 downto 0);

	function DrawTetrisMap(	H_counter		: integer;
							V_counter		: integer;
							H_0				: integer;
							V_0				: integer;
							size			: integer;
							tetris_map		: tetris_array) return std_logic;
							
	function DrawTetrisShape(H_counter		: integer;
							V_counter		: integer;
							H_0				: integer;
							V_0				: integer;
							size			: integer;
							shape			: tetris_shape) return std_logic;
end VGALib;

package body VGALib is
	function DrawTetrisMap(	H_counter		: integer;
							V_counter		: integer;
							H_0				: integer;
							V_0				: integer;
							size			: integer;
							tetris_map		: tetris_array) return std_logic is
					 
		variable			 Draw			: integer	:= '0';
	begin
		for v in TetrisWidth - 1 downto 0 loop
			for h in TetrisHeight - 1 downto 0 loop
				if (H_counter - H_0 >= h * size
					and H_counter - H_0 < (h + 1) * size
					and V_counter - V_0 >= v * size
					and V_counter - V_0 < (v + 1) * size) then
					
					if (tetris_map(TetrisWidth * v + h) = '1') then
						Draw = '1';
					end if;
				end if;
			end loop;
		end loop;
	
		return Draw;
	end function;
	
	function DrawTetrisShape(H_counter		: integer;
							V_counter		: integer;
							H_0				: integer;
							V_0				: integer;
							size			: integer;
							shape			: tetris_shape) return std_logic is
				
		variable 			Draw			: std_logic		:= '0';
	begin
		for v in TetrisShapeSize - 1 downto 0 loop
			for h in TetrisShapeSize - 1 downto 0 loop
				if (H_counter - H_0 >= h * size
					and H_counter - H_0 < (h + 1) * size
					and V_counter - V_0 >= v * size
					and V_counter - V_0 < (v + 1) * size) then
					
					if (shape(TetrisShapeSize * v + h) = '1') then
						Draw = '1';
			end loop;
		end loop;
	end function;
end package body VGALib;