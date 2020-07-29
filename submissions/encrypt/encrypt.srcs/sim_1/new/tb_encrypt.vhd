----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.05.2020 20:38:38
-- Design Name: 
-- Module Name: tb_encrypt - Behavioral
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

entity tb_encrypt is
--  Port ( );      
    generic (N : integer := 32);
end tb_encrypt;

architecture Behavioral of tb_encrypt is
    
    -- Moduldeklaration
  component block_encrypt_reg is
    port (
        clk                 : in std_logic;
        
          --debug
        staffel_start       : in std_logic;
        master_staffel_ende : out std_logic;
        --debug ende
        
        v0                  : in std_logic_vector(N-1 downto 0);
        v1                  : in std_logic_vector(N-1 downto 0);
        master_y_v0         : out std_logic_vector(N-1 downto 0);
        master_y_v1         : out std_logic_vector(N-1 downto 0);
         
        sum                 : in std_logic_vector(N-1 downto 0);
        delta               : in std_logic_vector(N-1 downto 0);
        master_y_sum        : out std_logic_vector(N-1 downto 0);
           
        k0                  : in std_logic_vector(N-1 downto 0);
        k1                  : in std_logic_vector(N-1 downto 0);
        k2                  : in std_logic_vector(N-1 downto 0);
        k3                  : in std_logic_vector(N-1 downto 0)
    );
  end component;

    signal clk                  : std_logic := '0';
    
     --debug
    signal staffel_start        : std_logic;
    signal master_staffel_ende  : std_logic;
    --debug end
    
    signal v0                   : std_logic_vector(N-1 downto 0);
    signal v1                   : std_logic_vector(N-1 downto 0);
    signal master_y_v0          : std_logic_vector(N-1 downto 0);
    signal master_y_v1          : std_logic_vector(N-1 downto 0);
     
    signal sum                  : std_logic_vector(N-1 downto 0);
    signal delta                : std_logic_vector(N-1 downto 0);
    signal master_y_sum         : std_logic_vector(N-1 downto 0);
       
    signal k0                   : std_logic_vector(N-1 downto 0);
    signal k1                   : std_logic_vector(N-1 downto 0);
    signal k2                   : std_logic_vector(N-1 downto 0);
    signal k3                   : std_logic_vector(N-1 downto 0);
        
begin
    -- Modulinstatziierung
    dut : block_encrypt_reg
    port map (
    
        clk                 => clk,
        staffel_start       => staffel_start,
        master_staffel_ende => master_staffel_ende,
        v0                  => v0,
        v1                  => v1,
        master_y_v0         => master_y_v0,
        master_y_v1         => master_y_v1,
        sum                 => sum,
        delta               => delta,
        master_y_sum        => master_y_sum,
        k0                  => k0,
        k1                  => k1,
        k2                  => k2,
        k3                  => k3
    );
    
   clk <= not clk after 10 ns; 
   
    tb : process
    begin 
        
        -- Fehlerfall Output muss Null oder uninitialized value
        --clk             <= '0';
        staffel_start   <= '0';
        v0              <= (others => '0');
        v1              <= (others => '0');
        sum             <= (others => '0');
        delta           <= (others => '0');
        k0              <= x"00_00_00_01";
        k1              <= x"00_00_00_01";
        k2              <= x"00_00_00_01";
        k3              <= x"00_00_00_01";
        
        wait for 10 ns;
        
        -- Korrektes Ergebnis muss rausfallen
        staffel_start   <= '1';
        --clk             <= '1';
        v0              <= x"F3_7A_3A_42";
        v1              <= x"DE_AD_BE_EF";
        sum             <= (others => '0');
        delta           <= x"12_34_56_78";
        
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
--        wait for 10 ns;
--        clk <= '0';
--        wait for 10 ns;
--        clk <= '1';
        
        
        wait for 1000000000ns;       
    end process;

end Behavioral;








