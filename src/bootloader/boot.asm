org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

disk_sectors_per_track: dw 18
disk_heads: dw 2

start:
    jmp main

;
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

; Convert LBA to CHS address
;   Parameters:
;       ax: LBA
;   Return:
;       cx [0 - 5]: sectors
;       cx [6 - 15]: cylinder
;       dh: head
lba_to_chs:
    push ax
    push dx

    xor dx, dx
    div word [disk_sectors_per_track]
    inc dx
    mov cx, dx

    xor dx, dx
    div word [disk_heads]

    mov dh, dl
    mov ch, al
    shl ah, 6
    or cl, ah

    pop dx
    mov dl, al
    pop ax

    ret

; Reads sector from disk
;   Parameters:
;       ax: LBA address
;       cl: Number of sectors to read (up to 128)
;       dl: Drive number
;       es, bx: Destination address
read_sector:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx
    call lba_to_chs
    pop ax

    mov ah, 02h
    mov di, 5
    
    .retry:
        pusha
        stc
        int 0x13

        jnc .done
        
        popa
        call disk_reset

        dec di
        cmp di, 0
        jg .retry
    .failed:
        jmp disk_read_error

    .done:
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Resets the disk controller
;   Parameters:
;       dl: drive number
disk_reset:
    pusha
    mov ah, 0
    stc
    int 0x13
    jnc disk_read_error
    popa
    ret

main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    mov dl, 0
    mov ax, 1
    mov cl, 1
    mov bx, 0x7E00
    call read_sector
    
    jmp 0x7E00

    jmp halt

disk_read_error:
    mov si, .msg_error
    call puts

    .msg_error: db "Can't read sector from disk", ENDL, 0

wait_key_and_reboot:
    mov ah, 0
    int 16h
    jmp 0FFFh:0

halt:
    cli
    hlt

times 510-($-$$) db 0
dw 0AA55h