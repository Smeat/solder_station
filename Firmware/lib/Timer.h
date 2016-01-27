
#ifndef TIMER_H_
#define TIMER_H_

#include <avr/io.h>
#include <avr/interrupt.h>


extern uint32_t millis();

extern uint32_t micros();

extern void delay(unsigned long ms);

extern void delayMicroseconds(unsigned int us);

extern void init_timer0();


#endif /* TIMER_H_ */
