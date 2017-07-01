----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:41:44 06/10/2017 
-- Design Name: 
-- Module Name:    Clock_Generator - Behavioral 
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

entity Clock_Generator is
	generic (
				N     		: integer := 8
				);
		port (
				i_clk 		: IN STD_LOGIC;
				i_clk_enable: IN STD_LOGIC;
				i_reset		: IN STD_LOGIC;
				i_num_clk	: IN STD_LOGIC_VECTOR(N-1 downto 0);
				o_var_clk	: OUT STD_LOGIC_VECTOR(1 downto 0)
				);
end Clock_Generator;

architecture Behavioral of Clock_Generator is

--signal count: STD_LOGIC_VECTOR(N-1 downto 0);
signal count: STD_LOGIC_VECTOR(N-1 downto 0);
signal counter: STD_LOGIC_VECTOR(1 downto 0);
signal done: integer;

begin

o_var_clk <= counter;

process (i_clk,i_clk_enable,i_reset) 
begin
	if i_reset='1' then 
      count 	<= (others => '0');
		counter 	<= (others => '0');
		done 		<= 0;
   elsif i_clk='1' and i_clk'event then
      if (i_clk_enable='1' and done = 0) then
			if count < i_num_clk then
				count <= count + "1";
				done 	<= 0;
				counter <= counter + "1";
			elsif count = i_num_clk then
				count <= i_num_clk - "1";
				counter 	<= (others => '0');
				done 	<= 1;
			else
				count 	<= (others => '0');
				done 	<= 0;
				counter 	<= (others => '0');
				
			end if;
      end if;
   end if;
end process;




end Behavioral;

