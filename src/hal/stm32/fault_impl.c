#include "fault_impl.h"

void delay(volatile uint32_t count) {
    while (count--);
}

void warning_light(void) {
    while (1) {
        
    }
}