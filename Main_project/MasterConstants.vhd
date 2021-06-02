library ieee;
use ieee.std_logic_1164.all;

package MasterConstants is

-- id's
	constant id_straight 			: integer				:= 0;
	constant id_bend_left 			: integer				:= 1;
	constant id_bend_right 			: integer				:= 2;
	constant id_fork_left 			: integer				:= 3;
	constant id_fork_right 			: integer				:= 4;
	constant id_diag_left 			: integer				:= 5;
	constant id_diag_right 			: integer				:= 6;

-- General constants
	constant shape_count			: integer				:= 7;
	constant line_width				: integer 				:= 8;
	
-- Layer
	subtype layer 					is std_logic_vector(line_width - 1 downto 0);
	
-- Vectors
	type integer_array				is array (shape_count - 1 downto 0) of integer;
	type layer_array				is array (shape_count - 1 downto 0) of layer;
	type pos_vector 				is array (1 downto 0) of integer;
	type pos_vector_array			is array (shape_count - 1 downto 0) of pos_vector;
	
-- shapes
	constant shape					: pos_vector_array		:= (( 2, 1),
																(-2,-1),
																( 1, 1),
																(-1,-1),
																( 1, 0),
																(-1, 0),
																( 0, 0));
	
-- Checks if a shape exists
	function CheckShape(TestShape: pos_vector;
						Layer1   : layer;
						Layer2   : layer;
						Layer3   : layer;
						Position : integer) return std_logic;

end MasterConstants;

package body MasterConstants is


	function CheckShape(TestShape: pos_vector;
						Layer1   : layer;
						Layer2   : layer;
						Layer3   : layer;
						Position : integer) return std_logic is
		
		variable        Match    : std_logic        := '0';
	begin
		if (Position + TestShape(1) >= 0 and Position + TestShape(1) < line_width) then
			Match := Layer1(Position) and Layer2(Position + TestShape(0)) and Layer3(Position + TestShape(1));
		end if;
		
		return Match;
	end function;
	
end package body MasterConstants;