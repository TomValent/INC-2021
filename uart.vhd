-- uart.vhd: UART controller - receiving part
-- Author(s): Tom�s Valent (xvalen27)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK: 	    in std_logic;
	RST: 	    in std_logic;
	DIN: 	    in std_logic;
	DOUT: 	    out std_logic_vector(7 downto 0);
	DOUT_VLD : out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
signal cnt        : std_logic_vector(4 downto 0);
signal cnt2       : std_logic_vector(3 downto 0);
signal rx_en      : std_logic;
signal cnt_en     : std_logic;
signal TMP        : std_logic_vector(7 downto 0);
signal dout_valid : std_logic;
begin
  FSM: entity work.UART_FSM(behavioral)
  port map(
    CLK         => clk,
    RST         => rst,
    DIN         => din,
    RX_EN       => rx_en,
    CNT         => cnt,
    CNT2        => cnt2,
    CNT_EN      => cnt_en,
    DOUT_VALID  => dout_valid
  );
  DOUT_VLD <= dout_valid;
  
  process(CLK) begin
    if rising_edge(CLK) then
    if cnt_en = '1' then
        cnt <= cnt + 1;
    else
        cnt <= "00000";
        cnt2 <= "0000";
    end if;
    if rx_en = '1' then
      if cnt = "10000" then   --16 kopcov == 1 bit
          cnt <= "00000";
          case cnt2 is
            when "0000" => TMP(0) <= DIN;
            when "0001" => TMP(1) <= DIN;
            when "0010" => TMP(2) <= DIN;
            when "0011" => TMP(3) <= DIN;
            when "0100" => TMP(4) <= DIN;
            when "0101" => TMP(5) <= DIN;
            when "0110" => TMP(6) <= DIN;
            when "0111" => TMP(7) <= DIN;
            when others => null;
          end case;
          cnt2 <= cnt2 + 1;
      end if;
    end if;
    end if;
  end process;

  DOUT <= TMP;
end behavioral;