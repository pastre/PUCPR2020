.ORG 0x0000            ; the next instruction has to be written to
                       ; address 0x0000
rjmp START             ; the reset vector: jump to "main"
START:
ldi r16, low(RAMEND)   ; set up the stack
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, 0xFF          ; load register 16 with 0xFF (all bits 1)
out DDRB, r16          ; write the value in r16 (0xFF) to Data
ldi r16, 0xFF          ; load register 16 with 0xFF (all bits 1)
out DDRD, r16          ; write the value in r16 (0xFF) to Data
                       ; Direction Register B
rcall micros
LOOP:
  ldi r16, 0xff
  out portb,  r16        ; switch off the LED
  rcall delay_1       ; wait for half a second
  cbi PortB, 5         ; switch it on
  rcall delay_1       ; wait for half a secon
  rjmp LOOP            ; jump to loop

DELAY_1:              ; the subroutine: delay 1 second
  ldi r16, 64          ; load r16 with 31

OUTER_LOOP:            ; outer loop label
  ldi r24, low(1021)   ; load registers r24:r25 with 1021, our new
                       ; init value
  ldi r25, high(1021)  ; the loop label
DELAY_LOOP:            ; "add immediate to word": r24:r25 are
                       ; incremented
  adiw r24, 1          ; if no overflow ("branch if not equal"), go
		             ; back to "delay_loop"
  out PORTD, r16
  brne DELAY_LOOP
  dec r16              ; decrement r16
  brne OUTER_LOOP      ; and loop if outer loop not finished
  ret                  ; return from subroutine
