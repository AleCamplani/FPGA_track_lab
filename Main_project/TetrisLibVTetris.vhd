library ieee;
use ieee.std_logic_1164.all;

package TetrisLib is
	constant TetrisWidth		: integer			:= 11;
	constant TetrisHeight		: integer			:= 20;
	constant TetrisShapeSize	: integer			:= 3;
	constant TetrisShapeCount	: integer			:= 7;
	constant TetrisFirstX		: integer			:= 4;
	constant TetrisFirstY		: integer			:= -3;
	
	constant ShowTetrisSize		: integer			:= 5;
	constant MapStartX			: integer			:= 440;
	constant MapStartY			: integer			:= 340;
	constant move_clk_const		: integer			:= 1000;
	constant control_clk_const	: integer			:= 50000;
	constant clk_rng_const      : integer           := 6;
	constant RNG_Mod            : integer           := 999983;
	
	subtype tetris_shape is std_logic_vector(TetrisShapeSize * TetrisShapeSize - 1 downto 0);
	
	type tetris_array is array (TetrisHeight - 1 downto 0) of std_logic_vector(TetrisWidth - 1 downto 0);
	type tetris_shape_rot is array (3 downto 0) of tetris_shape;
	type tetris_shape_array is array (TetrisShapeCount - 1 downto 0) of tetris_shape_rot;
	
	constant TetrisShapes		: tetris_shape_array:= (("100010001", "001010100", "100010001", "001010100"),
														("001010100", "100010001", "001010100", "100010001"),
														("110001000", "001001010", "000100011", "010100100"),
														("000001110", "100100010", "011100000", "010001001"),
														("100011000", "001010010", "000110001", "010010100"),
														("000011100", "100010010", "001110000", "010010001"),
														("000111000", "010010010", "000111000", "010010010"));

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
end TetrisLib;

package body TetrisLib is
	function DrawTetrisMap(	H_counter		: integer;
							V_counter		: integer;
							H_0				: integer;
							V_0				: integer;
							size			: integer;
							tetris_map		: tetris_array) return std_logic is
					 
		variable			Draw			: std_logic	:= '0';
	begin
	    if (H_counter - H_0 >= 0
			and H_counter - H_0 < TetrisWidth * size
			and V_counter - V_0 >= 0
			and V_counter - V_0 < TetrisHeight * size) then
    
            if (H_counter - H_0 = 0
                or H_counter - H_0 = TetrisWidth * size - 1
                or V_counter - V_0 = 0
                or V_counter - V_0 = TetrisHeight * size - 1) then
                
                Draw := '1';
            end if;
        
            for v in TetrisHeight - 1 downto 0 loop
                for h in TetrisWidth - 1 downto 0 loop
                    if (H_counter - H_0 >= h * size
                        and H_counter - H_0 < (h + 1) * size
                        and V_counter - V_0 >= v * size
                        and V_counter - V_0 < (v + 1) * size) then
                        
                        if (tetris_map(v)(h) = '1') then
                            Draw := '1';
                        end if;
                    end if;
                end loop;
            end loop;
        end if;
	
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
						Draw := '1';
						
					end if;
				end if;
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
						or piece_posy + y >= TetrisHeight) then
						Collided := '1';
					-- Test if it collided
					elsif tetris_map(piece_posy + y)(piece_posx + x) = '1' then
						Collided := '1';
					end if;
				end if;
			end loop;
		end loop;
		
		return Collided;
	end function;
end package body TetrisLib;