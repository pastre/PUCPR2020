.INCLUDE <M328PDEF.INC>
; SBRC

.ORG 0
.DEF MYREG = R16
.DEF COUNTREG = R20
.EQU FULL = 0xFF
.EQU ZERO = 0x00
.EQU ONE = 0b01
.EQU PINTRIG = 0b100000
.EQU PIN_ECHO = 0b1
.EQU PINRELE = 0b10
.EQU REGIN = PIND
.EQU REGOUT = PORTB
.EQU REGCONTROL = PINC


SETUP:
LDI MYREG, 0x08
OUT DDRD, MYREG ;MAKE PORTD INPUT

LDI MYREG, FULL
OUT DDRB, MYREG ;MAKE PORTB OUTPUT

LDI MYREG, FULL
OUT DDRC, MYREG ;MAKE PORTC OUTPUT

LDI MYREG, ZERO
OUT REGCONTROL, MYREG

MAIN:
	
	OUT REGOUT, MYREG
	OUT REGIN, MYREG
	
	RCALL TRIG_LOW
	LDI R16, 2
	RCALL LOOP_DELAY_US
	
	LDI R16, 20
	
	RCALL LOOP_DELAY_US
	RCALL TRIG_HIGH
	
	RJMP WAIT_HIGH_LOOP
	RCALL TRIG_LOW



WAIT_HIGH_LOOP:
	
	IN MYREG, REGIN
	OUT REGCONTROL, MYREG
	SBIC PIND,7
	RJMP lIGA
	RJMP DESLIGA
	
	
ECHO_LOW_LOOP:
	
	LDI	R16, 250
	RCALL LOOP_DELAY_US
	
	LDI	R16, 250
	RCALL LOOP_DELAY_US
	
	LDI	R16, 100
	RCALL LOOP_DELAY_US

	
	IN MYREG, REGIN
	COM MYREG
	OUT REGCONTROL, MYREG
	JMP MAIN


DELAY_US:

	; NOP - para compensar a carga do valor de R16 via LDI
	NOP
	NOP
	NOP
	NOP

LOOP_DELAY_US:
	DEC 	R16
	CPI 	R16, 0
	BREQ    FIM_DELAY_US
	
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP	
	RJMP 	LOOP_DELAY_US

FIM_DELAY_US:
	NOP
	NOP
	NOP
	NOP
	RET

TRIG_LOW:
	LDI MYREG, ZERO
	OUT REGOUT, MYREG 
	RET

TRIG_HIGH:
	LDI MYREG, FULL
	OUT REGOUT, MYREG 
	RET

LIGA: 
	SBI PORTD, 5
	RJMP MAIN

DESLIGA:
	CBI PORTD, 5
	RJMP MAIN

	
