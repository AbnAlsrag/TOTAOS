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
    
    cmp al, 13
    je .enter

    mov bl, 2
    mov ah, 0Eh
    mov bh, 0
    int 0x10
    cmp al, 8
    je .back_space
    jmp .done

    .back_space:
        mov al, 0
        mov ah, 0Ah
        mov bh, 0
        mov cx, 1
        int 0x10
        jmp .done

    .enter:
        .msg_endl: db ENDL, 0
        mov si, .msg_endl
        call puts
        jmp .done

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

    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello, World!', ENDL, 0