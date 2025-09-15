;*----------------------------------------------------------------------------
;* Name:    Lab_1_program.s 
;* Purpose: This code flashes one LED at approximately 1 Hz frequency 
;* Author: 	Rasoul Keshavarzi 
;*----------------------------------------------------------------------------*/
	THUMB		; Declare THUMB instruction set 
	AREA		My_code, CODE, READONLY 	; 
	EXPORT		__MAIN 		; Label __MAIN is used externally q
	ENTRY 
__MAIN
; The following operations can be done in simpler methods. They are done in this 
; way to practice different memory addressing methods. 
; MOV moves into the lower word (16 bits) and clears the upper word
; MOVT moves into the upper word
; show several ways to create an address using a fixed offset and register as offset
;   and several examples are used below
; NOTE MOV can move ANY 16-bit, and only SOME >16-bit, constants into a register
; BNE and BEQ can be used to branch on the last operation being Not Equal or EQual to zero
;
	MOV 		R2, #0xC000		; move 0xC000 into R2
	MOV 		R4, #0x0		; init R4 register to 0 to build address
	MOVT 		R4, #0x2009		; assign 0x20090000 into R4
	ADD 		R4, R4, R2 		; add 0xC000 to R4 to get 0x2009C000 
	

	MOV 		R3, #0x0000007C	; move initial value for port P2 into R3 
	STR 		R3, [R4, #0x40] 	; Turn off five LEDs on port 2


	MOV 		R3, #0xB0000000	; move initial value for port P1 into R3
	STR 		R3, [R4, #0x20]	; Turn off three LEDs on Port 1 using an offset
	


	MOV 		R2, #0x20		; put Port 1 offset into R2 for user later	

loopb
	; resets the counter (start of cycle resets)

	MOV 		R0, #0x2C2B 		; Initialize R0 lower word for countdown
	MOVT		R0, #0x000A 
	; We calcaulted R0 (number of cycles) by finding the amount hertz it takes per cycle and setting it to 0.5s
	; (3/4MHz) * (number of cycles) = 0.5s
	; number of cycles = 0.5s * ((4 * 10^6 Hz)/3)
	; number of cycles = 666,666.666667
	; number of cycles (in hex = 0xA2C2B)
	; using MOV and MOVT, we manipulate the number of cycles (R0) to start at 0x000A2C2B
	
loop
; Main loop that iterates from start of the cycle until it reaches 0

	SUBS 		R0, #1 			; Decrement r0 and set the N,Z,C status bits
	;
	; 	Approximately five lines of code
	; 	are required to complete the program 
	;
	
	BNE			loop	
	; Once counter reaches 0, below code gets executed (flip 28th bit to change state (on/off) of the first led (P1.28))

	
	EOR			R3, #1 << 28 
	; toggle R3 (first led on/off register) with EOR (XOR in ARM) to toggle between 0 and 1 each time it gets to this point
	
	STR			R3, [R4, R2] ; write R3 port 1, YOU NEED to toggle bit 28 first
	
					
	B			loopb		; This branch has been fixed!

 	END 


; ADD R4, R4, R2 in Hand Assembled Code:
; 1110 00 0 0100 0 0100 0100 0000 0000 0010
