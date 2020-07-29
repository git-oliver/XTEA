library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decrypt_v0 is
    
  generic (N : integer := 32);
-- http://freerangefactory.org/pdf/df344hdh4h8kjfh3500ft2/free_range_vhdl.pdf
-- S. 139
  Port ( 
        clk         : in std_logic;
        
        --debug
        staffel_start   : in std_logic;
        staffel_ende    : out std_logic;
        --debug ende
        
        v0          : in std_logic_vector(N-1 downto 0);
        v1          : in std_logic_vector(N-1 downto 0);
        y_v0        : out std_logic_vector(N-1 downto 0);
        y_v1        : out std_logic_vector(N-1 downto 0);
         
        sum         : in std_logic_vector(N-1 downto 0);
        delta       : in std_logic_vector(N-1 downto 0);
        y_sum       : out std_logic_vector(N-1 downto 0);
           
        k0          : in std_logic_vector(N-1 downto 0);
        k1          : in std_logic_vector(N-1 downto 0);
        k2          : in std_logic_vector(N-1 downto 0);
        k3          : in std_logic_vector(N-1 downto 0)
  );
end decrypt_v0;

architecture Behavioral of decrypt_v0 is

    signal sig_in_v0        : std_logic_vector(N-1 downto 0);
    signal sig_in_v1        : std_logic_vector(N-1 downto 0);
    signal sig_out_y_v0     : std_logic_vector(N-1 downto 0);
    signal sig_out_y_v1     : std_logic_vector(N-1 downto 0);

    signal sig_in_sum       : std_logic_vector(N-1 downto 0);
    signal sig_in_delta     : std_logic_vector(N-1 downto 0);
    signal sig_out_y_sum    : std_logic_vector(N-1 downto 0);
    
    signal sig_in_k0        : std_logic_vector(N-1 downto 0);
    signal sig_in_k1        : std_logic_vector(N-1 downto 0);
    signal sig_in_k2        : std_logic_vector(N-1 downto 0);
    signal sig_in_k3        : std_logic_vector(N-1 downto 0);
    
    signal sig_staffel_first        : std_logic;
    signal sig_staffel_p1_calcv1    : std_logic;
    signal sig_staffel_p2_calcsum   : std_logic;
    signal sig_staffel_p3_calcv0    : std_logic;
    
begin
    sig_in_v0           <= v0;
    sig_in_v1           <= v1;
    y_v0                <= sig_out_y_v0;
    y_v1                <= sig_out_y_v1;

    sig_in_sum          <= sum;
    sig_in_delta        <= delta;
    y_sum               <= sig_out_y_sum;
    
    sig_in_k0           <= k0;
    sig_in_k1           <= k1;
    sig_in_k2           <= k2;
    sig_in_k3           <= k3;
    
    --debug
    sig_staffel_first   <= staffel_start;
    staffel_ende        <= sig_staffel_p3_calcv0;
    --debug end
   
    
    
    calc_v1 :   process (   sig_in_v0, 
                            sig_in_v1, 
                            sig_in_sum,
                            clk,
                            sig_staffel_first
                         )
                    
                    variable v1,v0,sum,res,a,b,c    : std_logic_vector(N-1 downto 0);
                begin
                    if(rising_edge(clk))
                    then
                        if(sig_staffel_first = '1')
                        then

                            v0 := sig_in_v0;
                            v1 := sig_in_v1;
                            sum := sig_in_sum;
    
--                            c := v0(3 downto 0) & "0000";
                            c := v0(N-1-4 downto 0) & "0000"; -- << 4
                                                        
--                            a := "00000" & v0(7 downto 5);
                            a := "00000" & v0(N-1 downto 5); -- >> 5
                            
                            a := a xor c;
                            a := std_logic_vector(unsigned(a) + unsigned(v0));
                            
                            b := "00000000000" & sum(N-1 downto 11); -- sum >> 11

                            b := b and x"0000_0003"; -- sum & 3

                            if(b(1 downto 0) = "00")
                            then
                                b := k0;
                            elsif (b(1 downto 0) = "01")
                            then 
                                b := k1;
                            elsif (b(1 downto 0) = "10")
                            then
                                b := k2;
                            else -- 11
                                b := k3;
                            end if;
                            
                            b := std_logic_vector(unsigned(b) + unsigned(sum));

                            res := a xor b;

                            res := std_logic_vector(unsigned(v1) - unsigned(res));

                            sig_out_y_v1 <= res;
                            sig_staffel_p1_calcv1 <= '1';
                        end if;
                    end if;
                end process;
                
    calc_sum_delta : process (  sig_in_sum,
                                sig_in_delta,
                                clk,
                                sig_staffel_p1_calcv1
                              )
                     begin
                         if (rising_edge(clk))
                         then
                            if(sig_staffel_p1_calcv1 = '1')
                            then     
                                sig_out_y_sum           <= std_logic_vector(unsigned(sig_in_sum) - unsigned(sig_in_delta));
                                sig_staffel_p2_calcsum  <= '1';
                            end if;
                         end if;
                     end process;
                     
    calc_v0 :   process (   sig_in_v0, 
                            sig_out_y_v1, 
                            sig_out_y_sum,
                            clk,
                            sig_staffel_p2_calcsum
                         )
                    
                    variable v1,v0,sum,res,a,b,c  : std_logic_vector(N-1 downto 0);
                begin
                    if(rising_edge(clk))
                    then
                        if(sig_staffel_p2_calcsum = '1')
                        then           
                            v0 := sig_in_v0;
                            v1 := sig_out_y_v1;
                            sum := sig_out_y_sum;

--                            c := sig_in_v1(3 downto 0) & "0000";
                            c := sig_out_y_v1(N-1-4 downto 0) & "0000"; -- << 4
                            
--                            a := "00000" & v1(7 downto 5);
                            a := "00000" & v1(N-1 downto 5); -- >> 5
                            a := a xor c;
                            a := std_logic_vector(unsigned(a) + unsigned(v1));
                            
--                            b := sum and "00000011"; -- sum & 3
                            b := sum and x"0000_0003"; -- sum & 3
                                                        
                            if(b(1 downto 0) = "00")
                            then
                                b := k0;
                            elsif (b(1 downto 0) = "01")
                            then 
                                b := k1;
                            elsif (b(1 downto 0) = "10")
                            then
                                b := k2;
                            else -- 11
                                b := k3;
                            end if;
                            
                            b := std_logic_vector(unsigned(b) + unsigned(sum));
                            
                            res := a xor b;
                            res := std_logic_vector(unsigned(v0) - unsigned(res)); 
                            
                            sig_out_y_v0            <= res;                       
                            sig_staffel_p3_calcv0   <= '1';
                        end if;
                    end if;
                end process;                     
                     
                     
                     
                    
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity reg_vector is 
    generic (N : integer := 32);

    PORT(
        clk     : in std_logic;
        reg_in  : in std_logic_vector(N-1 downto 0);
        reg_out : out std_logic_vector(N-1 downto 0)
    );
end reg_vector;

architecture behaviour of reg_vector is
begin    
    reg : process(  clk,
                    reg_in
                  )
            begin
                if (rising_edge(clk))
                then
                    reg_out <= reg_in;                
                end if;
            end process;
end architecture;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity reg_bit is 
    PORT(
        clk     : in std_logic;
        reg_in  : in std_logic;
        reg_out : out std_logic
    );
end reg_bit;

architecture behaviour of reg_bit is
begin    
    reg : process(  clk,
                    reg_in
                  )
            begin
                if (rising_edge(clk))
                then
                    reg_out <= reg_in;                
                end if;
            end process;
end architecture;    
    
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity block_decrypt_reg is
    generic (   N : integer := 32;
                LOOPS : integer := 63
            );

    PORT(
        clk                 : in std_logic;       
         
        staffel_start       : in std_logic;
        master_staffel_ende : out std_logic;
        
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
end block_decrypt_reg;
architecture behaviour of block_decrypt_reg is
    
    component decrypt_v0
        port(
            clk         : in std_logic;
             
            staffel_start    : in std_logic;
            staffel_ende     : out std_logic;

            v0          : in std_logic_vector(N-1 downto 0);
            v1          : in std_logic_vector(N-1 downto 0);
            y_v0        : out std_logic_vector(N-1 downto 0);
            y_v1        : out std_logic_vector(N-1 downto 0);
             
            sum         : in std_logic_vector(N-1 downto 0);
            delta       : in std_logic_vector(N-1 downto 0);
            y_sum       : out std_logic_vector(N-1 downto 0);
               
            k0          : in std_logic_vector(N-1 downto 0);
            k1          : in std_logic_vector(N-1 downto 0);
            k2          : in std_logic_vector(N-1 downto 0);
            k3          : in std_logic_vector(N-1 downto 0)
        );
    end component;
    
    component reg_vector
        port(
            clk     : in std_logic;
            reg_in  : in std_logic_vector(N-1 downto 0);
            reg_out : out std_logic_vector(N-1 downto 0)    
        );
    end component;
    
    component reg_bit
    port(
        clk     : in std_logic;
        reg_in  : in std_logic;
        reg_out : out std_logic    
    );
    end component;
    --unroll loop
    -- inputs
    type vector     is array (0 to LOOPS) of std_logic_vector(N-1 downto 0);
    type singlebit  is array (0 to LOOPS) of std_logic;
    signal sig_staffel_start    : singlebit;
    signal sig_v0               : vector;
    signal sig_v1               : vector;
    signal sig_sum              : vector;
    
    signal sig_zwischen_v0      : vector;
    signal sig_zwischen_v1      : vector;
    signal sig_zwischen_sum     : vector;
    signal sig_zwischen_staffel : singlebit;
    --unroll loop
    
    begin
    
    multiple_blocks : for i in 0 to LOOPS generate
        first : if (i=0) generate
        
            decrypt             : decrypt_v0 port map(  clk             => clk,
                                                        staffel_start   => '1',
                                                        v0              => v0,--x"12_34_56_78",
                                                        v1              => v1,--x"9A_BC_DE_F0",
                                                        sum             => sum,--x"00_00_00_00",
                                                        delta           => delta,
                                                        k0              => k0,
                                                        k1              => k1,
                                                        k2              => k2,
                                                        k3              => k3,
                                                        
                                                        y_v0            => sig_zwischen_v0(i),
                                                        y_v1            => sig_zwischen_v1(i),
                                                        y_sum           => sig_zwischen_sum(i),
                                                        staffel_ende    => sig_zwischen_staffel(i)
                                                        );
            reg_v0              : reg_vector port map(  clk         => clk,
                                                        reg_in      => sig_zwischen_v0(i),
                                                        reg_out     => sig_v0(i)
                                                        );
            reg_v1              : reg_vector port map(  clk         => clk,
                                                        reg_in      => sig_zwischen_v1(i),
                                                        reg_out     => sig_v1(i)
                                                        );
            reg_sum             : reg_vector port map(  clk         => clk,
                                                        reg_in      => sig_zwischen_sum(i),
                                                        reg_out     => sig_sum(i)
                                                        );
            reg_staffel_ende    : reg_bit    port map(  clk         => clk,
                                                        reg_in      => sig_zwischen_staffel(i),
                                                        reg_out     => sig_staffel_start(i)
                                                        );
        end generate first;
     
        middle : if (i>0) generate
            decrypt             : decrypt_v0 port map(  clk             => clk,
                                                        staffel_start   => sig_staffel_start(i-1),
                                                        v0              => sig_v0(i-1),
                                                        v1              => sig_v1(i-1),
                                                        sum             => sig_sum(i-1),
                                                        delta           => delta,
                                                        k0              => k0,
                                                        k1              => k1,
                                                        k2              => k2,
                                                        k3              => k3,
                                                        
                                                        y_v0            => sig_zwischen_v0(i),
                                                        y_v1            => sig_zwischen_v1(i),
                                                        y_sum           => sig_zwischen_sum(i),
                                                        staffel_ende    => sig_zwischen_staffel(i)
                                                        );
            reg_v0              : reg_vector port map(  clk         => clk,
                                                        reg_in      => sig_zwischen_v0(i),
                                                        reg_out     => sig_v0(i)
                                                        );
            reg_v1              : reg_vector port map(  clk         => clk,
                                                        reg_in      => sig_zwischen_v1(i),
                                                        reg_out     => sig_v1(i)
                                                        );
            reg_sum             : reg_vector port map(  clk         => clk,
                                                        reg_in      => sig_zwischen_sum(i),
                                                        reg_out     => sig_sum(i)
                                                        );
            reg_staffel_ende    : reg_bit    port map(  clk         => clk,
                                                        reg_in      => sig_zwischen_staffel(i),
                                                        reg_out     => sig_staffel_start(i)
                                                        );
        end generate middle;
        
        
        -- Den letzten Block dem Ausgang zuweisen
        master_y_v0 	<= sig_v0(LOOPS);
        master_y_v1 	<= sig_v1(LOOPS);
        master_staffel_ende <= sig_staffel_start(LOOPS);
        master_y_sum	<= sig_sum(LOOPS);

    end generate multiple_blocks;
end behaviour;
  