# Buffalo

A secure bootloader for STM32F4, written in SPARK Ada, supporting cryptographically verified over-the-air (OTA) firmware updates with automatic rollback.

Buffalo is part of a larger autonomous drone project: an STM32F401/F411 flight controller running a custom RTOS, paired with an ESP32 acting as a wifi relay for video streaming and OTA delivery. Buffalo guarantees that only the verified vendor can provide firmware
updates and implements hardware watch-dogs to ensure firmware is compatible.

## Why this exists

My autonomous drone project necessitates frequent, error-free firmware updates via Wi-Fi, eliminating the need to physically re-flash 
and providing the ability for quick, reliable firmware updates. This project is designed to address two needs:

- **Unauthorized or corrupted firmware** could run on a device with spinning props attached to it. Every firmware image is signed, allowing Buffalo to verify firmware is both untampered and correct.
- **A bad update could brick the board**, requiring a wired reflash to recover. Buffalo keeps a verified backup of the last known-good firmware and automatically reverts to it if a new update fails to boot cleanly.

The cryptographic verification logic is written in SPARK Ada specifically so its correctness can be formally proven. In this Autonomous drone project, all trust and verification happens on the STM32, with the ESP32 acting as the relay.

## Update flow

1. A new firmware image arrives over UART (relayed from the laptop via the ESP32) and is written into the Archive slot's staging area.
2. Buffalo verifies the image's signature (Ed25519, via Monocypher) before doing anything else with it. An invalid signature halts the update entirely.
3. Buffalo copies the **currently running** firmware from the Run slot into the Archive slot's backup area — preserving a known-good fallback.
4. The verified new image is copied from Archive into the Run slot.
5. Buffalo sets a boot-health counter to a nonzero value and jumps into the new firmware.
6. The application, once it has confirmed itself stable (RTOS scheduler running, control loop ticking, no fault triggered), clears the counter back to zero.
7. If the new firmware hangs or crashes before reaching that point, an independent hardware watchdog forces a reset. Buffalo runs again, sees the counter is still nonzero, concludes the update failed, and restores the backup from the Archive slot.

This gives the system rollback safety equivalent to a traditional A/B dual-slot bootloader, without requiring the application to be built and signed twice for two different addresses.

## Status

Early development. Toolchain and build pipeline (Alire, `gnat_arm_elf`, native test crate) are working. Bootloader logic, HAL implementations, and the update/verification flow described above are in progress.
