global _start

section .text

%define stdin 0
%define stdout 1
%define sys_read 0
%define sys_write 1

;;;  trash rbx
;;;  trash rcx
;;;  trash rdi
;;;  trash rsi: char *str
;;;  trash rdx: int len
;;; -> rax: int num
str_parse_int:
    mov rdi, 10                 ; const 10 for mul
    xor rax, rax                ; rax = 0
    xor rbx, rbx                ; rbx = 0
    mov rcx, rdx                ; relocate len
str_parse_loop:
    jrcxz str_parse_end         ; if len == 0 {return}
    mov bl, [rsi]               ; bl = *str
    sub bl, '0'
    mul rdi                     ; rax *= 10
    add rax, rbx                ; rax += bl - '0'
    inc rsi                     ; str++
    dec rcx                     ; len--
    jmp str_parse_loop
str_parse_end:
    ret
    
;;;  trash rbx
;;;  rsi: char *str
;;;  rdx: int   len
;;; -> rax: int  count
str_count_digits:
    xor rax, rax                ; rax = 0
str_count_digits_loop:
    cmp rax, rdx                ; if rax >= len
    jae str_count_digits_done   ;     {return}
	mov bl, [rsi + rax]         ; bl = str[rax]
	sub bl, '0'                 ; if bl < '0'
	cmp bl, 9                   ; or bl > '9'
	ja str_count_digits_done    ;     {return}
	inc rax                     ; rax++
    jmp str_count_digits_loop
str_count_digits_done:
	ret

;;;  trash rdi
;;;  rsi: char *str
;;;  rdx: int   len
;;; -> rax: int count
str_get_input:
    mov rax, sys_read           ; sys_read -> rax : int
    mov rdi, stdin
    syscall
    ret

;;;  trash rdi
;;;  rsi: char *str
;;;  rdx: int   len
;;; -> rax: int count
str_print_out:
    mov rax, sys_write          ; sys_write -> rax : int
    mov rdi, stdout
    syscall
    ret

_start:
    push rbp
    mov rbp, rsp
    sub rsp, 24
    lea rsi, [rsp]              ; rsi = alloca(24)
    mov rdx, 24                 ; rdx = 24
    call str_get_input          ; rdx = strlen(rsi)
    mov rdx, rax
    call str_count_digits       ; rdx = count_digits(rsi)
    mov rdx, rax
    push rdx
    push rsi
    call str_parse_int
    pop rsi
    pop rdx
    mov rdi, rax
    leave
    jmp exit_with

exit:
    mov rax, 60
    mov rdi, 0
    syscall

; rdi: int code
exit_with:
    mov rax, 60
    syscall

section .rodata

