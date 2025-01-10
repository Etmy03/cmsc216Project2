; Utility functions for CMSC216
; Project #5 - Spring 2023
; Author: Sandro Fouche
; Copyright 2021


; Just a little main routine for testing purposes
;
;_MAIN
;			ADR		R0, HELLO
;			ADR		R1, TEST
;			BL		CONCAT
;			BL		STRLEN
;			END
;
; Two packed strings: "Hello, World!" and "This is a test."
;			
;
;HELLO		DCB		0x48,0x65,0x6C,0x6C,0x6F,0x2C,0x20,0x57,0x6F,0x72,0x6C,0x64,0x21,0x0,0x0,0x0
;TEST		DCB		0x54,0x68,0x69,0x73,0x20,0x69,0x73,0x20,0x61,0x20,0x74,0x65,0x73,0x74,0x2E,0x0

		
			
; ******* Subroutines begin here *******		

; returns the length of string passed into R0
; int STRLEN(char *R0); pp
; clobbers registers: R0, R1, R2

STRLEN
			MOV		R1, R0
STRLEN_L1__
			LDRB	R2, [R1], #1
			CMP		R2, #0
			BNE		STRLEN_L1__

			SUB		R0, R1, R0
			SUB		R0, R0, #1
			MOV		R15, R14
		
			
; allocates and returns a string that is the concatenation of strings passed into R0 & R1
; char *CONCAT(char *R0, char *R1);	
; clobbers registers: R0, R1, R2, R3		

CONCAT
			STMFD	SP!, {R14,R11}
			MOV		R11, SP
			SUB		SP, SP, #16
			STR		R0, [R11, #-8]
			STR		R1, [R11, #-12]
			BL		STRLEN
			MOV		R3, R0
			LDR		R0, [R11, #-12]
			BL		STRLEN
			ADD		R0, R0, R3
			ADD		R0, R0, #1
			BL		ALLOCATE
			STR		R0, [R11, #-16]
			LDR		R1, [R11, #-8]
CONCAT_1__
			LDRB	R2, [R1], #1
			STRB	R2, [R0], #1
			CMP		R2, #0
			BNE		CONCAT_1__
			SUB		R0, R0, #1
			LDR		R1,[R11,#-12]
CONCAT_2__
			LDRB	R2, [R1], #1
			STRB	R2, [R0], #1
			CMP		R2, #0
			BNE		CONCAT_2__
			LDR		R0, [R11, #-16]
			ADD		SP, SP, #16
			LDMFD	SP!, {R14,R11}
			MOV		R15, R14			


; If possible, allocates R0 bytes from free memory.  Returns the pointer or NULL. 	
; void *ALLOCATE(unsigned int R0);
; clobbers registers: R0, R1, R2, R3

ALLOCATE    
            MOV     R2, R0
            ADR     R1, FREE_PTR__
            LDR     R0, [R1]
            CMP     R0, #0

            LDREQ   R0, =HEAP__
            STREQ   R0, [R0]

            ADD     R3, R0, R2
            STR     R3, [R1]
            MOV     R15, R14

FREE_PTR__  DCD     0
HEAP__      DCD     0


; Multiplies two integers in R0 & R1.  Returns the result in R0 	
; int MULTIPLY(int R0, int R1);
; clobbers registers: R0, R1, R2, R3
MULTIPLY    
            MOV     R2, R0
            MOV     R0, #0

            CMP     R1, #0
            SUBLT   R1, R0, R1
            SUBLT   R2, R0, R2

mult_loop__ 
            CMP     R1, #0
            BEQ     mult_done__

            ANDS    R3, R1, #1
            ADDNE   R0, R0, R2
            LSL     R2, R2, #1
            ASR     R1, R1, #1
            B       mult_loop__

mult_done__ 
            MOV     R15, R14
			
; Divides two integers,  R0 by R1.  Returns the result in R0 	
; int DIVIDE(int R0, int R1);
; clobbers registers: R0, R1, R2, R3

DIVIDE      
            EOR     R3, R0, R1
            ASR     R3, R3, #31
            MOV     R2, R0
            MOV     R0, #0

            CMP     R2, #0
            SUBLT   R2, R0, R2

            CMP     R1, #0
            SUBLT   R1, R0, R1

div_loop__  

            CMP     R2, R1
            BLT     div_done__

            SUB     R2, R2, R1
            ADD     R0, R0, #1
            B       div_loop__

div_done__  
            MOV     R1, #0
            CMP     R3, #0
            SUBNE   R0, R1, R0

            MOV     R15, R14

; Divides two integers,  R0 by R1.  Returns the remainder in R0 	
; int MODULO(int R0, int R1);
; clobbers registers: R0, R1, R2, R3

MODULO      
            MOV     R3, #0

            CMP     R1, #0
            SUBLT   R1, R3, R1

            CMP     R0, #0
            SUBLT   R0, R3, R0
            MOVLT   R3, #1
mod_loop__  
            CMP     R0, R1
            BLT     div_done__

            SUB     R0, R0, R1
            B       mod_loop__


			
			
			