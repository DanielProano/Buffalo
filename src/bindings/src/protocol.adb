package body Protocol
  with SPARK_Mode => On,
       Refined_State => (Crc_Table_State => null)
is
   procedure Frame_Encode
     (Buffer   : out Byte_Array;
      Buf_Size : Unsigned_32;
      Source   : Frame;
      Length   : out Integer)
   is
      pragma SPARK_Mode (Off);
   begin
      Length := Frame_Encode_Raw (Buffer, Buf_Size, Source);
   end Frame_Encode;

   procedure Frame_Decode
     (Decoded  : out Frame;
      Buffer   : Byte_Array;
      Buf_Size : Unsigned_32;
      Length   : out Integer)
   is
      pragma SPARK_Mode (Off);
   begin
      Length := Frame_Decode_Raw (Decoded, Buffer, Buf_Size);
   end Frame_Decode;

end Protocol;
