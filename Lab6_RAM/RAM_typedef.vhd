library ieee;
use ieee.std_logic_1164.all;
 
package ram_td is
	type ram_signals is record
		clk:     std_logic;
      		Enable:  std_logic;
      		RD:      std_logic;
      		WR:      std_logic;
      		A_Write: std_logic_vector;
      		A_Read:  std_logic_vector;
      		D_in:    std_logic_vector;
      		D_out:   std_logic_vector;
	end record ram_signals;
end package ram_td;

