
;PORTC HAS 8 LEDS
;DELAY REQUIRED

;.include "m32u4def.inc"		; .device line is in there too
.ORG 0
.DEF MYREG = R16
.EQU FULL = 0xFF
.EQU ZERO = 0x00
.EQU ONE = 0b01
.EQU PIN13 = 0b01
.EQU PIN12 = 0b10

SETUP:
LDI MYREG, FULL
OUT DDRD, MYREG ;MAKE PORTD OUTPUT

LDI MYREG, FULL
OUT DDRB, MYREG ;MAKE PORTD OUTPUT


;LDI MYREG, ZERO
;OUT DDRB, MYREG ;MAKE PORTD INPUT
;LDI MYREG, FULL
;OUT PORTB, MYREG ;ACTIVATE PULL UP RESISTORS ON PORTD

cli		; disable interrupts to avoid corruption of 16-bit registers
TIM16_ReadTCNT1:
	; Save global interrupt flag
	
	
	ldi r16, FULL
	out PORTB, r16
	
	ldi r30, ZERO
;	ldi TCCR1A, r30
	
	; Set TCNT1 to 0x01FF
	ldi r17, 0b1000
	ldi r16, 0xFF
	ldi r31, 0x00
	ldi r30, TCNT1H
	st Z, r17
	ldi r30, TCNT1L
	st Z, r16
	
	; Read TCNT1 into r17:r16

	ld r16, Z
	ldi r30, TCNT1H
	ld r17, Z
	
	
	OUT PORTD, r17
	
	ldi r16, zero
	out PORTB, r16
	

	JMP TIM16_ReadTCNT1



MAIN:


	JMP TIM16_ReadTCNT1
	NOP				 ;INPUT IS A ONE CYCLE PROCESS
	OUT PORTD, r16
	
	ldi r16, zero
	out PORTB, r16
	
	RJMP MAIN
