------------------------------  <-  80 chars  ->  ------------------------------

-- Import Libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
library work;
use work.MasterConstants.all;

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
		
		--Outputs for turning on LED's
		LED_Compare			: out  std_logic; -- turned on when we are identfying tracks
		LED_UseCounts		: out  std_logic_vector(shape_count - 1 downto 0); -- turned on for what tracks we consider valid
		
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

            shape_found     => shape_found
        );

	-- map the shitches directly to the LED's next to them (so LED turns on when switch is on)
	LED_UseCounts		<= UseCounts;
	LED_Compare			<= start_comparison;

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

                Count 				<= var_count; -- send total valid count to the signal, so SSEG can use it
				shape_counts		<= var_shape_counts; -- send the array of counts for each track type to signal, so VGActrl can use it.
				
			end if;
        end if;
    end process;

end behav;