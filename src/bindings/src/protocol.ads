-- use unsigned 8/16/32 bit Ada types
with Interfaces; use Interfaces;

package Protocol
  with SPARK_Mode => On,
       Abstract_State => Crc_Table_State
is

   --  Sourced from protocol.h via protocol_shim.c
   Start_Byte : constant Unsigned_8
     with Import, Convention => C, External_Name => "protocol_start_byte_value";

   Wire_Version : constant Unsigned_8
     with Import, Convention => C, External_Name => "protocol_version_value";

   Payload_Max_Size : constant := 128;

   type Byte_Array is array (Natural range <>) of Unsigned_8
     with Convention => C;

   subtype Payload_Bytes is Byte_Array (0 .. Payload_Max_Size - 1);

   type Msg_Id is
     (Msg_Ack,
      Msg_Nack,
      Msg_Bootloader_Cmd,
      Msg_Bootloader_Data,
      Msg_Bootloader_Stats);
   for Msg_Id use
     (Msg_Ack              => 1,
      Msg_Nack             => 2,
      Msg_Bootloader_Cmd   => 6,
      Msg_Bootloader_Data  => 7,
      Msg_Bootloader_Stats => 8);
   for Msg_Id'Size use 8;

   type Bootloader_Cmd is
     (Bootloader_None,
      Bootloader_Stats,
      Bootloader_Erase_App,
      Bootloader_Update,
      Bootloader_Verify);
   for Bootloader_Cmd use
     (Bootloader_None      => 0,
      Bootloader_Stats     => 1,
      Bootloader_Erase_App => 2,
      Bootloader_Update    => 3,
      Bootloader_Verify    => 4);
   for Bootloader_Cmd'Size use 8;

   type Error_Code is
     (Error_None,
      Error_Crc_Fail,
      Error_Unknown_Msg,
      Error_Wrong_Version,
      Error_Payload_Oversize,
      Error_Invalid_State,
      Error_Buffer_Full,
      Error_Auth_Fail,
      Error_Flash_Fail,
      Error_Sensor_Fail,
      Error_Timeout);
   for Error_Code use
     (Error_None             => 0,
      Error_Crc_Fail         => 1,
      Error_Unknown_Msg      => 2,
      Error_Wrong_Version    => 3,
      Error_Payload_Oversize => 4,
      Error_Invalid_State    => 5,
      Error_Buffer_Full      => 6,
      Error_Auth_Fail        => 7,
      Error_Flash_Fail       => 8,
      Error_Sensor_Fail      => 9,
      Error_Timeout          => 10);
   for Error_Code'Size use 8;

   type Frame is record
      Start_Byte  : Unsigned_8;
      Version     : Unsigned_8;
      Message_Id  : Unsigned_8;
      Sequence    : Unsigned_8;
      Payload_Len : Unsigned_8;
      Payload     : Payload_Bytes;
      Crc         : Unsigned_16;
   end record
     with Convention => C, Pack, Size => (5 + Payload_Max_Size + 2) * 8;

   type Ack_Payload is record
      Ack_Seq : Unsigned_8;
   end record
     with Convention => C, Size => 1 * 8;

   type Nack_Payload is record
      Nacked_Seq : Unsigned_8;
      Error      : Unsigned_8;
   end record
     with Convention => C, Size => 2 * 8;

   type Bootloader_Cmd_Payload is record
      Addr      : Unsigned_32;
      Len       : Unsigned_16;
      Cmd       : Unsigned_8;
      Signature : Byte_Array (0 .. 63);
   end record
     with Convention => C, Pack, Size => (4 + 2 + 1 + 64) * 8;

   type Bootloader_Data_Payload is record
      Addr : Unsigned_32;
      Data : Byte_Array (0 .. 63);
   end record
     with Convention => C, Pack, Size => (4 + 64) * 8;

   type Bootloader_Stats_Payload is record
      Cur_Counter        : Unsigned_32;
      Bank_A_Version     : Unsigned_32;
      Bank_B_Version     : Unsigned_32;
      Active_Bank        : Unsigned_8;
      Last_Update_Result : Unsigned_8;
   end record
     with Convention => C, Pack, Size => (4 + 4 + 4 + 1 + 1) * 8;

   procedure Compute_Crc16_Table
     with Import, Convention => C, External_Name => "compute_crc16_table",
          Global => (Output => Crc_Table_State);

   function Compute_Crc16
     (Buffer      : Byte_Array;
      Buffer_Len  : Unsigned_32) return Unsigned_16
     with Import, Convention => C, External_Name => "compute_crc16",
          Global => (Input => Crc_Table_State);

   procedure Frame_Encode
     (Buffer   : out Byte_Array;
      Buf_Size : Unsigned_32;
      Source   : Frame;
      Length   : out Integer)
     with Global => (Input => Crc_Table_State);

   procedure Frame_Decode
     (Decoded  : out Frame;
      Buffer   : Byte_Array;
      Buf_Size : Unsigned_32;
      Length   : out Integer)
     with Global => (Input => Crc_Table_State);

private

   function Frame_Encode_Raw
     (Buffer   : out Byte_Array;
      Buf_Size : Unsigned_32;
      Source   : Frame) return Integer
     with Import, Convention => C, External_Name => "protocol_frame_encode",
          SPARK_Mode => Off;

   function Frame_Decode_Raw
     (Decoded  : out Frame;
      Buffer   : Byte_Array;
      Buf_Size : Unsigned_32) return Integer
     with Import, Convention => C, External_Name => "protocol_frame_decode",
          SPARK_Mode => Off;

end Protocol;
