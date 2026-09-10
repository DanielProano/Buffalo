with Ada.Text_IO;
with Ada.Command_Line;
with Interfaces;
with Protocol;
with Flash;

use Ada.Text_IO;
use Ada.Command_Line;
use Interfaces;
use Protocol;
use Flash;

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

    --  Cross-checks Protocol.Msg_Id's hand-copied representation clause
    --  against the true values in protocol.h (via protocol_shim.c). Ada
    --  enum representation clauses require static values, so protocol.ads
    --  can't import these live -- this is the only place drift would show
    --  up, so it has to be a runtime check rather than a compile-time one.
    procedure Check_Msg_Id_Matches_C is
        C_Msg_Ack : constant Unsigned_8
          with Import, Convention => C, External_Name => "msg_ack_value";
        C_Msg_Nack : constant Unsigned_8
          with Import, Convention => C, External_Name => "msg_nack_value";
        C_Msg_Bootloader_Cmd : constant Unsigned_8
          with Import, Convention => C, External_Name => "msg_bootloader_cmd_value";
        C_Msg_Bootloader_Data : constant Unsigned_8
          with Import, Convention => C, External_Name => "msg_bootloader_data_value";
        C_Msg_Bootloader_Stats : constant Unsigned_8
          with Import, Convention => C, External_Name => "msg_bootloader_stats_value";
    begin
        Check (Unsigned_8 (Msg_Id'Enum_Rep (Msg_Ack)) = C_Msg_Ack,
               "Msg_Id.Msg_Ack matches protocol.h MSG_ACK");
        Check (Unsigned_8 (Msg_Id'Enum_Rep (Msg_Nack)) = C_Msg_Nack,
               "Msg_Id.Msg_Nack matches protocol.h MSG_NACK");
        Check (Unsigned_8 (Msg_Id'Enum_Rep (Msg_Bootloader_Cmd)) = C_Msg_Bootloader_Cmd,
               "Msg_Id.Msg_Bootloader_Cmd matches protocol.h MSG_BOOTLOADER_CMD");
        Check (Unsigned_8 (Msg_Id'Enum_Rep (Msg_Bootloader_Data)) = C_Msg_Bootloader_Data,
               "Msg_Id.Msg_Bootloader_Data matches protocol.h MSG_BOOTLOADER_DATA");
        Check (Unsigned_8 (Msg_Id'Enum_Rep (Msg_Bootloader_Stats)) = C_Msg_Bootloader_Stats,
               "Msg_Id.Msg_Bootloader_Stats matches protocol.h MSG_BOOTLOADER_STATS");
    end Check_Msg_Id_Matches_C;

    --  Same cross-check as above, for Bootloader_Cmd.
    procedure Check_Bootloader_Cmd_Matches_C is
        C_Bootloader_None : constant Unsigned_8
          with Import, Convention => C, External_Name => "bootloader_none_value";
        C_Bootloader_Stats : constant Unsigned_8
          with Import, Convention => C, External_Name => "bootloader_stats_value";
        C_Bootloader_Erase_App : constant Unsigned_8
          with Import, Convention => C, External_Name => "bootloader_erase_app_value";
        C_Bootloader_Update : constant Unsigned_8
          with Import, Convention => C, External_Name => "bootloader_update_value";
        C_Bootloader_Verify : constant Unsigned_8
          with Import, Convention => C, External_Name => "bootloader_verify_value";
    begin
        Check (Unsigned_8 (Bootloader_Cmd'Enum_Rep (Bootloader_None)) = C_Bootloader_None,
               "Bootloader_Cmd.Bootloader_None matches protocol.h BOOTLOADER_NONE");
        Check (Unsigned_8 (Bootloader_Cmd'Enum_Rep (Bootloader_Stats)) = C_Bootloader_Stats,
               "Bootloader_Cmd.Bootloader_Stats matches protocol.h BOOTLOADER_STATS");
        Check (Unsigned_8 (Bootloader_Cmd'Enum_Rep (Bootloader_Erase_App)) = C_Bootloader_Erase_App,
               "Bootloader_Cmd.Bootloader_Erase_App matches protocol.h BOOTLOADER_ERASE_APP");
        Check (Unsigned_8 (Bootloader_Cmd'Enum_Rep (Bootloader_Update)) = C_Bootloader_Update,
               "Bootloader_Cmd.Bootloader_Update matches protocol.h BOOTLOADER_UPDATE");
        Check (Unsigned_8 (Bootloader_Cmd'Enum_Rep (Bootloader_Verify)) = C_Bootloader_Verify,
               "Bootloader_Cmd.Bootloader_Verify matches protocol.h BOOTLOADER_VERIFY");
    end Check_Bootloader_Cmd_Matches_C;

    --  Same cross-check as above, for Error_Code.
    procedure Check_Error_Code_Matches_C is
        C_Error_None : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_none_value";
        C_Error_Crc_Fail : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_crc_fail_value";
        C_Error_Unknown_Msg : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_unknown_msg_value";
        C_Error_Wrong_Version : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_wrong_version_value";
        C_Error_Payload_Oversize : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_payload_oversize_value";
        C_Error_Invalid_State : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_invalid_state_value";
        C_Error_Buffer_Full : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_buffer_full_value";
        C_Error_Auth_Fail : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_auth_fail_value";
        C_Error_Flash_Fail : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_flash_fail_value";
        C_Error_Sensor_Fail : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_sensor_fail_value";
        C_Error_Timeout : constant Unsigned_8
          with Import, Convention => C, External_Name => "error_timeout_value";
    begin
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_None)) = C_Error_None,
               "Error_Code.Error_None matches protocol.h ERROR_NONE");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Crc_Fail)) = C_Error_Crc_Fail,
               "Error_Code.Error_Crc_Fail matches protocol.h ERROR_CRC_FAIL");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Unknown_Msg)) = C_Error_Unknown_Msg,
               "Error_Code.Error_Unknown_Msg matches protocol.h ERROR_UNKNOWN_MSG");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Wrong_Version)) = C_Error_Wrong_Version,
               "Error_Code.Error_Wrong_Version matches protocol.h ERROR_WRONG_VERSION");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Payload_Oversize)) = C_Error_Payload_Oversize,
               "Error_Code.Error_Payload_Oversize matches protocol.h ERROR_PAYLOAD_OVERSIZE");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Invalid_State)) = C_Error_Invalid_State,
               "Error_Code.Error_Invalid_State matches protocol.h ERROR_INVALID_STATE");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Buffer_Full)) = C_Error_Buffer_Full,
               "Error_Code.Error_Buffer_Full matches protocol.h ERROR_BUFFER_FULL");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Auth_Fail)) = C_Error_Auth_Fail,
               "Error_Code.Error_Auth_Fail matches protocol.h ERROR_AUTH_FAIL");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Flash_Fail)) = C_Error_Flash_Fail,
               "Error_Code.Error_Flash_Fail matches protocol.h ERROR_FLASH_FAIL");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Sensor_Fail)) = C_Error_Sensor_Fail,
               "Error_Code.Error_Sensor_Fail matches protocol.h ERROR_SENSOR_FAIL");
        Check (Unsigned_8 (Error_Code'Enum_Rep (Error_Timeout)) = C_Error_Timeout,
               "Error_Code.Error_Timeout matches protocol.h ERROR_TIMEOUT");
    end Check_Error_Code_Matches_C;

    --  Payload_Max_Size has to stay a static literal in protocol.ads (see
    --  comment there), so this is the only place it can be cross-checked
    --  against the true value in protocol.h.
    procedure Check_Payload_Max_Size_Matches_C is
        C_Payload_Max_Size : constant Unsigned_8
          with Import, Convention => C, External_Name => "payload_max_size";
    begin
        Check (Unsigned_8 (Payload_Max_Size) = C_Payload_Max_Size,
               "Payload_Max_Size matches protocol.h PAYLOAD_MAX_SIZE");
    end Check_Payload_Max_Size_Matches_C;

    --  Functional check the drift checks above don't cover: that
    --  Frame_Encode/Frame_Decode actually round-trip through the C codec
    --  correctly across the Ada binding (array-by-reference passing,
    --  out-param records, etc.), and that a tampered wire byte gets
    --  rejected by the CRC rather than silently accepted.
    procedure Check_Frame_Round_Trip is
        Wire_Buf_Size : constant := 5 + Payload_Max_Size + 2;

        Src : Frame :=
          (Start_Byte  => Start_Byte,
           Version     => Wire_Version,
           Message_Id  => Unsigned_8 (Msg_Id'Enum_Rep (Msg_Bootloader_Data)),
           Sequence    => 42,
           Payload_Len => 4,
           Payload     => (others => 0),
           Crc         => 0);

        Buffer      : Byte_Array (0 .. Wire_Buf_Size - 1) := (others => 0);
        Decoded     : Frame;
        Encoded_Len : Integer;
    begin
        Src.Payload (0) := 16#DE#;
        Src.Payload (1) := 16#AD#;
        Src.Payload (2) := 16#BE#;
        Src.Payload (3) := 16#EF#;

        Compute_Crc16_Table;

        Frame_Encode (Buffer, Wire_Buf_Size, Src, Encoded_Len);
        Check (Encoded_Len = 5 + Integer (Src.Payload_Len) + 2,
               "Frame_Encode returns header+payload+crc length");

        if Encoded_Len <= 0 then
            Check (False, "Frame_Decode round-trip skipped: encode failed");
            return;
        end if;

        declare
            Decoded_Len : Integer;
        begin
            Frame_Decode (Decoded, Buffer, Unsigned_32 (Encoded_Len), Decoded_Len);
            Check (Decoded_Len = Encoded_Len,
                   "Frame_Decode returns the same length Frame_Encode produced");
            Check (Decoded.Start_Byte = Src.Start_Byte, "decoded Start_Byte round-trips");
            Check (Decoded.Version = Src.Version, "decoded Version round-trips");
            Check (Decoded.Message_Id = Src.Message_Id, "decoded Message_Id round-trips");
            Check (Decoded.Sequence = Src.Sequence, "decoded Sequence round-trips");
            Check (Decoded.Payload_Len = Src.Payload_Len, "decoded Payload_Len round-trips");
            Check (Decoded.Payload (0 .. 3) = Src.Payload (0 .. 3),
                   "decoded Payload bytes round-trip");
        end;

        --  Flip a bit in the first payload byte on the wire; CRC covers
        --  version/message_id/sequence/payload_len/payload, so this must
        --  be caught.
        Buffer (5) := Buffer (5) xor 16#FF#;
        declare
            Tamper_Len : Integer;
        begin
            Frame_Decode (Decoded, Buffer, Unsigned_32 (Encoded_Len), Tamper_Len);
            Check (Tamper_Len < 0,
                   "Frame_Decode rejects a tampered payload byte (CRC mismatch)");
        end;
    end Check_Frame_Round_Trip;

    --  Exercises the host Flash mock: sector-boundary math (shared code,
    --  same for both backends), the lock-check guard, and the AND-only
    --  write semantics real NOR flash has (can clear bits, never set
    --  them -- proving erase is genuinely required before a rewrite).
    procedure Check_Flash is
        Result : Status;
        Addr0  : constant Unsigned_32 := Flash_Base;
    begin
        Check (Address_To_Sector (Flash_Base) = 0, "sector 0 starts at Flash_Base");
        Check (Address_To_Sector (Flash_Base + 16#3FFF#) = 0, "sector 0 ends at +0x3FFF");
        Check (Address_To_Sector (Flash_Base + 16#4000#) = 1, "sector 1 starts at +0x4000");
        Check (Address_To_Sector (Flash_Base + 16#1_FFFF#) = 4, "sector 4 ends at +0x1FFFF");
        Check (Address_To_Sector (Flash_Base + 16#2_0000#) = 5, "sector 5 starts at +0x20000");
        Check (Address_To_Sector (Flash_End) = 5, "sector 5 covers Flash_End");

        Lock;
        Write_Word (Addr0, 16#DEAD_BEEF#, Result);
        Check (Result = Locked, "Write_Word rejected while locked");

        Erase_Sector (0, Result);
        Check (Result = Locked, "Erase_Sector rejected while locked");

        Unlock;

        Erase_Sector (0, Result);
        Check (Result = Ok, "Erase_Sector succeeds when unlocked");
        Check (Read_Word (Addr0) = 16#FFFF_FFFF#, "erased word reads back as all 1s");

        Write_Word (Addr0, 16#0000_00F0#, Result);
        Check (Result = Ok, "Write_Word succeeds when unlocked");
        Check (Read_Word (Addr0) = 16#0000_00F0#, "written word reads back correctly");

        Write_Word (Addr0, 16#FFFF_FFFF#, Result);
        Check (Result = Ok and Read_Word (Addr0) = 16#0000_00F0#,
               "Write_Word can't set bits without erasing first (AND semantics)");

        Lock;
        Write_Word (Addr0, 16#1#, Result);
        Check (Result = Locked, "Lock re-engages write protection");
    end Check_Flash;

begin
    Put_Line ("Running Buffalo tests...");
    Check (1 + 1 = 2, "sanity check");
    Check_Msg_Id_Matches_C;
    Check_Bootloader_Cmd_Matches_C;
    Check_Error_Code_Matches_C;
    Check_Payload_Max_Size_Matches_C;
    Check_Frame_Round_Trip;
    Check_Flash;

    New_Line;
    if Failures = 0 then 
        Put_Line ("All tests passed");
    else 
        -- Ada uses 'Image as a str()
        Put_Line (Failures'Image & " tests failed.");
        Set_Exit_Status(Failure);
    end if;
end Test_Runner;