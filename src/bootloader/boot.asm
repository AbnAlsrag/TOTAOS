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
    
    hlt

.halt:
    jmp .halt

times 510-($-$$) db 0
dw 0AA55h