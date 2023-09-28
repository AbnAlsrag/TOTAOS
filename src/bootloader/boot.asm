org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp main

graphic_init:
    mov ah, 00h
    mov al, 12h
    int 0x10

    ret

draw_pexil:
    push ax
    push bx

    mov ah, 0Ch
    mov bh, 0
    int 0x10

    pop bx
    pop ax

    ret

draw_rect:
    .loopy:
        push cx
        .loopx:
            call draw_pexil

            inc cx
            cmp cx, di
            jne .loopx

        pop cx
        inc dx
        cmp dx, bx
        jne .loopy

    ret

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

read_char:
    push cx
    push ax

    mov bh, 00h
    int 0x16
    mov cl, al

    pop ax

    mov al, cl

    pop cx

    ret

write_char:
    push ax
    push bx
    
    mov bl, 2
    mov ah, 0Eh
    mov bh, 0
    int 0x10
    cmp al, 8
    je .back_space
    jmp .done

    .back_space:

    mov ah, 0Ah
    mov al, 0
    mov bh, 0
    mov cx, 1
    int 0x10

    .done:

    pop bx
    pop ax
    
    ret

main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    call graphic_init

    mov al, 15

    mov di, 100
    mov bx, 50
    mov cx, 10
    mov dx, 10

    call draw_rect
    
    .loop:
        call read_char
        call write_char
        jmp .loop

    hlt

.halt:
    jmp .halt

times 510-($-$$) db 0
dw 0AA55h