#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#include "../lib/lcd/lcd.h"
#include "../lib/Timer.h"

#include "constants.h"
#include "adc.h"

#ifdef UART_DEBUG
#include <uart.h>
#endif

#define ROTATE_A ((ROTATE_PIN & (1 << ROTATE_A_PIN)) == 0)
#define ROTATE_B ((ROTATE_PIN & (1 << ROTATE_B_PIN)) == 0)
#define ROTATE_C ((ROTATE_PIN & (1 << ROTATE_C_PIN)) == 0)

#define BUTTON_STANDBY ((BUTTON_STANDBY_PIN_REGISTER & (1 << BUTTON_STANDBY_PIN)) == 0)

#define BUTTON_CONNECTED ((BUTTON_CONNECTED_PIN_REGISTER & (1 << BUTTON_CONNECTED_PIN)) == 0)

uint16_t targetTemp = 0;
uint16_t standByTemp = 180;
uint16_t lastTemp = 0;

float Kp = DEFAULT_KP;
float Ki = DEFAULT_KI;
float Kd = DEFAULT_KD;

float ee_Kp EEMEM = DEFAULT_KP;
float ee_Ki EEMEM = DEFAULT_KI;
float ee_Kd EEMEM = DEFAULT_KD;

float Ki_time = 0;
float Kd_time = 0;
volatile int8_t rotary_value;

uint8_t current_menu = MENU_MAIN;
uint8_t menu_pos = 0;

void setPWM(int16_t val){
	OCR1A = val;
}

#ifdef UART_DEBUG
int uart_putchar(char c, FILE* stream){
	uart_putc(c);
	return 0;
}
#endif

int8_t read_rotary(){
	cli();
	int8_t value = rotary_value;
	rotary_value = value & 0b0011; //save lower bits (e.g. if function returns values less than 4)
	sei();
	return value >> 2;
}

void enableHeater(){
	TCCR1A |= (1 << COM1A1);
}

void disableHeater(){
	TCCR1A &= ~(1 << COM1A1);
}

uint16_t getTemperature(){
	disableHeater();
	_delay_us(HEATER_WAIT_DELAY);

	uint16_t temperature = read_adc_avg(0, 4) * adc_temp_factor + adc_temp_constant;

	enableHeater();

	lastTemp = temperature; //save last temp for display

	return temperature;
}

uint16_t calculatePID(uint16_t target, uint16_t is){
	static uint16_t oldError = 0;
	static float iterm = 0;

	int16_t error = target - is;

	float pterm = Kp * error;
	float dterm = Kd_time * (int16_t)((int16_t)error - (int16_t)oldError);

	if(((pterm + iterm + dterm) < MAX_PWM) && ((pterm + iterm + dterm) > -MAX_PWM)){
		iterm += (Ki_time * error);
	}

	float output = pterm + iterm + dterm;

	if(output > MAX_PWM) output = MAX_PWM;
	if(output < 0) output = 0;

	oldError = error;

#ifdef UART_DEBUG_PID
	printf("Error: %i ||", error);
	char s[8];
	dtostrf( pterm, 6, 3, s );
	uart_puts(s);
	uart_puts(" + ");
	dtostrf( iterm, 6, 3, s );
	uart_puts(s);
	uart_puts(" + ");

	dtostrf( dterm, 6, 3, s );
	uart_puts(s);
	uart_puts(" = ");
	dtostrf( output, 6, 3, s );
	uart_puts(s);
	uart_puts("\n");
#endif

	return (uint16_t)output;
}

uint8_t isStandby(){
	return BUTTON_STANDBY; //TODO: read button
}

void updateOuput(){
	uint16_t output = calculatePID((isStandby() ? standByTemp : targetTemp), getTemperature());
	setPWM(output);
}

void precalcPID(){
	Ki_time = Ki * updateTime;
	Kd_time = Kd / updateTime;
}

uint8_t getKeyPressed() {
	static uint8_t last_status = 0;
	uint8_t temp1, temp2;

	temp1 = ROTATE_C;
	_delay_ms(5);
	temp2 = ROTATE_C;

	temp1 = temp1 & temp2; //

	temp2 = (last_status < temp1); //use temp2 as return value

	last_status = temp1;
	return (temp2);
}

void init_lcd(){
	lcd_init(LCD_DISP_ON);
	lcd_clrscr();

	lcd_add_custom_character_P(CHARACTER_THERMOMETER, char_thermometer);
	lcd_add_custom_character_P(CHARACTER_DEGREE, char_degree);
	lcd_add_custom_character_P(CHARACTER_KP, char_kp);
	lcd_add_custom_character_P(CHARACTER_KI, char_ki);
	lcd_add_custom_character_P(CHARACTER_KD, char_kd);
	lcd_add_custom_character_P(CHARACTER_PLAY, char_play);
	lcd_add_custom_character_P(CHARACTER_PAUSE, char_pause);
}

void init_timer(){
	//1ms timer2 TODO: alternative use main loop and millis()?
	TCCR2A = (1 << WGM21); //CTC
	TCCR2B = (1 << CS20) | (1 << CS21); // /64 prescaler
	OCR2A = 250; // 1 ms
	TIMSK2 = (1 << OCIE2A); //enable compare A

	// PWM
	DDRB |= (1 << PB1); //enable output
	TCCR1A = (1<<WGM10) | (1<<WGM11) | (1<<COM1A1); // 10bit-Counter, FastPWM
	TCCR1B =  (1 << CS10) | (1 << CS11) | (1 << WGM12); // 64 prescaler -> 244hz

	init_timer0();

	sei();
}

void updateDisplay(){
	lcd_clrscr();
	lcd_home();
	char menu_string[60];
	uint8_t cursor_end_pos[2] = {0,0};
	if(current_menu == MENU_MAIN){
		lcd_command(LCD_DISP_ON);
		lcd_puts_P("Solder Station 0.1");
		lcd_gotoxy(0,1);

		sprintf(menu_string, "%c%-3u/%-3u%cC \n"
							 "%c\n"
							  "PWM: %-4u\n",
							  CHARACTER_THERMOMETER, lastTemp, targetTemp, CHARACTER_DEGREE, isStandby() ? CHARACTER_PAUSE : CHARACTER_PLAY, OCR1A);
	}
	else if (current_menu == MENU_OPTIONS){
		lcd_command(LCD_DISP_ON_CURSOR);


		char kp[8], ki[8], kd[8];
		dtostrf( Kp, 6, 1, kp );
		dtostrf( Ki, 6, 2, ki );
		dtostrf( Kd, 6, 1, kd );


		sprintf(menu_string, "Options Menu\n"
							 "%c%-3u/%-3u%cC\n"
							 "%c:%-3s %c:%-3s \n%c:%-3s\n",  CHARACTER_THERMOMETER, lastTemp, targetTemp, CHARACTER_DEGREE,
							 	 	 	 	 	   CHARACTER_KP, kp, CHARACTER_KI, ki, CHARACTER_KD, kd);



		if(menu_pos == 0){ //TODO: make me better. array?
			cursor_end_pos[0] = 7;
			cursor_end_pos[1] = 2;
		}
		else if(menu_pos == 1) {
			cursor_end_pos[0] = 16;
			cursor_end_pos[1] = 2;
		}
		else if(menu_pos == 2){
			cursor_end_pos[0] = 7;
			cursor_end_pos[1] = 3;
		}
	}
	else if (current_menu == MENU_CONNECTED){
		sprintf(menu_string,"Error!\nSolder iron\nnot connected!!\nPlease connect!\n");
	}

	lcd_puts(menu_string);
	lcd_gotoxy(cursor_end_pos[0],cursor_end_pos[1]);
}

void init_io(){
	 ROTATE_DDR &=~ (1 << ROTATE_A_PIN);
	 ROTATE_DDR &=~ (1 << ROTATE_B_PIN);
	 ROTATE_DDR &=~ (1 << ROTATE_C_PIN);
	 ROTATE_PORT |= (1 << ROTATE_A_PIN) | (1 << ROTATE_B_PIN) | (1 << ROTATE_C_PIN);
	 BUTTON_STANDBY_DDR &=~(1 << BUTTON_STANDBY_PIN);
	 BUTTON_STANDBY_PORT |= (1 << BUTTON_STANDBY_PIN);

	 BUTTON_CONNECTED_DDR &= ~(1 << BUTTON_CONNECTED_PIN);
	 BUTTON_CONNECTED_PORT |= (1 << BUTTON_CONNECTED_PIN);
}

#ifdef UART_DEBUG
void init_uart(){
	uart_init(UART_BAUD_SELECT(9600L, F_CPU));

	fdevopen( &uart_putchar, 0 );

	printf("UART Begin!\n");
}
#endif

ISR(TIMER2_COMPA_vect){
	uint8_t val, diff;
	static uint8_t last = 0;
	val = 0;
	if( ROTATE_A )
		val = 0b0011;
	if( ROTATE_B )
		val ^= 1;
	diff = last - val;
	if( diff & 1 ){ //bit 0 changed -> rotated
		last = val;
		rotary_value += (diff & 0b0010) - 1; //bit 1 = direction
	}
}

void saveEEPROM(){
	cli();
	eeprom_update_float(&ee_Kp, Kp);
	eeprom_update_float(&ee_Ki, Ki);
	eeprom_update_float(&ee_Kd, Kd);
	sei();

	precalcPID();
}

void loadEEPROM(){
	cli();
	if((Kp = eeprom_read_float(&ee_Kp)) == EEPROM_DEF){
		Kp = DEFAULT_KP;
	}
	if((Ki = eeprom_read_float(&ee_Ki)) == EEPROM_DEF){
		Ki = DEFAULT_KI;
	}
	if((Kd = eeprom_read_float(&ee_Kd)) == EEPROM_DEF){
		Kd = DEFAULT_KD;
	}
	sei();

	precalcPID();
}

void processInput(){
	int8_t button = read_rotary();

	if(current_menu == MENU_CONNECTED && BUTTON_CONNECTED){
		current_menu = MENU_MAIN;
	}

	if(!BUTTON_CONNECTED){
		current_menu = MENU_CONNECTED;
	}

	else if(current_menu == MENU_MAIN){ //do this if we are in main menu
		targetTemp += button;
		if(getKeyPressed()){
			current_menu = MENU_OPTIONS; //button pressed -> switch to options menu
		}
	}
	else if(current_menu == MENU_OPTIONS){ //do this if we are in options menu

		if(menu_pos == 0){
			Kp += 0.1 * button;
		}
		if(menu_pos == 1){
			Ki += 0.01 * button;
		}
		if(menu_pos == 2){
			Kd += 0.1 * button;
		}

		if(getKeyPressed()){ //button pressed -> go to next item
			if(++menu_pos == MENU_OPTIONS_LAST_ITEM){ //last item -> exit and save to eeprom
				current_menu = MENU_MAIN;
				menu_pos = 0;
				saveEEPROM();
			}
		}
	}
}

int main(){
#ifdef UART_DEBUG
	init_uart();
#endif
	init_lcd();
	init_timer();
	init_adc();
	init_io();

	precalcPID();
	targetTemp = 230;

	loadEEPROM();

	uint8_t lastUpdate = 0;

	while(1){
		if((millis() - lastUpdate) > (updateTime * 1000)){
			lastUpdate = millis();
			processInput();
			updateDisplay();
			updateOuput();
		}


	}
}
