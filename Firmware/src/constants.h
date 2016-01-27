/*
 * constants.h
 *
 *  Created on: 22.01.2016
 *      Author: kevin
 */

#ifndef CONSTANTS_H_
#define CONSTANTS_H_


//from marlin https://github.com/MarlinFirmware/Marlin
static const PROGMEM unsigned char char_thermometer[] =
{
		0b00100,
		0b01010,
		0b01010,
		0b01010,
		0b01010,
		0b10001,
		0b10001,
		0b01110

};

static const PROGMEM unsigned char char_degree[] =
{
		0b01100,
		0b10010,
		0b10010,
		0b01100,
		0b00000,
		0b00000,
		0b00000,
		0b00000
};

static const PROGMEM unsigned char char_ki[] =
{
		0b10010,
		0b10100,
		0b11000,
		0b10101,
		0b10010,
		0b00001,
		0b00001,
		0b00001
};


static const PROGMEM unsigned char char_kp[] =
{
	0b10010,
	0b10100,
	0b11000,
	0b10100,
	0b10010,
	0b01100,
	0b01100,
	0b01000
};

static const PROGMEM unsigned char char_kd[] =
{
	0b10010,
	0b10100,
	0b11000,
	0b10100,
	0b10010,
	0b01100,
	0b01010,
	0b01100
};

static const PROGMEM unsigned char char_play[] =
{
	0b11000,
	0b10100,
	0b10010,
	0b10001,
	0b10010,
	0b10100,
	0b11000,
	0b00000
};

static const PROGMEM  unsigned char char_pause[] =
{
	0b00000,
	0b11011,
	0b11011,
	0b11011,
	0b11011,
	0b11011,
	0b11011,
	0b00000
};

#define CHARACTER_THERMOMETER 0x01
#define CHARACTER_DEGREE 0x02
#define CHARACTER_KP 0x03
#define CHARACTER_KI 0x04
#define CHARACTER_KD 0x05
#define CHARACTER_PLAY 0x06
#define CHARACTER_PAUSE 0x07

#define HEATER_WAIT_DELAY 20

#define DEFAULT_KP 70
#define DEFAULT_KI 1.03
#define DEFAULT_KD 10

#define EEPROM_DEF 0xFF

#define MENU_MAIN 0
#define MENU_OPTIONS 1
#define MENU_CONNECTED 2

#define MENU_OPTIONS_LAST_ITEM 3

#define MAX_PWM 1023

const float updateTime = 0.1f;
const float adc_temp_factor = 1;
const int16_t adc_temp_constant = 100;

// Buttons
#define ROTATE_PIN PINC
#define ROTATE_PORT PORTC
#define ROTATE_DDR DDRC
#define ROTATE_A_PIN PC3
#define ROTATE_B_PIN PC4
#define ROTATE_C_PIN PC2

#define BUTTON_STANDBY_DDR DDRC
#define BUTTON_STANDBY_PIN_REGISTER PINC
#define BUTTON_STANDBY_PIN PC5
#define BUTTON_STANDBY_PORT PORTC

#define BUTTON_CONNECTED_DDR DDRC
#define BUTTON_CONNECTED_PIN_REGISTER PINC
#define BUTTON_CONNECTED_PIN PC1
#define BUTTON_CONNECTED_PORT PORTC

//#define UART_DEBUG
//#define UART_DEBUG_PID

#endif /* CONSTANTS_H_ */
