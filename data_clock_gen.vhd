----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:31:52 06/16/2017 
-- Design Name: 
-- Module Name:    data_clock_gen - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_clock_gen is
    Port(
		  i_clk 		: in  STD_LOGIC;
        i_reset  	: in  STD_LOGIC;
		  i_data		: in  STD_LOGIC;
		  o_data		: out STD_LOGIC
		  );
end data_clock_gen;

architecture Behavioral of data_clock_gen is

--signal count_rise, count_fall :integer range 0 to 100 := 0; --count 
signal count_rise, count_fall :integer range 0 to 200000000 := 0; --count 

begin

process (i_clk, i_reset, i_data) begin
			if (i_reset = '1') then
				count_rise 	<= 0;
				count_fall 	<= 0;
				o_data 		<= '0';
				
			elsif rising_edge(i_clk) then
            --if  (counter1 > 12) and (counter2 < 37) and (TCLK = '1') then -- for 50 Mhz
				-- if  (count_rise > 24) and (count_fall < 74) and (i_data = '1') then --for 100 Mhz
				 if  (count_rise > 49999999) and (count_fall < 149999999) and (i_data = '1') then --for 100 Mhz
                count_rise <= count_rise + 1;
					 count_fall <= count_fall + 1;
                o_data 		<= '1';
			   --elsif (counter1 = 49) then
				 elsif (count_rise = 199999999) then --reset counter back to zero 
					 count_rise <= 0;
					 count_fall <= 0;
					 o_data 		<= '0';

             else
                count_rise <= count_rise + 1;
					 count_fall <= count_fall + 1;
					 o_data 		<= '0';
             end if;
		end if;	
 end process;				
end Behavioral;

