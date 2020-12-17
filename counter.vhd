library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity counter is
    generic(num : std_logic_vector (4 downto 0));
    Port (
        rst_en : in std_logic;
        enable : in std_logic;
        clk_div, reset : in STD_LOGIC; 
        c: out std_logic_vector (4 downto 0));
end counter;

architecture Behavioral of counter is
begin

down_counter: process(clk_div, reset)
variable cnt : std_logic_vector (4 downto 0) := num;
begin
if reset='1' or rst_en='1' then cnt := num;
elsif rising_edge(clk_div) then
    if enable='1' then
        if cnt="00000" then cnt := num;
        else cnt :=  std_logic_vector(to_unsigned(to_integer(unsigned(cnt)) -1, 5));
        end if;
    end if;
end if;
c <= cnt;
end process;




end Behavioral;
