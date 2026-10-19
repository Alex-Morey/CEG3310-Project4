.ORIG x3000

MAIN
    LD R6, STACK_START

    LD R0, ARRAY_SIZE
    ADD R6, R6, #-1
    STR R0, R6, #0

    LEA R0, ARRAY
    ADD R6, R6, #-1
    STR R0, R6, #0

    JSR SUMOFSQUARES

    LDR R0, R6, #0
    ADD R6, R6, #3

    ST R0, TOTAL
    HALT

ARRAY_SIZE  .FILL #5
ARRAY       .FILL #2
            .FILL #3
            .FILL #5
            .FILL #0
            .FILL #1
TOTAL       .BLKW #1
STACK_START .FILL xF000


SUMOFSQUARES
    ; Create stack frame
    ADD R6, R6, #-1
    ADD R6, R6, #-1
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R5, R6, #0
    ADD R5, R6, #0

    ; Reserve and initialize locals
    ADD R6, R6, #-2
    AND R0, R0, #0
    STR R0, R5, #-1
    STR R0, R5, #-2

SOS_LOOP
    ; Compare counter and arraySize
    LDR R0, R5, #-1
    LDR R1, R5, #4
    NOT R1, R1
    ADD R1, R1, #1
    ADD R2, R0, R1
    BRzp SOS_DONE

    ; Get a[counter]
    LDR R3, R5, #3
    ADD R3, R3, R0
    LDR R4, R3, #0

    ; Push argument and call square
    ADD R6, R6, #-1
    STR R4, R6, #0
    JSR SQUARE

    ; Get result and clean stack
    LDR R0, R6, #0
    ADD R6, R6, #2

    ; Update sum
    LDR R1, R5, #-2
    ADD R1, R1, R0
    STR R1, R5, #-2

    ; Increment counter
    LDR R0, R5, #-1
    ADD R0, R0, #1
    STR R0, R5, #-1

    BRnzp SOS_LOOP

SOS_DONE
    ; Place sum in return slot
    LDR R0, R5, #-2
    STR R0, R5, #2

    ; Restore frame and return
    ADD R6, R5, #0
    LDR R5, R6, #0
    LDR R7, R6, #1
    ADD R6, R6, #2
    RET


SQUARE
    ; Create stack frame
    ADD R6, R6, #-1
    ADD R6, R6, #-1
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R5, R6, #0
    ADD R5, R6, #0

    ; Reserve product variable
    ADD R6, R6, #-1
    AND R0, R0, #0
    STR R0, R5, #-1

    ; Load x and initialize counter
    LDR R0, R5, #3
    ADD R1, R0, #0
    AND R2, R2, #0

SQ_LOOP
    ADD R1, R1, #0
    BRnz SQ_DONE

    ADD R2, R2, R0
    ADD R1, R1, #-1
    BRnzp SQ_LOOP

SQ_DONE
    ; Save product and return value
    STR R2, R5, #-1
    LDR R0, R5, #-1
    STR R0, R5, #2

    ; Restore frame and return
    ADD R6, R5, #0
    LDR R5, R6, #0
    LDR R7, R6, #1
    ADD R6, R6, #2
    RET

.END
