--------------------------------------------------------------------------
-- flashlight.vhd
--
-- HDL for the flashlight sample.  This HDL describes two flashlight operating
-- on different board clocks and with slightly different functionality.
-- The counter controls and counter values are connected to endpoints so
-- that FrontPanel may control and observe them.
--
-- Copyright (c) 2005-2009  Opal Kelly Incorporated
-- $Rev$ $Date$
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;
use work.FRONTPANEL.all;

entity flashlight is
	port (
		hi_in    : in STD_LOGIC_VECTOR(7 downto 0);
		hi_out   : out STD_LOGIC_VECTOR(1 downto 0);
		hi_inout : inout STD_LOGIC_VECTOR(15 downto 0);
		
		clk1     : in STD_LOGIC;
		clk2     : in STD_LOGIC;
		led      : out STD_LOGIC_VECTOR(7 downto 0);
		button   : in STD_LOGIC_VECTOR(3 downto 0)
	);
end flashlight;



architecture arch of flashlight is


COMPONENT counter30
  PORT (
			clk 			: IN STD_LOGIC;
			q 				: OUT STD_LOGIC_VECTOR(29 DOWNTO 0)
			);
END COMPONENT;

COMPONENT memory
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

COMPONENT Clock_Generator
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
end COMPONENT;

COMPONENT N_counter 
	generic (
				N     		: integer := 4
				);
		port (
				i_clk 		: IN STD_LOGIC;
				i_clk_enable: IN STD_LOGIC;
				i_reset		: IN STD_LOGIC;
				o_count		: OUT STD_LOGIC_VECTOR(N-1 downto 0)
				);
end COMPONENT;

COMPONENT data_clock_gen
	port (
		  i_clk 		: in  STD_LOGIC;
        i_reset  	: in  STD_LOGIC;
		  i_data		: in  STD_LOGIC;
		  o_data		: out STD_LOGIC
		  );
end COMPONENT;

COMPONENT scale_clock
  port (
    clk_100Mhz : in  std_logic;
    rst       	: in  std_logic;
    clk_1Hz   	: out std_logic);
end COMPONENT;



	signal ti_clk : STD_LOGIC;
	signal ok1 : STD_LOGIC_VECTOR(30 downto 0);
	signal ok2 : STD_LOGIC_VECTOR(16 downto 0);
	signal ok2s : STD_LOGIC_VECTOR(17*5-1 downto 0);

	signal ep00wire : STD_LOGIC_VECTOR(15 downto 0);
   signal ep01wire : STD_LOGIC_VECTOR(15 downto 0);
	signal ep02wire : STD_LOGIC_VECTOR(15 downto 0);
	
--	signal ep20wire : STD_LOGIC_VECTOR(15 downto 0);
--	signal ep21wire : STD_LOGIC_VECTOR(15 downto 0);
--	signal ep22wire : STD_LOGIC_VECTOR(15 downto 0);
--	signal ep40wire : STD_LOGIC_VECTOR(15 downto 0);
--	signal ep60trig : STD_LOGIC_VECTOR(15 downto 0);
--	signal ep61trig : STD_LOGIC_VECTOR(15 downto 0);

	signal not_led: STD_LOGIC_VECTOR(7 downto 0);
	signal not_data_clk: STD_LOGIC;
	signal count: std_logic_vector(29 downto 0);	
	signal mem_addr: std_logic_vector(2 downto 0);	
	
	signal var_clk_enable : std_logic;
	signal num_clk : STD_LOGIC_VECTOR(7 downto 0);
	signal var_clk : STD_LOGIC_VECTOR ( 1 downto 0);
	signal addr : std_logic_vector(2 downto 0);
	
	signal clock_1hz: std_logic;
	
	signal reset : STD_LOGIC;
	
begin


--reset1     <= ep00wire(0);
--disable1   <= ep00wire(1);
--autocount2 <= ep00wire(2);
----ep20wire   <= ("00000000" & count1);
--ep21wire   <= ("00000000" & count2);
----ep22wire   <= ("000000000000" & not button);
--reset2     <= ep40wire(0);
--up2        <= ep40wire(1);
--down2      <= ep40wire(2);
----ep60trig   <= ("00000000000000" & count1eq80 & count1eq00);
--ep61trig   <= ("000000000000000" & count2eqFF);
--led        <= not count2; --was count2

led(0)	 <= not not_led(0); --reverse 
led(1)	 <= not not_led(1); --reverse 
led(2)	 <= not not_led(2); --reverse 
led(3)	 <= not not_led(3); --reverse 
led(4)	 <= not not_led(4); --reverse 
led(5)	 <= not not_led(5); --reverse 
led(6)	 <= not not_data_clk; --reverse --TCLK
led(7)	 <= not not_led(7); --reverse 

--control memory address here via 
mem_addr 		<= ep00wire ( 2 downto 0);

var_clk_enable <= ep02wire (0);
reset			   <= ep02wire (1);
num_clk			<= ep01wire (7 downto 0);

------ Instantiate new components here -----

u_counter30 : counter30
	PORT MAP (
			clk 	=> clk1,
			q 		=> count
				);
				
u_clock_gen: Clock_Generator
	GENERIC MAP (
				N     		=> 8
				)
   PORT MAP (
				i_clk 			=> count(20),
				i_clk_enable	=> var_clk_enable,
				i_reset		   => reset,
				i_num_clk		=> num_clk,
				o_var_clk		=> var_clk
				);
u_counter3: N_counter 
	GENERIC MAP (
				N     			=> 3
				)
	 PORT MAP (
				i_clk 		 	=> var_clk(0),
				i_clk_enable	=> var_clk_enable,
				i_reset		   => reset,
				o_count			=> addr
				);
				
				
u_scale_clock : scale_clock
  PORT MAP (
    clk_100Mhz => clk1,
    rst       	=> reset,
    clk_1Hz   	=> clock_1hz
		);		
u_memory : memory
  PORT MAP (
    clka 		=> count(20),
    addra 		=> addr, --mem_addr , --count(29 downto 27 ),--mem_addr ,
    douta 		=> not_led
  );
  
u_data_clock_gen : data_clock_gen
		PORT MAP (
		  i_clk 		=> clk1,
        i_reset  	=> reset,
		  i_data		=> not_led(6), --6 bit is TCLK
		  o_data		=> not_data_clk
					);
-- end of Instantiate new components here ---


-- Instantiate the okHost and connect endpoints
okHI : okHost port map (
		hi_in=>hi_in, hi_out=>hi_out, hi_inout=>hi_inout,
		ti_clk=>ti_clk, ok1=>ok1, ok2=>ok2);

okWO : okWireOR     generic map (N=>5) port map (ok2=>ok2, ok2s=>ok2s);

ep00 : okWireIn     port map (ok1=>ok1,                                  ep_addr=>x"00", ep_dataout=>ep00wire);
ep01 : okWireIn     port map (ok1=>ok1,                                  ep_addr=>x"01", ep_dataout=>ep01wire);
ep02 : okWireIn     port map (ok1=>ok1,                                  ep_addr=>x"02", ep_dataout=>ep02wire);

--ep20 : okWireOut    port map (ok1=>ok1, ok2=>ok2s( 1*17-1 downto 0*17 ), ep_addr=>x"20", ep_datain=>ep20wire);
--ep21 : okWireOut    port map (ok1=>ok1, ok2=>ok2s( 2*17-1 downto 1*17 ), ep_addr=>x"21", ep_datain=>ep21wire);
--ep22 : okWireOut    port map (ok1=>ok1, ok2=>ok2s( 3*17-1 downto 2*17 ), ep_addr=>x"22", ep_datain=>ep22wire);
--ep40 : okTriggerIn  port map (ok1=>ok1,                                  ep_addr=>x"40", ep_clk=>clk2, ep_trigger=>ep40wire);
--ep60 : okTriggerOut port map (ok1=>ok1, ok2=>ok2s( 4*17-1 downto 3*17 ), ep_addr=>x"60", ep_clk=>clk1, ep_trigger=>ep60trig);
--ep61 : okTriggerOut port map (ok1=>ok1, ok2=>ok2s( 5*17-1 downto 4*17 ), ep_addr=>x"61", ep_clk=>clk2, ep_trigger=>ep61trig);

end arch;
