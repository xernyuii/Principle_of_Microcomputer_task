              .MODEL     TINY
EXTRN         InitKeyDisplay:NEAR,Display8:NEAR
IO8259_0      EQU        0250H
IO8259_1      EQU        0251H
              .STACK     100
              .DATA
BUFFER        DB         8 DUP(?)
IRQ0_INT      DB         0
IRQ7_INT      DB         0
              .CODE
START:        MOV        AX,@DATA
              MOV        DS,AX
              MOV        ES,AX
              NOP
              CALL       InitKeyDisplay
              MOV        IRQ0_INT,00H
              MOV        IRQ7_INT,00H
              CALL       Init8259
              CALL       WriIntver
              CALL       LedDisplay
              STI
START1:       LEA        SI,Buffer
              CALL       Display8
              JMP        START1
LedDisplay    PROC       NEAR
              PUSH       AX
              MOV        AL,IRQ0_INT
              OR         AL,IRQ0_INT
              JZ         LedDisplay1
              ADD        AL,IRQ7_INT
LedDisplay1:  MOV        Buffer,AL
              MOV        Buffer+1,10H
              MOV        Buffer+2,10H
              MOV        Buffer+3,10H
              MOV        Buffer+4,10H
              MOV        Buffer+5,10H
              MOV        Buffer+6,10H
              MOV        AL,IRQ7_INT
              MOV        Buffer+7,AL
              POP        AX
              RET
LedDisplay    ENDP
Init8259      PROC       NEAR
              MOV        DX,IO8259_0
              MOV        AL,13H
              OUT        DX,AL
              MOV        DX,IO8259_1
              MOV        AL,08H
              OUT        DX,AL
              MOV        AL,09H
              OUT        DX,AL
              MOV        AL,7EH
              OUT        DX,AL
              RET
Init8259      ENDP
DELAY         PROC       NEAR
              PUSH       SI
              PUSH       CX
              PUSH       AX
              MOV        CX,100
A3:           LEA        SI,Buffer
              CALL       Display8
              LOOP       A3
              POP        AX
              POP        CX
              POP        SI
              RET
DELAY         ENDP
IRQ0:         PUSH       DX
              PUSH       AX
              INC        IRQ0_INT
              CALL       LedDisplay
              STI
              CALL       DELAY
              DEC        IRQ0_INT
              CALL       LedDisplay
              MOV        DX,IO8259_0
              MOV        AL,20H
              OUT        DX,AL
              POP        AX
              POP        DX
              IRET

IRQ7:         PUSH       DX
              PUSH       AX
              INC        IRQ7_INT 
              CALL       LedDisplay
              STI
              CALL       DELAY
              DEC        IRQ7_INT
              CALL       LedDisplay
              MOV        DX,IO8259_0
              MOV        AL,20H
              OUT        DX,AL
              POP        AX
              POP        DX
              IRET

WriIntver     PROC       NEAR
              PUSH       ES
              MOV        AX,0
              MOV        ES,AX
              MOV        DI,20H
              LEA        AX,IRQ0
              STOSW
              MOV        AX,CS
              STOSW
              MOV        DI,20H+7*4
              LEA        AX,IRQ7
              STOSW
              MOV        AX,CS
              STOSW
              POP        ES
              RET
WriIntver     ENDP

              END        START
