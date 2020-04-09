
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity full_adder_seq_behav is
    Port (clk 	  : in STD_LOGIC;
          rst     : in STD_LOGIC;
          inputA  : in STD_LOGIC;
          inputB  : in STD_LOGIC;
          Cin     : in STD_LOGIC;
          Cout    : out STD_LOGIC;
          outputS : out STD_LOGIC);
end full_adder_seq_behav;

architecture FA_behavioral of full_adder_seq_behav is

    signal sum : STD_LOGIC_VECTOR(1 downto 0);
    signal vect1 : STD_LOGIC_VECTOR(0 downto 0);
    signal vect2 : STD_LOGIC_VECTOR(0 downto 0);
    signal vect3 : STD_LOGIC_VECTOR(0 downto 0);
    signal inA   : STD_LOGIC;
    signal inB   : STD_LOGIC;
    signal inC   : STD_LOGIC;

begin
    process(clk)
    begin
        if clk'event and clk='1' then
            if rst ='1' then
                inA <= '0';
                inB <= '0';
                inC <= '0';
                --outputS <= '0';
                --Cout <= '0';
            else
                inA <= inputA;
                inB <= inputB;
                inC <= Cin;
                --outputS <= sum(0);
                --Cout <= sum(1);
            end if;
        end if;
        vect1 <= (0 => inA);
        vect2 <= (0 => inB);
        vect3 <= (0 => inC);
        sum <= ('0' & vect1) + ('0'& vect2) + ('0' & vect3);
        outputS <= sum(0);
        Cout <= sum(1);
    end process;
end FA_behavioral;
