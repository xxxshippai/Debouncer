library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( clock    : in STD_LOGIC;
           reset    : in STD_LOGIC;
           switch   : in STD_LOGIC;
           led      : out STD_LOGIC);
end main;

architecture Behavioral of main is

signal Count        : integer;
signal DelayFlag    : std_logic;
signal FlagShort    : std_logic;
signal FlagLong     : std_logic;

-- Stany obliczeniowe
type States is (Waiting, Delay, LEDon);
-- Sygna³y stanów
signal State, StateNext : States; 
signal StartValue : std_logic;
signal CounterRegister : integer;
begin

    -- Proces dyktuj¹cy progresje funkcji oraz resetowanie automatu
    Reg:process(clock,reset)
    begin
        if(reset = '1') then
    
            State <= Waiting;
        elsif(clock'event and clock = '1' and DelayFlag = '0') then
            State <= StateNext;
        end if;
    end process Reg;
    
    	-- Delkaracja procesów w ka¿dym z stanów
	StateCheck:process(State)
	begin
	
		StateNext<=State;
		case State is
		  -- Stan wyczekiwania na input
		  when Waiting =>
		      led <= '0';
		      StartValue <= '0';
		      if(switch = '0') then
                StateNext <= Waiting;
              elsif(switch ='1') then
                StateNext <= Delay;
              end if;
          -- Koniec stanu Waiting
                
		  
		  -- Stan opóŸnienia zapobiegaj¹cego drganiom 
		  when Delay =>
		      StartValue <= switch;
		      FlagShort <= '1';
		      
		      if(StartValue = switch) then
		          StateNext <= LEDon;
              else
                  StateNext <= Waiting;
              end if;
          -- Koniec stanu Delay
          
		  -- Stan w³¹czaj¹cy LED
		  when LEDon =>
		      led <= '1';
		      FlagLong <= '1';
		      StateNext <= Waiting;
		      
		end case;
	end process StateCheck;
    
    Counter:process(clock)
    begin
        DelayFlag <= '1';
        if (clock'event and clock = '1') then				
			if FlagShort = '1' then
			    if(CounterRegister < 2000000) then									
				    CounterRegister <= CounterRegister + 1;
                elsif(CounterRegister = 2000000) then
                    FlagShort <= '0';
                    DelayFlag <= '0';
                end if;
			elsif FlagLong = '1' then
			    if(CounterRegister < 100000000) then									
				    CounterRegister <= CounterRegister + 1;
                elsif(CounterRegister = 100000000) then
                    FlagLong <= '0';
                    DelayFlag <= '0';
                end if;
			end if;												
		end if;
    end process Counter;
    
end Behavioral;