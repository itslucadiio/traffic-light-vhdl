----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2020 18:22:30
-- Design Name: 
-- Module Name: bin2bcd - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin2bcd is
    generic(n: positive := 16);
    Port ( bin_in : in STD_LOGIC_VECTOR (n-1 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           bcd0 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd1 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd2 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd3 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd4 : out STD_LOGIC_VECTOR (3 downto 0));
end bin2bcd;

architecture Behavioral of bin2bcd is

begin

    process (bin_in)
    variable temp : std_logic_vector (n-1 downto 0);
    variable bcd : UNSIGNED (n+3 downto 0) := (others => '0');
    begin
        bcd := (others => '0');
        temp(n-1 downto 0) := bin_in(n-1 downto 0);
        
        for i in 0 to n-1 loop
            if bcd(3 downto 0) > 4 then
                bcd(3 downto 0) := bcd(3 downto 0) + 3;
            end if;
            if bcd(7 downto 4) > 4 then
                bcd(7 downto 4) := bcd(7 downto 4) + 3;
            end if;
--            if bcd(11 downto 8) > 4 then
--                bcd(11 downto 8) := bcd(11 downto 8) + 3;
--            end if;
--            if bcd(15 downto 12) > 4 then
--                    bcd(15 downto 12) := bcd(15 downto 12) + 3;
--            end if;
            bcd := bcd(n+2 downto 0) & temp(n-1);
            temp := temp(n-2 downto 0) & '0';
        end loop;
        
        bcd0 <= std_logic_vector(bcd(3 downto 0));
        bcd1 <= std_logic_vector(bcd(7 downto 4));
        if bin_in'length > 5 then
             bcd2 <= std_logic_vector(bcd(11 downto 8));
        end if;
        if bin_in'length > 9 then
             bcd3 <= std_logic_vector(bcd(15 downto 12));
        end if;
        if bin_in'length > 13 then
            bcd4 <= std_logic_vector(bcd(19 downto 16));
        end if;
        
    end process;


end Behavioral;
