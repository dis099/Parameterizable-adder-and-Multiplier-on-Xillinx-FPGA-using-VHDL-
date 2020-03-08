library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Parameterizable_Multiplier is
Generic (data_width_mul:integer:=4); --I used "data_width_rca" because I want to use another "data_width" in the multiplier section
   Port (  A_mul : in STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
           B_mul : in STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
           Product : out STD_LOGIC_VECTOR ((2*data_width_mul)-1 downto 0));
end Parameterizable_Multiplier;

architecture Behavioral of Parameterizable_Multiplier is
component Ripple_Carry_Adder
Generic (data_width_rca:integer:=data_width_mul); --I used "data_width_rca" because I want to use another "data_width" in the multiplier section
Port (     A : in STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
           B : in STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
           C_in : in STD_LOGIC;
           SUM : out STD_LOGIC_VECTOR (data_width_mul downto 0) );
end component;           

type adder is array (0 to data_width_mul-1) of std_logic_vector(data_width_mul-1 downto 0);
type adder_2 is array (0 to data_width_mul-1) of std_logic_vector(data_width_mul downto 0);
signal addings: adder;
signal myProduct_sigg: adder_2;
constant data_width_rca : integer:=data_width_mul;

begin 
--generating the partial values to be added
ands: for j in 0 to data_width_mul-1 generate
   ands2: for k in 0 to data_width_mul-1 generate
    addings(j)(k) <= B_mul(j) and A_mul(k); 
   end generate; 
end generate;

-- Utilizing the Ripple Carry Adder to perform the multiply function
myProduct_sigg(0)<='0'&addings(0);
multiplication_block: for i in 1 to data_width_mul-1 generate
      n_bits_adder: component Ripple_Carry_Adder port map(
        C_in=>'0',  --completed
        B=>myProduct_sigg(i-1)((data_width_mul) downto 1),
        A=>addings(i), --completed
        SUM=>myProduct_sigg(i)
        );
end generate;

finally:for k in 0 to data_width_mul-2 generate
    Product(k)<=myProduct_sigg(k)(0);
end generate;
    
Product((2*data_width_mul-1) downto data_width_mul-1)<=myProduct_sigg(data_width_mul-1);

end Behavioral;
