BL      STRLEN
                 MOV     R5,R0
                 MOV     R6, #0
                 MOV     R9, #0
                 MOV     R12, #0
LOOP5            
                 CMP     R6,R5
                 BEQ     END_LOOP5
                 LDRB    R8, [R7, R6]
                 ;IF     DIGIT ADD TO HEAP
                 CMP     R8, #48
                 SUBGE   R8,R8,#48
                 STRBGE  R8, [R10, R9]
                 ADDGE   R9,R9,#1
                 BGE     ENDIF5

                 ;IF     +
                 CMP     R8, #43
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R1, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R2, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 ADDEQ   R8,R1,R2
                 STRBEQ  R8, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5
                 ;IF     -
                 CMP     R8, #45
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R1, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R2, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 SUBEQ   R8,R2,R1
                 STRBEQ  R8, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5
                 ;IF     *
                 CMP     R8, #42
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R0, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R1, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 BLEQ    MULTIPLY
                 STRBEQ  R0, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5
                 ;IF     /
                 CMP     R8, #47
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R1, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 SUBEQ   R9,R9,#1
                 LDRBEQ  R0, [R10, R9]
                 STRBEQ  R12, [R10, R9]
                 BLEQ    DIVIDE
                 STRBEQ  R0, [R10, R9]
                 ADDEQ   R9,R9,#1
                 BEQ     ENDIF5



ENDIF5           
                 ADD     R6, R6, #1;i++
                 B       LOOP5
END_LOOP5        



                 ;------------ERRORS--------------
                 ;1-EVALUATION IS WRONG
                 ;--------------------------------



THE_END          
                 LDRB    R0, [R10]
                 END