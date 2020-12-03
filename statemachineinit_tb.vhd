LIBRARY ieee;
LIBRARY generics;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE generics.components.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

	COMPONENT stateMachineInit
	PORT(
		i_clk : IN std_logic;
		i_drv : IN std_logic;          
		o_flag : OUT std_logic
		);
	END COMPONENT;

	SIGNAL i_clk :  std_logic;
	SIGNAL i_drv :  std_logic;
	SIGNAL o_flag :  std_logic;

BEGIN

	uut: stateMachineInit PORT MAP(
		i_clk => i_clk,
		i_drv => i_drv,
		o_flag => o_flag
	);


-- *** Test Bench - User Defined Section ***

   ck: PROCESS
   BEGIN
	i_clk<='0';
	for i in 1 to 1000 loop
		wait for 5ns;
		i_clk <= not i_clk;
	end loop;
	wait;
   END PROCESS;

   tb : PROCESS
   BEGIN
	i_drv<='0';
	wait for 110ns;
	i_drv<='1';
	wait for 20ns;
	i_drv<='0';
	wait for 60ns;
	i_drv<='1';
	wait for 100ns;
	i_drv<='0';
	wait for 30ns;
	i_drv<='1';
	wait for 10ns;
	i_drv<='0';
	wait for 110ns;
	i_drv<='1';
	wait for 10ns;
	i_drv<='0';
	wait for 40ns;
	i_drv<='1';
	
	
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
