;ELSE   IF R8=% and R12=-
                 CMP     R8, #37
                 CMPEQ   R12, #45
                 BEQ     ADD_R8
                 ;ELSE   IF R8=% and R12=+
                 CMP     R8, #37
                 CMPEQ   R12, #43
                 BEQ     ADD_R8
                 ;ELSE   IF R8=* and R12=-
                 CMP     R8, #42
                 CMPEQ   R12, #45
                 BEQ     ADD_R8
                 ;ELSE   IF R8=* and R12=+
                 CMP     R8, #42
                 CMPEQ   R12, #43
                 BEQ     ADD_R8
                 ;ELSE   IF R8=/ and R12=-
                 CMP     R8, #47
                 CMPEQ   R12, #45
                 BEQ     ADD_R8
                 ;ELSE   IF R8=/ and R12=+
                 CMP     R8, #47
                 CMPEQ   R12, #43
                 BEQ     ADD_R8
                 ;ELSE   IF R12=(
                 CMP    R12, #40
                 BEQ    ADD_R8
                 
;ELSE   IF R8=+ and R12=* ot / or %
CMP   R12, #43
bne end_else
CMP     R8, #42
BEQ     ADD_R8
CMP     R8, #47
BEQ     ADD_R8
CMP     R8, #37
BEQ     ADD_R8

end_else
;ELSE   IF R8=- and R12=* ot / or %
CMP   R12, #43
bne end_else2
CMP     R8, #42
BEQ     ADD_R8
CMP     R8, #47
BEQ     ADD_R8
CMP     R8, #37
BEQ     ADD_R8

end_else2
;ELSE   IF R12=(
                 CMP    R12, #40
                 BEQ    ADD_R8









