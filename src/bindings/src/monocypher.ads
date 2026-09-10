with Interfaces; use Interfaces;

--  hashing an image (Blake2b), checking its signature (EdDSA/Curve25519), 
--  and scrubbing key material afterward (Wipe).
package Monocypher
  with SPARK_Mode => On
is

   type Byte_Array is array (Natural range <>) of Unsigned_8
     with Convention => C;

   subtype Public_Key_Bytes is Byte_Array (0 .. 31);  -- crypto_eddsa_check's public_key[32]
   subtype Signature_Bytes  is Byte_Array (0 .. 63);  -- crypto_eddsa_check's signature[64]

   --  crypto_wipe(void *secret, size_t size) -- zeroes Secret in place.
   procedure Wipe
     (Secret : in out Byte_Array;
      Size   : Unsigned_32)
     with Import, Convention => C, External_Name => "crypto_wipe",
          Global => null;

   --  crypto_blake2b(uint8_t *hash, size_t hash_size,
   --                 const uint8_t *message, size_t message_size)
   procedure Blake2b
     (Hash         : out Byte_Array;
      Hash_Size    : Unsigned_32;
      Message      : Byte_Array;
      Message_Size : Unsigned_32)
     with Import, Convention => C, External_Name => "crypto_blake2b",
          Global => null;

   --  crypto_eddsa_check(const uint8_t signature[64],
   --                     const uint8_t public_key[32],
   --                     const uint8_t *message, size_t message_size)
   --
   --  Returns 0 if the signature is valid for Message under Public_Key,
   --  nonzero otherwise
   function Eddsa_Check
     (Signature    : Signature_Bytes;
      Public_Key   : Public_Key_Bytes;
      Message      : Byte_Array;
      Message_Size : Unsigned_32) return Integer
     with Import, Convention => C, External_Name => "crypto_eddsa_check",
          Global => null;

end Monocypher;
