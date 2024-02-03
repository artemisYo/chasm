global _start

section .text

%define stdin 0
%define stdout 1
%define sys_read 0
%define sys_write 1

struc string
	.data: resq 1
	.len:  resq 1
endstruc

;  rcx: ---
;  rbx: ---
;  rsi: string str
; -> rax: int  count
str_count_digits:
	xor rax, rax
	mov rcx, [rsi + string.len]
	mov rsi, [rsi + string.str]
str_count_digits_loop:
    jrcxz str_count_digits_done
	mov bl, [rsi + rax]
	sub bl, '0'
	cmp bl, 9
	ja count_digits_done
	inc rax
	dec rcx
str_count_digits_done:
	ret

;  rcx: ---
;  rsi: char *data
; -> rax: int count
count_digits:
    xor rax, rax
count_digits_loop:
    mov cl, [rsi + rax]
    sub cl, '0'
	cmp cl, 9
	ja count_digits_done
	inc rax
	jmp count_digits_loop
count_digits_done:
    ret

; TODO!
;  rsi: string str
str_get_input:
    mov rdx, [rsi + string.len]
    mov rsi, [rsi + string.str]
    mov rax, sys_read
    mov rdi, stdin
    syscall
    ret

;  rdi: ---
;  rsi: char *buf
;  rdx: int   count
; -> rax: int count
get_input:
    mov rax, sys_read
    mov rdi, stdin
    syscall
    ret

;  rdi: ---
;  rsi: char *buf
;  rdx: int   count
; -> rax: int count
print_out:
    mov rax, sys_write
    mov rdi, stdout
    syscall
    ret

_start:
    lea rsi, [rsp-24]
    mov rdx, 24
    call get_input
    call count_digits
    mov rdx, rax
    call print_out
    jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall

; rdi: int code
exit_with:
    mov rax, 60
    syscall

section .rodata

