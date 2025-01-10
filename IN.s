ss               dcb     57, 37, 52, 0
                 adr     r0, ss
INFIX_TO_POSTFIX 
                 MOV     R8, #0
                 MOV     R10, R0
STR2             DCD     0
                 ADR     R1, STR2
                 BL      CONCAT
                 MOV     R4, R0; R4 = POINTER TO STR IN MEMORY
                 ;R7     = NEW SPACE
                 MOV     R0, R10
                 ADR     R1, STR2
                 BL      CONCAT
                 MOV     R7, R0;


                 ;MOV    R4, R0; R4 = POINTER TO STR IN MEMORY
                 BL      STRLEN
                 MOV     R5, R0; = LEN
                 MOV     R6, #0; i=0
LOOP1            
                 CMP     R6, R5
                 BEQ     END_LOOP1
                 STRB    R8, [R7, R6] ; allocate and set to X
                 STRB    R8, [R10, R6] ; allocate and set to X

                 ;       END OF LOOP
                 ADD     R6, R6, #1;i++
                 B       LOOP1
END_LOOP1        



                 MOV     R6, #0; i=0
                 MOV     R9, #0; X=0
                 MOV     R11, #0; Y=0
LOOP2            
                 CMP     R6, R5
                 BEQ     END_LOOP2
                 LDRB    R8, [R4, R6]

                 ;IF     '('
                 CMP     R8, #40
                 STRBEQ  R8, [R10, R11]
                 ADDEQ   R11,R11,#1
                 BEQ     ENDIF1

                 ;ELSE   IF ')'
                 CMP     R8, #41
                 MOVEQ   R8, #0
                 SUBEQ   R11,R11,#1
                 BLEQ    LOOP4

                 ;IF     DIGIT ADD TO HEAP
                 CMP     R8, #48
                 STRBGE  R8, [R7, R9]
                 ADDGE   R9,R9,#1
                 BGE     ENDIF1

                 ;IF     OPERATOR
                 ;CHECK  IF THE STACK IS EMPTY
                 CMPLT   R11, #0; IF STACK IS EMPTY
                 STRBEQ  R8, [R10, R11]
                 ADDEQ   R11,R11,#1
                 BEQ     ENDIF1
                 SUBCS   R12,R11,#1
                 LDRBCS  R12, [R10, R12]
                 BLCS    IS_HIGHER

ENDIF1           
                 ;       END OF LOOP
                 ADD     R6, R6, #1;i++
                 B       LOOP2
END_LOOP2        
LOOP3            
                 CMP     R11, #0
                 BLT     END_LOOP3
                 LDRB    R8, [R10, R11]
                 CMP     R8, #0
                 SUBEQ   R11, R11, #1
                 BEQ     LOOP3
                 STRB    R11, [R10, R11]
                 STRB    R8, [R7, R9]
                 ADD     R9,R9,#1
                 SUB     R11, R11, #1;i++
                 B       LOOP3
END_LOOP3        
                 MOV     R0,R7
                 ;;;;;;------------INFIX_TO_POSTFIX-----------
EVALUATING       ;END;;DELETE
                 BL      STRLEN
                 MOV     R5,R0
                 MOV     R6, #0
                 MOV     R9, #0
                 MOV     R12, #0
LOOP5            
                 CMP     R6,R5
                 BEQ     END_LOOP5
                 LDRB    R8, [R7, R6]
                 ;IF     DIGIT ADD TO stack
                 CMP     R8, #48
                 SUBGE   R8,R8,#48
                 STRBGE  R8, [R10, R9]
                 ADDGE   R9,R9,#1
                 BGE     ENDIF5


                 ;IF     +
                 CMP     R8, #43
                 BLEQ    POP
                 ADDEQ   R8,R0,R1
                 STRBEQ  R8, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5
                 ;IF     -
                 CMP     R8, #45
                 BLEQ    POP
                 SUBEQ   R8,R0,R1
                 STRBEQ  R8, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5
                 ;IF     *
                 CMP     R8, #42
                 BLEQ    POP
                 BLEQ    MULTIPLY
                 STRBEQ  R0, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5
                 ;IF     /
                 CMP     R8, #47
                 BLEQ    POP
                 BLEQ    DIVIDE
                 STRBEQ  R0, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5
                 ;IF     %
                 CMP     R8, #37
                 BLEQ    POP
                 BLEQ    MODULO
                 STRBEQ  R0, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5


ENDIF5           
                 ADD     R6, R6, #1;i++
                 B       LOOP5
END_LOOP5        


THE_END          
                 LDRB    R0, [R10]
                 END
                 ;;;;;;------------END OF MAIN-----------
                 ;;;;;;----------OTHER FUNCTION----------

POP              

                 SUBEQ   R9,R9,#1
                 LDRBEQ  R1, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R0, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 MOV     R15,R14

IS_HIGHER        
                 ;IF     THEY ARE EQUAL ADD R8
                 CMP     R8, R12
                 STRBEQ  R8, [R7, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     END_OF_IS_HIGHER

                 ;ELSE   IF R8= + and R12= * or / or %
                 CMP     R12, #43
                 bne     end_else
                 CMP     R8, #42
                 BEQ     ADD_R8
                 CMP     R8, #47
                 BEQ     ADD_R8
                 CMP     R8, #37
                 BEQ     ADD_R8
end_else         ;ELSE   IF R8= - and R12= * or / or %
                 CMP     R12, #45
                 bne     end_else2
                 CMP     R8, #42
                 BEQ     ADD_R8
                 CMP     R8, #47
                 BEQ     ADD_R8
                 CMP     R8, #37
                 BEQ     ADD_R8

end_else2        ;ELSE   IF R12=(
                 CMP     R12, #40
                 BEQ     ADD_R8

                 B       ADD_R12

ADD_R8           
                 STRB    R8, [R10, R11]
                 ADD     R11,R11,#1
                 B       END_OF_IS_HIGHER

ADD_R12          
                 STRB    R12, [R7, R9]
                 ADD     R9,R9,#1
                 SUB     R11,R11,#1
                 STRB    R8, [R10, R11]
                 ADD     R11,R11,#1
                 B       END_OF_IS_HIGHER


END_OF_IS_HIGHER 
                 MOV     R15, R14


LOOP4            
                 LDRB    R12, [R10, R11]
                 CMP     R12, #40
                 STRBEQ  R8, [R10, R11]
                 SUBEQ   R11, R11, #1;i--
                 BEQ     BEFORE_END_LOOP4
                 STRB    R12, [R7, R9]
                 ADD     R9,R9,#1
                 STRB    R8, [R10, R11]
                 SUB     R11, R11, #1;i--
                 B       LOOP4

END_LOOP4        
                 ADD     R11,R11,#1
                 B       ENDIF1
BEFORE_END_LOOP4 
                 CMP     R11, #0
                 ;SUBGE  R11, R11, #1;i--
                 LDRBGE  R12, [R10, R11]
                 STRBGE  R12, [R7, R9]
                 ADDGE   R9,R9,#1
                 STRBGE  R8, [R10, R11]
                 SUBGE   R11, R11, #1;i--
                 B       END_LOOP4


                 ;UTIL.S
STRLEN           
                 MOV     R1, R0

STRLEN_L1__      
                 LDRB    R2, [R1], #1
                 CMP     R2, #0
                 BNE     STRLEN_L1__

                 SUB     R0, R1, R0
                 SUB     R0, R0, #1
                 MOV     R15, R14


                 ;       allocates and returns a string that is the concatenation of strings passed into R0 & R1
                 ;       char *CONCAT(char *R0, char *R1);
                 ;       clobbers registers: R0, R1, R2, R3

CONCAT           
                 STMFD   SP!, {R14,R11}
                 MOV     R11, SP
                 SUB     SP, SP, #16
                 STR     R0, [R11, #-8]
                 STR     R1, [R11, #-12]
                 BL      STRLEN
                 MOV     R3, R0
                 LDR     R0, [R11, #-12]
                 BL      STRLEN
                 ADD     R0, R0, R3
                 ADD     R0, R0, #1
                 BL      ALLOCATE
                 STR     R0, [R11, #-16]
                 LDR     R1, [R11, #-8]
CONCAT_1__       
                 LDRB    R2, [R1], #1
                 STRB    R2, [R0], #1
                 CMP     R2, #0
                 BNE     CONCAT_1__
                 SUB     R0, R0, #1
                 LDR     R1,[R11,#-12]
CONCAT_2__       
                 LDRB    R2, [R1], #1
                 STRB    R2, [R0], #1
                 CMP     R2, #0
                 BNE     CONCAT_2__
                 LDR     R0, [R11, #-16]
                 ADD     SP, SP, #16
                 LDMFD   SP!, {R14,R11}
                 MOV     R15, R14


                 ;       If possible, allocates R0 bytes from free memory. Returns the pointer or NULL.
                 ;       void *ALLOCATE(unsigned int R0);
                 ;       clobbers registers: R0, R1, R2, R3

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

FREE_PTR__       DCD     0
HEAP__           DCD     0


                 ;       Multiplies two integers in R0 & R1. Returns the result in R0
                 ;       int MULTIPLY(int R0, int R1);
                 ;       clobbers registers: R0, R1, R2, R3
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

                 ;       Divides two integers, R0 by R1. Returns the result in R0
                 ;       int DIVIDE(int R0, int R1);
                 ;       clobbers registers: R0, R1, R2, R3

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

                 ;       Divides two integers, R0 by R1. Returns the remainder in R0
                 ;       int MODULO(int R0, int R1);
                 ;       clobbers registers: R0, R1, R2, R3

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

