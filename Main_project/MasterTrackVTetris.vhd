------------------------------  <-  80 chars  ->  ------------------------------

-- Import Libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;
use work.MasterConstants.all;
use work.TetrisLib.all;

--Define input and output signals
entity MasterTrack is
    port (
        clock_100         	: in  std_logic; --clock
        
		-- Inputs from the detector:
        layer_1             : in  layer; -- Layer type is defined in MasterConstants
        layer_2             : in  layer; 
		layer_3				: in  layer;
		
		--inputs from the user
		reset               : in std_logic; --signal for resetting (mapped to button)
		start_comparison    : in std_logic; --signal to tell the FPGA to start looking for tracks (mapped to switch)
		UseCounts			: in std_logic_vector(shape_count - 1 downto 0); --Signal for what tracks to consider valid (mapped to 7 switches)
		draw_tetris			: in std_logic;
		
		BTN_Reset			: in  std_logic;
		BTN_MoveLeft		: in  std_logic;
		BTN_MoveRight		: in  std_logic;
		BTN_RotateCCW		: in  std_logic;
		BTN_RotateCW		: in  std_logic;

		
		--Outputs for turning on LED's
		LED_Compare			: out  std_logic; -- turned on when we are identfying tracks
		LED_UseCounts		: out  std_logic_vector(shape_count - 1 downto 0); -- turned on for what tracks we consider valid
		LED_Tetris			: out  std_logic;
		LED_TetrisReset		: out  std_logic;
		
		--Outputs for the seven segment display
        SSEG_CA 			: out  std_logic_vector(7 downto 0); --common cathodes
        SSEG_AN 			: out  std_logic_vector(3 downto 0); --anodes for each display
		
		--Outputs for VGA control
        HS 					: out STD_LOGIC; --horizontal synch
		VS 					: out STD_LOGIC; --vertical synch
		r,g,b 				: out STD_LOGIC_VECTOR(3 downto 0) 	:= (others => '0') --color signals

    );
end MasterTrack;

--define signals
architecture behav of MasterTrack is
	
	signal ready           		: std_logic         := '0'; --used to check if we are ready to compare
	
	--array for saving where some track is identified
	signal shape_found			: layer_array		:= (others => (others => '0'));  
	--array of counts of each track shape found
	signal shape_counts			: integer_array		:= (others => 0);
	
	--total number of valid tracks
	signal Count				: integer			:= 0;
	
	signal t_map			: tetris_array						:= (others => (others => '0'));
	signal Piece_x			: integer							:= 0;
	signal Piece_y			: integer							:= 0;
	signal Piece_id			: integer							:= 0;
	signal Piece_rot		: integer							:= 0;
	signal RNG_Value		: integer							:= 1;
	signal TetrisReset		: std_logic							:= '1';
	signal TetrisNewPiece	: std_logic							:= '1';
	signal Score			: integer							:= 0;

    	
begin
    SSEG: entity work.SSEG -- Send relevant signals to the Seven segment control
        port map(
            clock_100         	=> clock_100,

			Count 			    => Count,
			
			SSEG_CA				=> SSEG_CA,
			SSEG_AN				=> SSEG_AN
        );
    VGActrl: entity work.VGActrl -- Send relevant signals to the VGA control
        port map(
            clock_100       => clock_100,

            HS 			    => HS,
            VS 			    => VS,
            r               => r,
            g               => g,
            b               => b,
			
			t_map           => t_map,
			Piece_x         => Piece_x,
			Piece_y         => Piece_y,
			Piece_rot       => Piece_rot,
			Piece_id        => Piece_id,

			
			draw_tetris 	=> draw_tetris,

            shape_found     => shape_found
        );

	-- map the shitches directly to the LED's next to them (so LED turns on when switch is on)
	LED_UseCounts		<= UseCounts;
	LED_Compare			<= start_comparison;
	LED_Tetris			<= draw_tetris;
	LED_TetrisReset		<= BTN_Reset;

    ready_proc: process(clock_100) --check if we are ready to compare (i.e. not resetting)
    begin
        if rising_edge(clock_100) then
			if reset = '1' then
				ready <= '0';
			else
				ready <= start_comparison;
			end if;
		end if;
	end process;
	
    comp_proc: process(clock_100) --process for comparing input signals to the tracks defined in MasterConstants
	-- variables for counting what we find, cannot be signals, since we need to change multiple times in one clock cycle
	variable var_shape_counts	: integer_array		:= (others => 0); 
	variable var_count			: integer			:= 0;

    begin
        if rising_edge(clock_100) then -- process is clocked, so proceeds sequentialy.
			if (reset = '1' or ready = '0') then
                --if resetting, set all to 0
				shape_found			<= (others => (others => '0'));
				shape_counts		<= (others => 0);
                Count 				<= 0;
				
			else -- if not resetting, do comparison
				-- start by setting counters to 0
				var_shape_counts	:= (others => 0);
				var_count			:= 0;
								
				for i in line_width - 1 downto 0 loop --look at position i
					for j in shape_count - 1 downto 0 loop -- look at shape j
						
						-- call funtion defined in MasterConstants to check for shape j in location i
						-- outputs '1' if shape was found, '0' otherwise.
						-- output is put directly in array of what shapes we found
						shape_found(j)(i) 	<= CheckShape(shape(j), layer_1, layer_2, layer_3, i);
						
						if shape_found(j)(i) = '1' then -- if we found the shape, increment the relevant counter
							var_shape_counts(j) := var_shape_counts(j) + 1;
						end if;					
					end loop;
				end loop;
				
				-- loop over the shapes, to find the total of the valid tracks
				for i in shape_count - 1 downto 0 loop -- shape number i
					if UseCounts(i) = '1' then -- if we are accepting shape number i (set by switch)
						var_count 	:= var_count + var_shape_counts(i); --increment counter
					end if;
				end loop;
				
				if draw_tetris = '1' then
					var_count		:= Score;
				end if;

                Count 				<= var_count; -- send total valid count to the signal, so SSEG can use it
				shape_counts		<= var_shape_counts; -- send the array of counts for each track type to signal, so VGActrl can use it.
				
			end if;
        end if;
    end process;

	main_proc: process(clock_100)
	variable collision			: std_logic := '0';
	variable var_t_map			: tetris_array:= (others => (others => '0'));
	variable var_piece_x		: integer	:= 0;
	variable var_piece_y		: integer	:= 0;
	variable var_rot_id			: integer	:= 0;
	variable var_piece_id		: integer	:= 0;
	variable var_score			: integer	:= 0;
	
	variable var2_piece_y		: integer	:= 0;
	variable var2_piece_x		: integer	:= 0;
	variable var2_rot_id		: integer	:= 0;

	variable move_clk_count  	: integer 	:= 0;
	variable control_clk_count	: integer	:= 0;
	
	variable ReadyLeft  	    : std_logic := '1';
	variable ReadyRight         : std_logic := '1';
	variable ReadyCCW           : std_logic := '1';
	variable ReadyCW            : std_logic := '1';
	
	variable ReadyReset    		: std_logic     := '1';
	
	begin
		if rising_edge(clock_100) then		
			if control_clk_count = control_clk_const then
				control_clk_count := 0;
				var_t_map		:= t_map;
				var_piece_x		:= Piece_x;
				var_piece_y		:= Piece_y;
				var_rot_id		:= Piece_rot;
				var_piece_id	:= Piece_id;
				var_score		:= Score;

				if TetrisReset = '1' then
					-- Reset the board
					var_t_map			:= (others => (others => '0'));
					
					-- Reset score
					var_score			:= 0;
					
					TetrisReset			<= '0';
				end if;
				
				if (ReadyReset = '1' and BTN_Reset = '1') then
					TetrisReset			<= '1';
					TetrisNewPiece		<= '1';
					ReadyReset          := '0';
				elsif BTN_Reset = '0' then
					ReadyReset          := '1';
				end if;
			
				if TetrisNewPiece = '1' then
					-- Create a new piece
					var_rot_id		:= 0;
					var_piece_id	:= RNG_Value mod TetrisShapeCount;
					
					-- Place the new piece
					var_piece_y		:= TetrisFirstY;
					var_piece_x		:= TetrisFirstX;
					
					TetrisNewPiece	<= '0';
				end if;
				
				--button stuff:
			
				if (ReadyLeft = '1' and BTN_MoveLeft = '1') then
					var2_piece_x	:= var_piece_x - 1;
					ReadyLeft       := '0';
				elsif (ReadyRight = '1' and BTN_MoveRight = '1') then
					var2_piece_x	:= var_piece_x + 1;
					ReadyRight      := '0';
				else
					var2_piece_x	:= var_piece_x;
				end if;
				
				if BTN_MoveLeft = '0' then
					ReadyLeft := '1';
				end if;
				
				if BTN_MoveRight = '0' then
					ReadyRight := '1';
				end if;
				
				if (ReadyCW = '1' and BTN_RotateCW = '1') then
					if var_rot_id = 0 then
						var2_rot_id	:= 3;
					else
						var2_rot_id	:= var_rot_id - 1;
					end if;
					ReadyCW := '0';
				elsif (ReadyCCW = '1' and BTN_RotateCCW = '1') then
					if var_rot_id = 3 then
						var2_rot_id	:= 0;
					else
						var2_rot_id	:= var_rot_id + 1;
					end if;
					ReadyCCW := '0';
				else
					var2_rot_id		:= var_rot_id;
				end if;
				
				if BTN_RotateCW = '0' then
					ReadyCW := '1';
				end if;
				
				if BTN_RotateCCW = '0' then
					ReadyCCW := '1';
				end if;
				
				if CheckCollision(var_t_map, TetrisShapes(var_piece_id)(var2_rot_id), var2_piece_x, var_piece_y) = '0' then
					var_piece_x		:= var2_piece_x;
					var_rot_id		:= var2_rot_id;
				end if;
				
				
				if move_clk_count = move_clk_const then --do process
					move_clk_count := 0;
					-- Move piece
					var2_piece_y 		:= var_piece_y + 1;
				
					-- check for collision
					if CheckCollision(var_t_map, TetrisShapes(var_piece_id)(var_rot_id), var_piece_x, var2_piece_y) = '1' then
						-- place the piece
						for x in TetrisShapeSize - 1 downto 0 loop
							for y in TetrisShapeSize - 1 downto 0 loop
								-- Check if game should reset
								if TetrisShapes(var_piece_id)(var_rot_id)(y * TetrisShapeSize + x) = '1' then
									if var_piece_y + y < 0 then
										TetrisReset				<= '1';
									else
										var_t_map(var_piece_y + y)(var_piece_x + x)	:= '1';
									end if;
								end if;
							end loop;
						end loop;
						
						TetrisNewPiece		<= '1';
						
						-- remove full lines
						for y in 0 to TetrisHeight - 1 loop
							if and_reduce(var_t_map(y)) = '1' then
								if y > 0 then
									for y_move in y - 1 downto 0 loop
										var_t_map(y_move + 1)	:= var_t_map(y_move);
									end loop;
								end if;
								
								var_t_map(0)					:= (others => '0');
								var_score						:= var_score + 1;
							end if;
						end loop;
					else -- move the piece
						var_piece_y			:= var2_piece_y;
					end if;
				else
					move_clk_count := move_clk_count + 1;
				end if;
				
				t_map			<= var_t_map;
				Piece_x			<= var_piece_x;
				Piece_y			<= var_piece_y;
				Piece_rot		<= var_rot_id;
				Piece_id		<= var_piece_id;
				Score			<= var_score;
			
			else
				control_clk_count := control_clk_count + 1;
			end if;
		end if;
	end process;

	RNG_proc: process(clock_100)
	begin
		if rising_edge(clock_100) then
		    RNG_Value     <=  (RNG_Value + 1) mod RNG_Mod;
		end if;
	end process;

end behav;