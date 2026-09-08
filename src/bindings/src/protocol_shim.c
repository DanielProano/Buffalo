#include <stdint.h>
#include "protocol.h"

const uint8_t protocol_start_byte_value = PROTOCOL_START_BYTE;
const uint8_t protocol_version_value    = PROTOCOL_VERSION;
const uint8_t payload_max_size         = PAYLOAD_MAX_SIZE;

const uint8_t msg_ack_value              = MSG_ACK;
const uint8_t msg_nack_value             = MSG_NACK;
const uint8_t msg_bootloader_cmd_value   = MSG_BOOTLOADER_CMD;
const uint8_t msg_bootloader_data_value  = MSG_BOOTLOADER_DATA;
const uint8_t msg_bootloader_stats_value = MSG_BOOTLOADER_STATS;

const uint8_t bootloader_none_value       = BOOTLOADER_NONE;
const uint8_t bootloader_stats_value      = BOOTLOADER_STATS;
const uint8_t bootloader_erase_app_value  = BOOTLOADER_ERASE_APP;
const uint8_t bootloader_update_value     = BOOTLOADER_UPDATE;
const uint8_t bootloader_verify_value     = BOOTLOADER_VERIFY;

const uint8_t error_none_value             = ERROR_NONE;
const uint8_t error_crc_fail_value         = ERROR_CRC_FAIL;
const uint8_t error_unknown_msg_value      = ERROR_UNKNOWN_MSG;
const uint8_t error_wrong_version_value    = ERROR_WRONG_VERSION;
const uint8_t error_payload_oversize_value = ERROR_PAYLOAD_OVERSIZE;
const uint8_t error_invalid_state_value    = ERROR_INVALID_STATE;
const uint8_t error_buffer_full_value      = ERROR_BUFFER_FULL;
const uint8_t error_auth_fail_value        = ERROR_AUTH_FAIL;
const uint8_t error_flash_fail_value       = ERROR_FLASH_FAIL;
const uint8_t error_sensor_fail_value      = ERROR_SENSOR_FAIL;
const uint8_t error_timeout_value          = ERROR_TIMEOUT;
