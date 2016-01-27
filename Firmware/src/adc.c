/*
 * adc.c
 *
 *  Created on: 22.01.2016
 *      Author: kevin
 */

#include <inttypes.h>
#include <avr/io.h>
#include "adc.h"


uint16_t read_adc(uint8_t channel){
	ADMUX = (ADMUX & ~(0x1F)) | (channel & 0x1F); //set channel
	ADCSRA |= (1 << ADSC);
	while(ADCSRA & (1 << ADSC)); //wait for conversion to finish
	//TODO: eliminate extreme values (near max)

	return ADCW;
}

uint16_t read_adc_avg(uint8_t channel, uint8_t samples){
	uint32_t sum = 0;

	for(uint8_t i = 0; i < samples; ++i){
		sum += read_adc(channel);
	}

	return (uint16_t)(sum/samples);
}

void init_adc(){
	ADMUX = (1 << REFS0); //AVCC as reference

	ADCSRA = (1 << ADPS1) | (1 << ADPS2) | (1 << ADPS0); //64 prescaler
	ADCSRA |= (1 << ADEN); //enable adc

	ADCSRA |= (1 << ADSC);//first empty conversion
	while(ADCSRA & (1 << ADSC)); //wait for conversion to finish

	(void) ADCW; //throw away. ADCW = ADCH and ADCL
}

