;zas     segment stack
    ;        db      256 dup(?) 
;zas ends

strsize EQU 64

dat segment
    date    db  'dd:mm:rrrr$'
    nl          db 10,13,'$' 
    Cadena1     DB 13,10, 'System datetime: $'
    Cadena2     DB 13,10, 'PRUEBA: $'
    Salto       DB 13,10, ' $'
    India       DB 13,10, 'India: $'
    Alemania    DB 13,10, 'Alemania: $'
    EEUU        DB 13,10, 'EEUU: $'
    Argentina   DB 13,10, 'Argentina: $'
    Japon       DB 13,10, 'Japon: $'
    YEAR        DW ?
    MONTH       DB ?
    DAY         DB ?
    WEEKDAY     DB ?
    HOUR        DB ?
    MINUTE      DB ?
dat ends

code segment
    assume cs:code, ds:dat;ss:zas, 

get_date proc
        mov ah,2ah
        int 21h
        mov al,dl
        call convert
        mov [bx],ax
        mov al,dh
        call convert
        mov [bx+3],ax
        mov al,100
        xchg ax,cx
        div cl
        mov ch,ah
        call convert
        mov [bx+6],ax
        mov al,ch
        call convert
        mov [bx+8],ax    
        ret
        endp          

convert proc
        push dx
        mov ah,0
        mov dl,10
        div dl
        or ax, 3030h
        pop dx
        ret 
        endp
;---------------------------------------------------------------    
start:
        mov ax, seg dat
        mov ds,ax

        LEA BX, date
        CALL get_date
        
        lea dx,Cadena1
        mov ah,09h
        int 21h

        lea dx,date
        mov ah,09h
        int 21h

Finish:
        mov ah, 4ch
        int 21h

code ends
        end start