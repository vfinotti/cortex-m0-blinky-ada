-------------------------------------------------------------------------------
--  Title       :  Blinky example status file
--
--  File        : main.ads
--  Author      : Vitor Finotti
--  Created on  : 2019-04-25 14:53:55
--  Description :
--
--     
--
-------------------------------------------------------------------------------

package Main is
   
   procedure Run;
   pragma Export (C, Run, "main");
   
end Main;

