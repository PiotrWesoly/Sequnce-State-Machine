library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-----------------------------------------------------
entity stateMachineInit is port( 
 i_clk:     in  std_logic;
 i_drv:     in  std_logic;
 o_flag:   out std_logic);
end;
-----------------------------------------------------
-----------------------------------------------------
architecture sequential of stateMachineInit is
type state is (Sidle, Sflag, midState);
signal currState, nextState: state;
signal previous_drv, one_check: std_logic;
signal var_counter, wait_signal: std_logic_vector(3 downto 0) :="0000";
begin

-----------------------------------------------------
stateMemory: process (i_clk, var_counter)
begin
 if( rising_edge(i_clk) ) then
	if(i_drv=previous_drv) then	
		var_counter<=var_counter + '1';
	else var_counter<="0001";		--	<====	if there is a change in drv then couter set  
	end if;					--		to 1 in order to not loose time for checking	
	if (var_counter=wait_signal) then	--	<====	waits for amount of time specified by wait_signal
		currState <= nextState;
		var_counter<="0000";
	end if;
	previous_drv<=i_drv;				
 end if;
end process stateMemory;
---------------------------------------------------
stateDecode:process(i_drv, currState)
begin


 case currState is
  when	Sidle =>
	o_flag <= '0';
	wait_signal<="1010";
	if(i_drv='0') then
		nextState <= midState;
	else
		nextState <= Sidle;
	end if;
  when	Sflag =>
	wait_signal<="0000";
	one_check<='0';	--				<====	set to zero, so that we can check the next 	
	o_flag <= '1';					--	sequence for drv='1'	
	if(i_drv='1') then
		nextState <= Sflag;
	else
		nextState <= Sidle;
	end if;
  when midState =>
	wait_signal<="0101";
	if(i_drv='0'and one_check='1') then
		o_flag<='0';
		nextState <= Sflag;
	elsif(i_drv='1' and one_check='1') then --	<====	if the second i_drv='1' occured in  
		wait_signal<="0001";		--		a sequence then go back to Sidle
		o_flag<='0';
		nextState <= Sidle;
	elsif (i_drv='1') then 
		wait_signal<="0000";
		one_check<='1'; 		-- 	<====	sequence 100ns, i_drv set to '1' occured
		o_flag<='0';
		nextState<=midState;
	end if;
  when	others =>
	nextState <= Sidle;
	o_flag <= '0';
end case;


end process stateDecode;
-----------------------------------------------------
end sequential;
