library ieee;
use ieee.std_logic_1164.all;

package MasterConstants is

-- id's for track types
	constant id_straight 			: integer				:= 0;
	constant id_bend_left 			: integer				:= 1;
	constant id_bend_right 			: integer				:= 2;
	constant id_fork_left 			: integer				:= 3;
	constant id_fork_right 			: integer				:= 4;
	constant id_diag_left 			: integer				:= 5;
	constant id_diag_right 			: integer				:= 6;

-- General constants
	constant shape_count			: integer				:= 7; -- number of track types
	constant line_width				: integer 				:= 8; -- width of detector
	
-- Layer
	subtype layer 					is std_logic_vector(line_width - 1 downto 0);
	
-- Vectors
	type integer_array				is array (shape_count - 1 downto 0) of integer;
	type layer_array				is array (shape_count - 1 downto 0) of layer;
	type pos_vector 				is array (1 downto 0) of integer;
	type pos_vector_array			is array (shape_count - 1 downto 0) of pos_vector;
	
-- shapes
-- encoded as two integers, denoting relative position of layer_2 and layer_3 to layer_1
-- (layer_3, layer_2)
	constant shape					: pos_vector_array		:= (( 2, 1), -- diagonal right
																(-2,-1), -- diagonal left
																( 1, 1), -- fork right
																(-1,-1), -- fork left
																( 1, 0), -- bend right
																(-1, 0), -- bend left
																( 0, 0)); -- straight
	
-- Function for checking if TestShape exists at Position
	function CheckShape(TestShape: pos_vector;
						Layer1   : layer;
						Layer2   : layer;
						Layer3   : layer;
						Position : integer) return std_logic;

end MasterConstants;

package body MasterConstants is


	function CheckShape(TestShape: pos_vector; -- define function
						Layer1   : layer;
						Layer2   : layer;
						Layer3   : layer;
						Position : integer) return std_logic is
		
		variable        Match    : std_logic        := '0'; -- if not found, we return '0'
	begin
		--since some tracks can extend beyond the boundaries of the detector, we first check if the track type can
		--fit inside the detector at this position.
		--we assume that the signal in layer_3 is the one that is furthest from the signal in layer_1
		--for example a diagonal going left cannot start at the two leftmost positions in layer_1.
		if (Position + TestShape(1) >= 0 and Position + TestShape(1) < line_width) then
			--if the signal can fit, we check if it is there by anding the relevant signals together
			Match := Layer1(Position) and Layer2(Position + TestShape(0)) and Layer3(Position + TestShape(1)); 
		end if;
		
		return Match;
	end function;
	
end package body MasterConstants;