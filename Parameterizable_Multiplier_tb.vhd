
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Parameterizable_Multiplier_tb is
--  Port ( );
end Parameterizable_Multiplier_tb;

architecture Behavioral of Parameterizable_Multiplier_tb is
component Parameterizable_Multiplier is
Generic (data_width_mul:integer:=4); --I used "data_width_rca" because I want to use another "data_width" in the multiplier section
   Port (  A_mul : in STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
           B_mul : in STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
           Product : out STD_LOGIC_VECTOR ((2*data_width_mul)-1 downto 0));
end component;
signal data_width_mul : integer:=4;  
signal A_mul_tb : STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
signal B_mul_tb : STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
signal Product_tb : STD_LOGIC_VECTOR ((2*data_width_mul)-1 downto 0);

type my_testings is record
A : STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
B : STD_LOGIC_VECTOR (data_width_mul-1 downto 0);
Product : STD_LOGIC_VECTOR ((2*data_width_mul)-1 downto 0);
end record;

type my_testings_val is array (natural range <>)  of my_testings;
constant my_test_data: my_testings_val:=(
             ("0000","0000","00000000"),--0 x 0 = 0
             ("0001","0001","00000001"),--1 x 1 = 1
             ("0010","0010","00000100"),--2 x 2 = 2
             ("0011","0011","00001001"),--3 x 3 = 9
             ("0100","0100","00010000"),--4 x 4 = 16
             ("0000","0101","00000000"),--0 x 5 = 0
             ("0001","0110","00000110"),--1 x 6 = 6
             ("0010","0111","00001110"),--2 x 7 = 14
             ("0011","1000","00011000"),--3 x 8 = 24
             ("0100","1001","00100100"),--4 x 9 = 36
             ("0000","1010","00000000"),--0 x 10(or a) = 0
             ("0001","1011","00001011"),--1 x 11(or b) = 11
             ("0010","1100","00011000"),--2 x 12(or c) = 24
             ("0011","1101","00100111"),--3 x 13(or d) = 39
             ("0100","1110","00111000"),--4 x 14(or e) = 56
             ("0000","1111","00000000") --0 x 15(or f) = 0
             );

begin
uut: Parameterizable_Multiplier port map(
A_mul=>A_mul_tb,
B_mul=>B_mul_tb,
Product=>Product_tb);

process
begin
for k in my_test_data'range loop
    A_mul_tb<=my_test_data(k).A;
    B_mul_tb<=my_test_data(k).B;
    wait for 10 ns;
    assert(Product_tb<=my_test_data(k).Product)
    report "my_testings"&integer'image(k)&"failed"
    severity error;
end loop;
wait;    
end process;
    
end Behavioral;
