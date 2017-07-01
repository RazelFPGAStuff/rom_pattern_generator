----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:52:27 06/10/2017 
-- Design Name: 
-- Module Name:    N_counter - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity N_counter is
	generic (
				N     		: integer := 8
				);
		port (
				i_clk 		: IN STD_LOGIC;
				i_clk_enable: IN STD_LOGIC;
				i_reset		: IN STD_LOGIC;
				o_count		: OUT STD_LOGIC_VECTOR(N-1 downto 0)
				);
end N_counter;

architecture Behavioral of N_counter is

signal count : STD_LOGIC_VECTOR ( N-1 downto 0);

begin

o_count <= count;

process (i_clk,i_clk_enable,i_reset) 
begin
	if i_reset='1' then 
			count 	<= (others => '0');
   elsif i_clk='1' and i_clk'event then
      if i_clk_enable='1' then
         count <= count + "1";
      end if;
   end if;
end process;
 
 

end Behavioral;

