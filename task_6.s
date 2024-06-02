; Comment to make this file able to be included (in task_7)

; .global main

; .macro expect_eq val, expected, func
;       mov x0, \val
;       bl \func
;   
;       mov x1, \expected
;   
;       cmp x0, x1
;       b.ne failed
;   
;       adr x19, passed_msg
;       print_string x19, #13
; .endm

; .align 0
;   passed_msg: .ascii "Test passed!\n"
;   failed_msg: .ascii "Test failed!\n"

; failed:
;     adr x19, failed_msg
;     print_string x19, #13
; 
;     exit 1

; main:
;   expect_eq 123, 12, div10
;   expect_eq 123, 3, mod10
;
;   expect_eq 89, 8, div10
;   expect_eq 89, 9, mod10
;
;   expect_eq 600, 60, div10
;   expect_eq 600, 0, mod10
;
;   expect_eq 12345, 1234, div10
;   expect_eq 12345, 5, mod10
;
;   exit 0

.include "utils/common.s"

; mul10(x0) -> x0 = x0 * 10 (unsigned numbers)
mul10:
    mov x1, x0
    
    lsl x0, x0, #3 ; * 8
    add x0, x0, x1 ; + x
    add x0, x0, x1 ; + x

    ret

; div10(x0) -> x0 = x0 / 10 (unsigned numbers)
div10:
    ; Recursion fallback
    subs xzr, x0, #10
    b.pl .div10_body

    mov x0, #0
    ret

    .div10_body:
    push_reg lr
    push_2reg x19, x20

    ; Using this formula with correction
    ; x / 10 = ((x / 8) - ((x / 4) / 10))

    mov x20, x0 ; Storing initial value in saved register

    lsl x19, x0, #3 ; division by 8
    lsl x0, x0, #2 ; division by 4

    bl div10

    sub x0, x19, x0
    mov x1, x0

    bl mul10

    cmp x20, x0 ; Correction (-1 or nothing)
    cset x3, lo ; x3 = 1 if (x20 < x0) else 0

    subs x0, x1, x3

    .return:
    pop_2reg x20, x19
    pop_reg lr
    ret

; mod10(x0) -> x0 = x0 % 10 (unsgined numbers)
mod10:
    push_2reg lr, x19
    push_2reg x19, x20
    push_reg x0

    bl div10
    bl mul10 
    pop_reg x1

    sub x0, x1, x0

    pop_2reg x20, x19
    pop_reg lr
    ret
