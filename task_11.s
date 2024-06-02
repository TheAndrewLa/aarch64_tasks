.global main

.include "utils/common.s"

; Lseek modes
.equ lseek_start, 0
.equ lseek_current, 1
.equ lseek_end, 2

; Macro for lseek
.macro lseek fd, offset, mode
    mov x0, \fd
    mov x1, \offset
    mov x2, \mode
    syscall 199
.endm

; int open(const char* filename)
fopen:
    mov x1, 2 ; Setting opening flag to read & write
    syscall 5
    ret

; void fclose(int fd)
fclose:
    syscall #6
    ret

; unsigned long flength(int fd)
flength:
    mov x19, x0 ; Saving file descryptor

    lseek x19, #0, lseek_current  ; Getting intial position in file
    mov x20, x0                   ; Saving initial position in file

    lseek x19, #0, lseek_end      ; Getting length
    mov x21, x0                   ; Saving length

    lseek x19, x20, lseek_start   ; Restoring intial position in file

    mov x0, x21
    ret

; void fread(int fd, char* buffer, unsigned long size)
fread:
    syscall #3
    ret

main:
    subs xzr, x0, #2  ; Little prolog of function
    b.eq .body        ; Check if argc is equal to 2
    exit 1            ; If not => exit with nonzero code

    .body:
    ldr x0, [x1]  ; Reading pointer to filename to x0
    mov x19, x0   ; Saving filename
    bl fopen      ; Opening file

    mov x20, x0   ; Saving file-descriptor

    bl flength    ; Calling flength
    mov x21, x0   ; Saving length of file

    sbrk x0       ; Allocating memory to file

    mov x0, x20   ; Setting file descriptor
    mov x1, x0    ; Setting buffer
    mov x2, x21   ; Setting length

    bl fread      ; Reading file content

    ; x0 = pointer to allocated buffer with written data

    mov x0, x20   ; Restoring file-descriptor
    bl fclose     ; Closing file

    exit 0
