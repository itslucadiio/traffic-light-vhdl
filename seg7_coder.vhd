----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2020 18:46:39
-- Design Name: 
-- Module Name: seg7_coder - Behavioral
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

entity seg7_coder is
    Port ( char0 : in STD_LOGIC_VECTOR (3 downto 0);
           char1 : in STD_LOGIC_VECTOR (3 downto 0);
           char2 : in STD_LOGIC_VECTOR (3 downto 0);
           char3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_div : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end seg7_coder;

architecture Behavioral of seg7_coder is
signal digit_act : integer range 0 to 3 := 0;
signal in_ports:  std_logic_vector(3 downto 0);
begin

    digit_actual: process (clk, reset)
    begin
    if clk'event and clk = '1' then
        if reset = '1' then
            digit_act <= 0;
        elsif clk_div = '1' then
            if digit_act = 3 then
                digit_act <= 0;
            else digit_act <= digit_act + 1;
            end if; 
        end if;
    end if;
    end process;
    
    with digit_act select
        in_ports <= char0 when 0,
                    char1 when 1,
                    char2  when 2,
                    char3 when 3;
    
     with digit_act select
        an <= "1110" when 0,
                "1101" when 1,
                "1011" when 2,
                "0111" when 3;
                
    with in_ports select
        cat <= "00000011" when "0000",
                "10011111" when "0001",
                "00100101" when "0010",
                "00001101" when "0011", 
                "10011001" when "0100",
                "01001001" when "0101",
                "01000001" when "0110",
                "00011111" when "0111",
                "00000001" when "1000",
                "00011001" when "1001",
                "00000101" when "1010",
                "11000001" when "1011",
                "11100101" when "1100",
                "10000101" when "1101",
                "01100001" when "1110",
                "11111111" when "1111",
                "11111111" when others;
                               
end Behavioral;
