org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

jmp main

puts:
    push si
    push ax

    .loop:
        lodsb
        or al, al
        jz .done

        mov ah, 0Eh
        mov bh, 0
        int 0x10
        
        jmp .loop

    .done:
        pop ax
        pop si
        ret

main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    mov si, msg_hello
    mov eax, 5
    .loop:
        call puts
        dec eax
        jz .done
        jmp .loop
    .done:

    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello, World!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h