library ieee;
use ieee.std_logic_1164.all;

package VGALib is
	constant TetrisWidth		: integer			:= 11;
	constant TetrisHeight		: integer			:= 20;
	constant TetrisShapeSize	: integer			:= 3;
	constant TetrisShapeCount	: integer			:= 7;
	constant TetrisFirstX		: integer			:= 5;
	constant TetrisFirstY		: integer			:= -2;
	
	constant ShowTetrisSize		: integer			:= 5;
	constant MapStartX			: integer			:= 100;
	constant MapStartY			: integer			:= 100;
	constant move_clk_const		: integer			:= 50000000;
	
	constant RNG_MOD			: integer			:= 0x7FFFFFFF;
	constant RNG_SIZE			: integer			:= 0x80000000;
	constant RNG_MULTIPLIER		: integer			:= 0x7FFFFFED;
	constant RNG_CONSTANT		: integer			:= 0x7FFFFFC3;
	
	subtype tetris_array is std_logic_vector(TetrisHeight * TetrisWidth - 1 downto 0);
	subtype tetris_shape is std_logic_vector(TetrisShapeSize * TetrisShapeSize - 1 downto 0);
	
	type tetris_shape_rot is array (3 downto 0) of tetris_shape;
	type tetris_shape_array is array (TetrisShapeCount - 1 downto 0) of tetris_shape_rot;
	
	constant TetrisShapes		: tetris_shape_array:= ((100010001), (001010100), (100010001), (001010100),
														(001010100), (100010001), (001010100), (100010001),
														(110001000), (001001010), (000100011), (010100100),
														(000001110), (100100010), (011100000), (010001001),
														(100011000), (001010010), (000110001), (010010100),
														(000011100), (100010010), (001110000), (010010001),
														(000111000), (010010010), (000111000), (010010010));

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
							
	function CheckCollision(tetris_map		: tetris_array;
							shape			: tetris_shape;
							piece_posx		: integer;
							piece_posy		: integer) return std_logic;
							
	function RNG(			seed			: integer) return integer;
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
		if (H_counter - H_0 = 0
			or H_counter - H_0 = TetrisHeight * size - 1
			or V_counter - V_0 = 0
			or V_counter - V_0 = TetrisWidth * size - 1) then
			
			Draw = '1';
		end if;
	
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
		
		return Draw;
	end function;
	
	function CheckCollision(tetris_map		: tetris_array;
							shape			: tetris_shape;
							piece_posx		: integer;
							piece_posy		: integer) return std_logic is
		
		variable Collided					: std_logic		:= '0';			
	begin
		for x in TetrisShapeSize - 1 downto 0 loop
			for y in TetrisShapeSize - 1 downto 0 loop
				if shape(y * TetrisShapeSize + x) = '1' then
					-- Test if it is outside of the valid range
					if (piece_posx + x < 0
						or piece_posx + x >= TetrisWidth
						or piece_posy + y < 0
						or piece_posy + y <= TetrisHeight) then
						Collided = '1';
					-- Test if it collided
					elsif tetris_map((piece_posy + y) * TetrisWidth + piece_posx + x) = '1' then
						Collided = '1';
					end if;
				end if;
			end loop;
		end loop;
		
		return Collided;
	end function;
	
	function RNG(			seed			: integer) return integer is
	
		variable NewNum						: integer := 0;
	begin
		NewNum 			<= (seed * RNG_MULTIPLIER + RNG_CONSTANT) mod RNG_MOD)
	
		return NewNum;
	end function;
end package body VGALib;