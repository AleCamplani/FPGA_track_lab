-- import libraries
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.MasterConstants.all;

package VGALib is
	--define constants, determined by the screen used
	
	--boundaries of the screen, in terms of the counters
	--depends on the clock speed for the signal
	constant H_Start 	: integer := 146; -- position of H_counter where the screen starts
	constant H_End		: integer := 785; -- position of H_counter where the screen ends
	constant V_Start	: integer := 35;  -- position of V_counter where the screen starts
	constant V_End		: integer := 514; -- position of V-counter where the screen ends
	
	--how much we slow the incoming clock to generate the clock for the VGA signal
	--since the generated clock changes every time clk_const clock cycles of the 
	--inputted clock, a clk_const of 1 will halve the clock frequency
	constant clk_const	: integer := 1;
	
	--Constans for how the tracks and logic vectors denoting if we found them are displayed
	constant boxSize	: integer := 20; --side length of each box we draw on screen
	constant Offset		: integer := 20; --How much we offset from te top left of the screen
	constant line_height: integer := 160; --Distance bwtween lines of tracks in the screen

	--Types:
	type draw_vector 	is array (2 downto 0) of integer; -- vectors for encoding shapes
	type draw_vector_array is array (6 downto 0) of draw_vector; -- array of draw_vectors
	
	--Encoding of the tracks for drawing them (layer_1,layer_2,layer_3)
	constant shape_data : draw_vector_array	:= ((0,1,2), -- diag right
												(2,1,0), -- diag left
												(0,1,1), -- fork right
												(2,1,1), -- fork left
												(0,0,1), -- bend right
												(2,2,1), -- bend left
												(1,1,1)); --straigt
	--function for drawing a track
	--takes as input the current position of the 'electron beam', (H_counter and V_counter)
	--the posiiton at which we should draw the shape (H_0 and V_0),
	--the size of each box and the shape to draw
	--returns true if we are at a point where we hould fill in, and false otherwise
	function DrawShape( H_counter 	: integer;
						V_counter 	: integer;
						H_0		  	: integer;
						V_0 	  	: integer;
						size 	  	: integer;
						shape     	: draw_vector) return std_logic;
	
	
	--function for drawing the logic vectors
	--exactly the same inputs and outputs as above, except we now take in a logic vector to draw.
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
						size 	  	: integer; 
						shape     	: draw_vector) return std_logic is
			
			variable	Draw	  	: std_logic	:= '0'; -- variable we return
		begin
			--the check is built by looping over a 3 by 3 box, since all tracks are a maxium of 3 wide, and 3 deep
			--each smaller box (9 in total) is a 'size' by 'size' square 
			for LayerCount in 2 downto 0 loop --loop over the layers in the detector
				for PosCount in 2 downto 0 loop --loop over the witdh of the track
					--If the position relative to the position we are supposed to draw in is inside this box, 
					--check if the shape dictates that we fill in the box:
					if (V_counter - V_0 >= LayerCount * size and V_counter - V_0 < (LayerCount + 1) * size) then -- check vertical
						if (H_counter - H_0 >= PosCount * size and H_counter - H_0 < (PosCount + 1) * size) then --check horizontal
							if (shape(LayerCount) = PosCount) then --check if we want to fill in
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
			
			variable		Draw		: std_logic := '0'; -- variable we return
		begin
			
			--Logic vector is drawn by making a number of boxes as long as the vector, and filling in the boxes where the vector contains a '1'
			for PosDraw in (line_width - 1) downto 0 loop -- Loop over boxes
				-- Check if we are in box number PosDraw
				if (H_counter - H_0 >= PosDraw * size --horizontal check
					and H_counter - H_0 < (PosDraw + 1) * size
					and V_counter - V_0 >= 0 -- vertical check
					and V_counter - V_0 < size) then
					
					if shape_counts(PosDraw) = '1' then -- If specified to draw in this bow, then draw
						Draw 	:= '1';

					elsif (H_counter - H_0 = PosDraw * size -- If on border, then draw always
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