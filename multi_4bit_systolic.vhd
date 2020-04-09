-- Unsigned Parallel Carry-Propagate Multiplier
--
-- p <= a * b;
--
library IEEE;
use IEEE.std_logic_1164.all;

entity multiplier is
	generic
	(
		NA : positive := 4;
		NB : positive := 4
		
	);
	
	port
	(
		  clk,rst : in std_logic;
				a : in std_logic_vector(NA-1 downto 0);
				b : in std_logic_vector(NB-1 downto 0);
				p : out std_logic_vector(NA+NB-1 downto 0)

	);
end multiplier;

architecture structural of multiplier is

subtype a_word is std_logic_vector(NA-1 downto 0);
type a_word_array is array(natural range <>) of a_word;
signal ai,ao,bi,bo,si,so,ci,co : a_word_array(NB-1 downto 0);
signal blayer1,blayer2  : std_logic_vector(2 downto 0);
signal blayer3,blayer4  : std_logic_vector(1 downto 0);
signal blayer5,blayer6  : std_logic;
signal alayer1			: std_logic;
signal alayer2			: std_logic_vector(1 downto 0);
signal alayer3			: std_logic_vector(2 downto 0);
signal player1			: std_logic;
signal player2			: std_logic;
signal player3			: std_logic_vector(1 downto 0);
signal player4			: std_logic_vector(1 downto 0);
signal player5			: std_logic_vector(2 downto 0);
signal player6			: std_logic_vector(2 downto 0);
signal player7			: std_logic_vector(3 downto 0);
signal player8			: std_logic_vector(4 downto 0);
signal player9			: std_logic_vector(5 downto 0);

component mul_cell is
	port
		(
			ai : in std_logic;
			bi : in std_logic;
			si : in std_logic;
			ci : in std_logic;
			clk : in std_logic;
			rst : in std_logic;
			ao : out std_logic;
			bo : out std_logic;
			so : out std_logic;
			co : out std_logic
		);
end component;

begin
	-- cell generation
	gcb: for i in 0 to NB-1 generate
		gca: for j in 0 to NA-1 generate
			gc: mul_cell port map
				(
					ai => ai(i)(j),
					bi => bi(i)(j),
					si => si(i)(j),
					ci => ci(i)(j),
					clk => clk,
					rst => rst,
					ao => ao(i)(j),
					bo => bo(i)(j),
					so => so(i)(j),
					co => co(i)(j)
				);
		end generate;
	end generate;

-- intermediate wires generation
gasw: for i in 1 to NB-1 generate
			ai(i) <= ao(i-1);
			si(i) <= co(i-1)(NA-1) & so(i-1)(NA-1 downto 1);
		end generate;
		
		
gbciw: for i in 0 to NB-1 generate
	gbcjw: for j in 1 to NA-1 generate
				bi(i)(j) <= bo(i)(j-1);
				ci(i)(j) <= co(i)(j-1);
			end generate;
		end generate;

-- input connections(input zeros ) 	
gsi: 	si(0) <= (others => '0');		

gci: 	for i in 0 to NB-1 generate
				ci(i)(0) <= '0';
			end generate;

process(clk)
	begin
		if clk'event and clk='1' then 
			if rst='1' then
				blayer1 <= (others => '0');
				blayer2 <= (others => '0');
				blayer3 <= (others => '0');
				blayer4 <= (others => '0');
				blayer5 <= '0';
				blayer6 <= '0';
				
				alayer1 <= '0';
				alayer2 <= (others => '0');
				alayer3 <= (others => '0');
				
				player1 <= '0';
				player2 <= '0';
				player3 <= (others => '0'); 
				player3 <= (others => '0');
				player4 <= (others => '0');
				player5 <= (others => '0');
				player6 <= (others => '0');
				player7 <= (others => '0');
				player8 <= (others => '0');
				player9 <= (others => '0');
				
			else 
				-- additional flipflops at b inputs
				bi(0)(0) <= b(0);
				blayer1 <= (2 => b(2), 1 => b(1), 0 => b(0));
				blayer2 <= blayer1;
				bi(1)(0) <= blayer2(2);
				blayer3 <= (1 => blayer2(1), 0 => blayer2(0));
				blayer4 <= blayer3;
				bi(2)(0) <= blayer4(1);
				blayer5 <= blayer4(0);
				blayer6 <= blayer5;
				bi(3)(0) <= blayer6;
				
				-- additional flipflops at a inputs
				ai(0)(0) <= a(0);
				alayer1 <= a(3);
				alayer2 <= ( 1 => alayer1, 0 => a(2));
				alayer3 <= ( 2 => alayer2(1), 1 => alayer2(0), 0 => a(1));
				ai(0)(3) <= alayer3(2);
				ai(0)(2) <= alayer3(1);
				ai(0)(1) <= alayer3(0);
				
				-- additional flip flops at outputs
				player1 <= so(0)(0);
				player2 <= player1;
				player3(1) <= so(1)(0);
				player3(0) <= player2;
				player4 <= player3;
				player5 <= so(2)(0) & player4;
				player6 <= player5;
				player7 <= so(3)(0) & player6;
				player8 <= so(3)(1) & player7;
				player9 <= so(3)(2) & player8;
				p       <= co(3)(3) & so(3)(3) & player9;
				
			end if;
		end if;
				
				
	end process;
end structural;
