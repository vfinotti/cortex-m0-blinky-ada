-------------------------------------------------------------------------------
--  Title       : Blinky example for Cortex-M0
--
--  File        : main.adb
--  Author      : Vitor Finotti
--  Created on  : 2019-04-24 19:46:32
--  Description :
--
--     
--
-------------------------------------------------------------------------------

pragma Restrictions (No_Exceptions); -- avoid __gnat_last_chance_handler being used


package body Main is
   
   procedure Run is
      --  Period : constant Integer := 1000000; -- Synthesis period
      Period : constant Integer := 200; -- Simulation period
      
      type Period_Range is range 0 .. Period;
      type Uint32 is mod 2**32;
      Led_Toggle :  constant := 16#f0f0f0f0#;
      Counter : Integer := 0;
      Dummy : Uint32 := 0;
   begin
      loop
         Counter := 0;
         
         for I in Period_Range loop
            Counter := Counter + 1;
         end loop;
         Dummy := Led_Toggle;
         Dummy := Dummy + 1; -- force toggle parameter to change
      end loop;
      
   end Run;

end Main;
