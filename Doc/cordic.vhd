-- ===================================================================================
-- Cordic
--
-- Version      : V 1.0
-- Creation     : 25/06/2016
-- Update       : 25/06/2016
-- Created by   : KHOYRATEE Farad
-- Updated by   : KHOYRATEE Farad
-- 
-- Purpose      :
--      * Sin and Cos
--		* An = 1.647 (Gain)
-- Update       :
--		* 
-- ===================================================================================

-- Standard --
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Fixed point --
--library IEEE_PROPOSED;
--use ieee_proposed.fixed_float_types.all; 
--use ieee_proposed.fixed_pkg.all;
use ieee.fixed_float_types.all; 
use ieee.fixed_pkg.all;

entity cordic_farad is 
generic (
	-- Fixed point --
	E		: integer	:= 2;
	DEC		: integer	:= 32;
	
	-- Cordic Iteration --
	Niter	: integer 	:= 12;
	
	-- Selection of mode --
	Mode 	: std_logic := '0'	-- 0 => Rotation mode, 1 => Vectoring mode
);
port(
	-- System --
	clk		:	in	std_logic;
	reset	:	in	std_logic;
	
	-- Control --
	enable 	:	in 	std_logic;		-- Launch calcul
	acq		:	out std_logic;		-- Send a pulse when calcul is finished
	
	-- Input --
	X_in	:	in	std_logic_vector(E+DEC downto 0);
	Y_in	:	in	std_logic_vector(E+DEC downto 0);
	z_in	:	in	std_logic_vector(E+DEC+1 downto 0);
	
	-- Output --
	X_out	:	out	std_logic_vector(E+DEC downto 0);
	Y_out	:	out	std_logic_vector(E+DEC downto 0);
	z_out	:	out	std_logic_vector(E+DEC+1 downto 0)
	
);
end entity cordic_farad;

architecture rtl of cordic_farad is

	-- Array --
	type x_y_array 		is array(0 to Niter) 	of signed(E+DEC downto 0);
	type z_array_t 		is array(0 to Niter) 	of signed(E+DEC+1 downto 0);
	type const_array 	is array(0 to 12) 		of signed(E+DEC+1 downto 0);
	
	signal x_array		:	x_y_array;
	signal y_array		:	x_y_array;
	signal z_array		:	z_array_t;
	
	-- atan(2^-i) --
	constant tan_array	:	const_array	:=	(
												signed(std_logic_vector(to_sfixed(0.7854,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.4636,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.2450,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.1244,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.0624,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.0312,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.0156,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.0078,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.0039,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.0020,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.0009756,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.00048828,E+1, -DEC))),
												signed(std_logic_vector(to_sfixed(0.00024414,E+1, -DEC)))
												
											);
	
	-- Gain --
	constant An			:	sfixed(E downto -DEC) := to_sfixed(1.647, E, -DEC);		
	
	-- State machine --
	type fsm is ( IDLE, OPERATION, ACQUITMENT);
	signal cordic_fsm 			: fsm;
	
	-- Iteration of the Cordic Algorithm --
	signal iteration_counter 	: integer := 0;
	
	-- Depending on "Mode" for vectoring or rotation --
	signal mode_selection  		: std_logic;

begin


-- Value of Rho depending of the mode --
mode_selection <= 	'1' when z_array(iteration_counter) < to_signed(0, E+DEC+1) and Mode = '0' else
					'1' when y_array(iteration_counter) < to_signed(0, E+DEC) and Mode = '1' else
					'0';


fsm_handle : process(clk)
begin
	if rising_edge(clk) then
		if reset = '1' then
			X_out		<= (others => '0');
			Y_out		<= (others => '0');
			z_out		<= (others => '0');
			
			acq 				<= '0';
			iteration_counter 	<= 0;
			cordic_fsm			<= IDLE;
		else
			case cordic_fsm is
				when IDLE =>
					acq 	<= '0';
					
					-- Waiting a signal to begin -- 
					if enable = '1' then
						cordic_fsm	<= OPERATION;
					end if;
				when OPERATION =>
					-- Increment signal for Iteration --
					if iteration_counter > Niter - 2 then
						iteration_counter 	<= 0;
						cordic_fsm			<= ACQUITMENT;
					else
						iteration_counter <= iteration_counter + 1;
					end if;
				when ACQUITMENT =>
					
					-- Save the result --
					X_out		<= std_logic_vector(x_array(Niter));
					Y_out		<= std_logic_vector(y_array(Niter));
					z_out		<= std_logic_vector(z_array(Niter));
					
					-- Send an acquitment --
					acq 		<= '1';
					
					cordic_fsm	<= IDLE;
			end case;
		end if;
	end if;
end process;

calcul_core : process(clk)
begin
	if rising_edge(clk) then
		if reset = '1' then
			x_array		<=	(others => (others => '0'));
			y_array		<=	(others => (others => '0'));
			z_array		<=	(others => (others => '0'));
		else
			if cordic_fsm = OPERATION then
				if mode_selection = '1' then
					x_array(iteration_counter+1) <= x_array(iteration_counter) + shift_right(y_array(iteration_counter), iteration_counter);
					y_array(iteration_counter+1) <= y_array(iteration_counter) - shift_right(x_array(iteration_counter), iteration_counter);
					z_array(iteration_counter+1) <= z_array(iteration_counter) + tan_array(iteration_counter);
				else
					x_array(iteration_counter+1) <= x_array(iteration_counter) - shift_right(y_array(iteration_counter), iteration_counter);
					y_array(iteration_counter+1) <= y_array(iteration_counter) + shift_right(x_array(iteration_counter), iteration_counter);
					z_array(iteration_counter+1) <= z_array(iteration_counter) - tan_array(iteration_counter);
				end if;
			else
				x_array(0) <= signed(X_in);
				y_array(0) <= signed(Y_in);
				z_array(0) <= signed(z_in);
			end if;
		end if;
	end if;
end process;


end architecture rtl;