.global main

; unsigned long strchr(char* buffer, char symbol)
strchr:
    ldr x2, [x0], #1         ; Getting first symbol from string
    and x2, x2, #0xFF        ; Only one byte
    and x1, x1, #0xFF        ; 

    .strchr_loop:
    cbz x2, .end             ; Check for '\0'

    cmp x2, x1               ; Check for given symbol
    b.eq .found

    ldr x2, [x0, #1]!        ; Select new char from buffer & Increment of 'i' pointer
    and x2, x2, #0xFF        ; Only one byte
    b .strchr_loop

    .end:
    mov x0, #0               ; Setting result to nullptr
    ret

    .found:
    ret

; I dont know why to count lines with strchr (because it will be recursive algorithm)
; This is easier way without recursion (just modified strchr)

; unsigned long count_lines(char* buffer)
count_lines:
    mov x2, #0              ; Setting counter to zero

    .count_lines_loop:
    ldr x1, [x0], #1        ; Getting symbol from 'i' pointer
    and x1, x1, #0xFF       ; Only one byte

    cbz x1, .return         ; Checking that buffer is not empty

    cmp x1, #10             ;
    cset x3, eq             ; Set x3 to 1 if symbol is LF

    add x2, x2, x3          ; Add 0 or 1 to counter
    b .count_lines_loop

    .return:
    add x0, x2, #1    ; N(Lines) = N(LF) + 1
    ret
