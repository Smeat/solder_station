/*
 * adc.h
 *
 *  Created on: 22.01.2016
 *      Author: kevin
 */

#include <inttypes.h>

#ifndef ADC_H_
#define ADC_H_

static uint16_t read_adc(uint8_t channel);

uint16_t read_adc_avg(uint8_t channel, uint8_t samples);

void init_adc();



#endif /* ADC_H_ */
