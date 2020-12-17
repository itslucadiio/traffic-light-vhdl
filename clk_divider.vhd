----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2020 18:12:11
-- Design Name: 
-- Module Name: clk_divider - Behavioral
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

entity clk_divider is
    generic(eoc: integer := 100000);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_div : out STD_LOGIC);
end clk_divider;

architecture Behavioral of clk_divider is
signal div_cnt : integer range 0 to eoc := 0;
begin

    process (clk, reset) 
    begin
    if clk'event and clk = '1' then
        clk_div <= '0';
        if reset = '1' then
            div_cnt <= 0;
        elsif div_cnt = eoc then
            div_cnt <= 0;
            clk_div <= '1';
        else div_cnt <= div_cnt + 1;
        end if;
    end if;
    end process;

end Behavioral;
