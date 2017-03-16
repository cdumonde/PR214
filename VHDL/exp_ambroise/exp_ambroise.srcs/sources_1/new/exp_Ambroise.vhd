library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity exp_Ambroise is
  generic(bit_entiere : integer range 1 to 30 := 15;
          I_init      : integer range 1 to 12 := 1);
          
    Port ( enable  : in  STD_LOGIC;
           reset   : in  STD_LOGIC;
           H       : in  STD_LOGIC;
           I_syn_1 : out STD_LOGIC);
end exp_Ambroise;

architecture Behavioral of exp_Ambroise is

signal I_syn1          : integer range 0 to 131071 :=0;
signal I_syn           : integer range 0 to 131071 :=0;


begin
    process(H)
begin
    if (H'event and H='1') then
        if(reset='1') then
            I_syn1 <= 0;
        elsif (enable='1') then
            x_1 <= x;
            x   <= to_integer(unsigned(entree_x));
        end if;
    end if;
end process;
I_syn1         <= I_syn - I_syn_tau;
sortie_pb     <= std_logic_vector(to_unsigned(x_y,16));

end Behavioral;
