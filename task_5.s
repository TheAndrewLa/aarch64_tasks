.text
.global main

.include "utils/common.s"

.macro expect_eq val1, val2, expected
    mov x0, \val1
    mov x1, \val2
    bl multiply

    mov x1, \expected

    cmp x0, x1
    b.ne failed

    adr x19, passed_msg
    print_string x19, #13
.endm

.align 0

passed_msg: .ascii "Test passed!\n"
failed_msg: .ascii "Test failed!\n"

.align 2

failed:
    adr x19, failed_msg
    print_string x19, #13

    exit 1

main:
    expect_eq #10, #10, #100

	expect_eq #0, #10, #0
	expect_eq #10, #0, #0

	expect_eq #123, #456, #56088
	expect_eq #13, #19, #247

    exit 0

; multiply(int x0, int x1) -> x0 = x0 * x1 (unsigned numbers)
multiply:
    mov x6, #0
    mov x4, #31

    .loop:
    mov x2, #0

    lsr x2, x1, x4
    and x2, x2, #1

    neg x2, x2

    lsl x5, x0, x4

    and x5, x5, x2
    add x6, x6, x5

    subs x4, x4, #1
    b.pl .loop

    mov x0, x6
    ret
