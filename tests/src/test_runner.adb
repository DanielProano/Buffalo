with Ada.Text_IO;
with Ada.Command_Line;

use Ada.Text_IO;
use Ada.Command_Line;

procedure Test_Runner is
    -- Natural means integer >= 0
    Failures : Natural := 0;

    procedure Check (Condition : Boolean; Description : String) is
    begin
        if Condition then 
            Put_Line ("[PASS] " & Description);
        else 
            Put_Line ("[Fail] " & Description);
            Failures := Failures + 1;
        end if;
    end Check;

begin
    Put_Line ("Running Buffalo tests...");
    Check (1 + 1 = 2, "sanity check");

    New_Line;
    if Failures = 0 then 
        Put_Line ("All tests passed");
    else 
        -- Ada uses 'Image as a str()
        Put_Line (Failures'Image & " tests failed.");
        Set_Exit_Status(Failure);
    end if;
end Test_Runner;