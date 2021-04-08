----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2021 08:49:52
-- Design Name: 
-- Module Name: testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
end testbench;

architecture Behavioral of testbench is

    component main
    Port (
           clock    : in STD_LOGIC;
           reset    : in STD_LOGIC;
           switch   : in STD_LOGIC;
           led      : out STD_LOGIC
          );
    end component main;

    constant clk_period : time := 10 ns;
    
    signal reset : std_logic := '0';									-- Wejœcie resetuj¹ce pamiêæ licznika RESET
    signal clock : std_logic := '0';									-- Wejœcie zegara CLK
    
    signal switch : std_logic := '0'; 
    signal led : std_logic := '0';
    
begin
    
    
    -- Definicja procesu zegara CLK
   CLK_process :process
   begin
		clock <= '0';
		wait for CLK_period/2;
		clock <= '1';
		wait for CLK_period/2;
   end process CLK_process;

    
-- Component instances
    uut : main Port map( clock     => clock,
               reset     => reset,
               switch    => switch,
               led       => led);

-- Stimulus process
    switch_stimulus : process
    begin
        switch <= '0';
        wait for clk_period*10;
        switch    <= '1';
        wait for clk_period*1000;
        switch    <= '0';
        wait for 2 ms; 
        assert false severity failure;
    end process switch_stimulus;    

end Behavioral;
