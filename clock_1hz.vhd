library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

entity scale_clock is
  port (
    clk_100Mhz : in  std_logic;
    rst       	: in  std_logic;
    clk_1Hz   	: out std_logic);
end scale_clock;

architecture Behavioral of scale_clock is

  signal prescaler : unsigned(23 downto 0);
  signal clk_1Hz_i : std_logic;
begin

  gen_clk : process (clk_100Mhz, rst)
  begin  -- process gen_clk
    if rst = '1' then
      clk_1Hz_i   <= '0';
      prescaler   <= (others => '0');
    elsif rising_edge(clk_100Mhz) then   -- rising clock edge
      --if prescaler = X"BEBC20" then     -- 12 500 000 for 50Mhz clock
		if prescaler = X"17D7840" then
        prescaler   <= (others => '0');
        clk_1Hz_i   <= not clk_1Hz_i;
      else
        prescaler <= prescaler + "1";
      end if;
    end if;
  end process gen_clk;

clk_1Hz <= clk_1Hz_i;

end Behavioral;