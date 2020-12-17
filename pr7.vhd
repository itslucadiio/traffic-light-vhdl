library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pr7 is
    Port (
        polsador : in std_logic;
        clk, reset : in STD_LOGIC;
        cat : out STD_LOGIC_VECTOR (7 downto 0);
        an : out STD_LOGIC_VECTOR (3 downto 0);
        LED : out STD_LOGIC_VECTOR (15 downto 0)
    );
end pr7;

architecture Behavioral of pr7 is

    component clk_divider
        generic(eoc: integer := 1000000);
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_div : out STD_LOGIC);
    end component;  
    component counter
        generic(num : std_logic_vector (4 downto 0));
        Port ( rst_en : in std_logic;
               enable : in STD_LOGIC;
               clk_div, reset : in STD_LOGIC;
               c : out STD_LOGIC_VECTOR (4 downto 0));
    end component;
    component seg7_coder
    Port ( char0 : in STD_LOGIC_VECTOR (3 downto 0);
           char1 : in STD_LOGIC_VECTOR (3 downto 0);
           char2 : in STD_LOGIC_VECTOR (3 downto 0);
           char3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_div : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    component bin2bcd
    generic(n: positive := 16);
    Port ( bin_in : in STD_LOGIC_VECTOR (n-1 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           bcd0 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd1 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd2 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd3 : out STD_LOGIC_VECTOR (3 downto 0);
           bcd4 : out STD_LOGIC_VECTOR (3 downto 0));
    end component;  
    
    type state is (no_walk, wal_req, all_stop_1, walk, end_walk, all_stop_2);
    signal state_reg, state_next : state;
    signal c, c_b : std_logic_vector (4 downto 0);
    signal c0, c1 : std_logic_vector (3 downto 0);
    signal enable, enable_b : std_logic;
    signal disp0, disp1, char0, char1 : std_logic_vector (3 downto 0);
    signal rst_en : std_logic;
    signal clk_div_1s : std_logic;
    signal clk_div: std_logic;
    signal clk_div_blink : std_logic;
    signal blink : std_logic;
    alias L0 : STD_LOGIC is LED(15);
    alias L1 : STD_LOGIC is LED(14);
    alias L2 : STD_LOGIC is LED(13);
    alias L3 : STD_LOGIC is LED(12);
    alias L4 : STD_LOGIC is LED(11);
    
begin

-- CLKDIV
u1: clk_divider
    generic map (eoc => 100000000)
    port map (clk => clk,
                reset => reset,
                clk_div => clk_div_1s);
-- END CLKDIV


-- CONTADORS
u2: counter
    generic map(num => "11001") 
    port map (rst_en => rst_en,
              enable => enable,
              clk_div => clk_div_1s,
              reset => reset, 
              c => c);
u7: counter
    generic map(num => "01111")
    port map (rst_en => rst_en,
              enable => enable_b,
              clk_div => clk_div_1s,
              reset => reset, 
              c => c_b);
-- END CONTADORS


-- FSM
status_decoder: process(clk, reset) begin
if rising_edge(clk) then
    if reset='1' then state_reg <= no_walk;
    else state_reg <= state_next;
    end if;
end if;
end process;

output_decoder: process(state_reg) begin
case state_reg is
    when no_walk =>
        L0 <= '1';
        L1 <= '0';
        L2 <= '0';
        L3 <= '0';
        L4 <= '1';
        enable <= '0';
        enable_b <= '0';
        rst_en <= '1';
    when wal_req => 
        L0 <= '1';
        L1 <= '0';
        L2 <= '0';
        L3 <= '1';
        L4 <= '0';
        enable <= '1';
        enable_b <= '0';
        rst_en <= '0';
    when all_stop_1 =>
        L0 <= '1';
        L1 <= '0';
        L2 <= '1';
        L3 <= '0';
        L4 <= '0';
        enable <= '1';
        enable_b <= '0';
        rst_en <= '0';
    when walk =>
        L0 <= '0';
        L1 <= '1';
        L2 <= '1';
        L3 <= '0';
        L4 <= '0';
        enable <= '1';
        enable_b <= '1';
        rst_en <= '0';
    when end_walk =>
        L0 <= '0';
        L1 <= blink;
        L2 <= '1';
        L3 <= '0';
        L4 <= '0';
        enable <= '1';
        enable_b <= '1';
        rst_en <= '0';
    when all_stop_2 =>
        L0 <= '1';
        L1 <= '0';
        L2 <= '1';
        L3 <= '0';
        L4 <= '0';
        enable <= '1';
        enable_b <= '0';
        rst_en <= '0';
end case;
end process;

status_register: process(state_reg, polsador, c0, c1) begin
state_next <= state_reg;
case state_reg is
    when no_walk =>
        if polsador='1' then state_next <= wal_req;
        else state_next <= no_walk;
        end if;
    when wal_req => 
        if c0="0001" and c1="0010" then state_next <= all_stop_1;
        else state_next <= wal_req;
        end if;
    when all_stop_1 =>
        if c0="1000" and c1="0001" then state_next <= walk;
        else state_next <= all_stop_1;
        end if;
    when walk =>
        if c0="1000" and c1="0000" then state_next <= end_walk;
        else state_next <= walk;
        end if;
    when end_walk =>
        if c0="0011" and c1="0000" then state_next <= all_stop_2;
        else state_next <= end_walk;
        end if;
    when all_stop_2 =>
        if c0="0000" and c1="0000" then state_next <= no_walk;
        else state_next <= all_stop_2;
        end if;
end case;
end process;
-- END FSM


-- BLINK
u6: clk_divider
    generic map (eoc => 10000000)
    port map (clk => clk,
              reset => reset,
              clk_div => clk_div_blink);

process(clk_div_blink) begin
if rising_edge(clk_div_blink) then blink <= NOT blink;
end if;
end process;
-- END


u5: bin2bcd
    generic map (n => 5)
    port map (bin_in => c,
                clk => clk,
                reset => reset,
                bcd0 => c0,
                bcd1 => c1,
                bcd2 => open,
                bcd3 => open,
                bcd4 => open);
                
u8: bin2bcd
    generic map (n => 5)
    port map (bin_in => c_b,
                clk => clk,
                reset => reset,
                bcd0 => disp0,
                bcd1 => disp1,
                bcd2 => open,
                bcd3 => open,
                bcd4 => open);
                
-- DISPLAY
u3: clk_divider
    generic map (eoc => 100000)
    port map (clk => clk,
              reset => reset,
              clk_div => clk_div);
              
char0 <= disp0 when state_reg=walk else 
         disp0 when state_reg=end_walk and blink='0' else
         "1111";
char1 <= disp1 when state_reg=walk else 
         disp1 when state_reg=end_walk and blink='0' else
         "1111";
        
u4: seg7_coder
    port map (char0 => char0,
                char1 => char1,
                char2 => "1111",
                char3 => "1111",
                clk => clk,
                reset => reset,
                clk_div => clk_div,
                cat => cat,
                an => an);
-- END DISPLAY  

end Behavioral;
