; SBRC

.ORG 0
.DEF MYREG = R16
.DEF COUNTREG = R20
.EQU FULL = 0xFF
.EQU ZERO = 0x00
.EQU ONE = 0b01
.EQU PINTRIG = 0b01
.EQU PIN_ECHO = 0b10
.EQU PINRELE = 0b10
.EQU REGIN = PIND
.EQU REGOUT = PINB


SETUP:
LDI MYREG, ZERO
OUT DDRD, MYREG ;MAKE PORTD INPUT

LDI MYREG, FULL
OUT DDRB, MYREG ;MAKE PORTB OUTPUT

MAIN:
	LDI COUNTREG, ZERO
	LDI MYREG, ZERO
	
	OUT REGOUT, MYREG
	OUT REGIN, MYREG

	LDI R16, 2
	RCALL LOOP_DELAY_US

	LDI R16, 10

	nop
	nop
	nop
	nop

	RCALL LOOP_DELAY_US
	
	RJMP WAIT_HIGH_LOOP
	
	RJMP MAIN



WAIT_HIGH_LOOP:

	IN MYREG, REGIN
	ldi r17, pin_echo

	AND MYREG, r17
	CPI MYREG, ZERO
	JMP WAIT_HIGH_LOOP
	JMP ECHO_LOW_LOOP
	
ECHO_LOW_LOOP:

	LDI	R16, 250
	RCALL LOOP_DELAY_US
	
	LDI	R16, 250
	RCALL LOOP_DELAY_US
	
	LDI	R16, 149
	RCALL LOOP_DELAY_US
	
	IN MYREG, REGIN
	
	OUT REGOUT, MYREG
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
	RET

TRIG_LOW:
	LDI MYREG, ZERO
	OUT REGOUT, MYREG 

TRIG_HIGH:
	LDI MYREG, PINTRIG
	OUT REGOUT, MYREG 
