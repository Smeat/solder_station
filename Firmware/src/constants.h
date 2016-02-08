/*
 * constants.h
 *
 *  Created on: 22.01.2016
 *      Author: kevin
 */

#include <avr/pgmspace.h>

#ifndef CONSTANTS_H_
#define CONSTANTS_H_

#define CHARACTER_THERMOMETER 0x01
#define CHARACTER_DEGREE 0x02
#define CHARACTER_KP 0x03
#define CHARACTER_KI 0x04
#define CHARACTER_KD 0x05
#define CHARACTER_PLAY 0x06
#define CHARACTER_PAUSE 0x07

#define HEATER_WAIT_DELAY 5

#define DEFAULT_KP 10
#define DEFAULT_KI 1.2
#define DEFAULT_KD 9

#define DEFAULT_FACTOR 0.48f
#define DEFAULT_CONSTANT 19

#define EEPROM_DEF 0xFF

#define MENU_MAIN 0
#define MENU_CONNECTED 1
#define MENU_OPTIONS_SELECT 2

#define MENU_OPTIONS_PID 3
#define MENU_OPTIONS_CALIBRATE 4
#define MENU_OPTIONS_RESET 5
#define MENU_OPTIONS_TEMP 6

#define NUM_MENU_OPTIONS 4

const char* option_menus[] = {"PID", "Calibration", "Temperatures", "Reset default"};



#define MENU_OPTIONS_PID_LAST_ITEM 3
#define MENU_OPTIONS_CALIBRATE_LAST_ITEM 2

#define MAX_PWM 1023

const float updateTime = 0.2f;

// Buttons
#define ROTATE_PIN PINB
#define ROTATE_PORT PORTB
#define ROTATE_DDR DDRB
#define ROTATE_A_PIN PB5
#define ROTATE_B_PIN PB3
#define ROTATE_C_PIN PB2

#define BUTTON_STANDBY_DDR DDRC
#define BUTTON_STANDBY_PIN_REGISTER PINC
#define BUTTON_STANDBY_PIN PC3
#define BUTTON_STANDBY_PORT PORTC

#define BUTTON_CONNECTED_DDR DDRC
#define BUTTON_CONNECTED_PIN_REGISTER PINC
#define BUTTON_CONNECTED_PIN PC2
#define BUTTON_CONNECTED_PORT PORTC

#define LCD_SUPPORT

#define UART_DEBUG1
#ifdef UART_DEBUG
//#define UART_DEBUG_PID
#define UART_DEBUG_INPUT
#define UART_DEBUG_TEMP1
#endif


#ifdef LCD_SUPPORT
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

#endif


#endif /* CONSTANTS_H_ */
