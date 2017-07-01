----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:00:57 06/07/2017 
-- Design Name: 
-- Module Name:    counter30 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter30 is
		Port ( 	clk 		: IN  STD_LOGIC;
					q   		: OUT STD_LOGIC_VECTOR(29 DOWNTO 0)
				);
	
end counter30;

architecture Behavioral of counter30 is

signal count: STD_LOGIC_VECTOR(29 DOWNTO 0);



begin

q <= count;

-- Usage of Asynchronous resets may negatively impact FPGA resources 
-- and timing. In general faster and smaller FPGA designs will 
-- result from not using Asynchronous Resets. Please refer to 
-- the Synthesis and Simulation Design Guide for more information.

process (clk) 
begin
   if clk='1' and clk'event then
        count <= count + "1";
     
   end if;
end process;
 

end Behavioral;

