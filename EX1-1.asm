.MODEL TINY
.STACK 100
.CODE
START: MOV AX,@DATA
MOV DS,AX
MOV ES,AX
NOP
MOV CX,100H
MOV SI,3000H
MOV DI,6000H
CLD
REPE MOVSB
MOV CX,100H
MOV SI,3000H
MOV DI,6000H
REPE CMPSB
JNE ERROR
TRUE: JMP $
ERROR: JMP $

END START
