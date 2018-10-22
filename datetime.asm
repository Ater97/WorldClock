
.Model small
.Data
MENUstr DB 10,13,'MENU$'
Option1str DB 10,13,'1. Show system date-time$'
Option2str  DB 10,13,'2. Enter utc format$'
Option3str  DB 10,13,'3. Show example countries$'
Option4str  DB 10,13,'4. Update date$'
Option5str  DB 10,13,'5. Analog display$'
AskExit DB 10,13,'6. Exit$'
AskOption DB 10,13, 'Enter the number of your choice: $'
ErrorMenu DB 10,13, ' o.O Please enter a valid option...$'
AskContinue DB 10,13,'Press anything to continue...$'
num1 db ?
;------------------Option1--------------------------------  
date    db  'dd:mm:rrrr$'
nl      db 10,13,'$' 
Op1str  DB 13,10, 'System datetime: $'
Monday db 13,10,'Monday$'
Tuesday db 13,10,'Tuesday$'
Wednesday db 13,10,'Wednesday$'
Thusday db 13,10,'Thusday$'
Friday db 13,10,'Friday$'
Saturday db 13,10,'Saturday$'
Sunday db 13,10,'Sunday$'
;------------------Option2-------------------------------- 
;------------------Option3-------------------------------- 
India       DB 13,10, 'a. India: $'
Alemania    DB 13,10, 'b. Alemania: $'
EEUU        DB 13,10, 'c. EEUU: $'
Argentina   DB 13,10, 'd. Argentina: $'
Japon       DB 13,10, 'e. Japon: $'

;------------------Option4-------------------------------- 
;------------------Option5------------------------------- 

;---------------------UTILITIES--------------------------
Salto       DB 13,10, ' $'
YEAR        DW ?
MONTH       DB ?
DAY         DB ?
WEEKDAY     DB ?
HOUR        DB ?
MINUTE      DB ?

Cadena2     DB 13,10, 'PRUEBA: $'
.code
programa:
    mov AX,@DATA
    mov DS,AX
;---------------------------------------------------------------    
start:
Menu:
    lea     DX,MENUstr
    call    PrintStr
    lea     DX,Option1str 
    call    PrintStr
    lea     DX,Option2str 
    call    PrintStr
    lea     DX,Option3str 
    call    PrintStr
    lea     DX,Option4str 
    call    PrintStr
    lea     DX,Option5str 
    call    PrintStr
    lea     DX,AskExit
    call    PrintStr
    lea     DX,AskOption
    call    PrintStr
    call    Readint
    cmp     num1,1
    je      Option1
    cmp     num1,2
    je      Option2
    cmp     num1,3
    je      Option3
    cmp     num1,4
    je      Option4
    cmp     num1,5
    je      Option5
    cmp     num1,6
    je      Finish
    call    CleanScreen
    lea     DX,ErrorMenu
    call    PrintStr
    jmp     Menu

;------------------Option1--------------------------------   
Option1:
    call    CleanScreen
    lea BX, date
    call get_date
    
    lea dx,Op1str
    call PrintStr
    lea dx,date
    call PrintStr
    xor dx,dx
    call PrintWeekDay
    ;mov dl,WEEKDAY
    ;call    Printint

DAY:
    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DL     ; Day is in DL
    AAM
    MOV BX,AX
    CALL DISP
    call Continue
;------------------Option2--------------------------------   
Option2:
    call    CleanScreen

    call Continue
;------------------Option3--------------------------------   
Option3:
    call    CleanScreen
    call Continue
;------------------Option4--------------------------------   
Option4:
    call    CleanScreen
    call Continue
;------------------Option5--------------------------------   
Option5:
    call    CleanScreen
    call Continue

Finish:
    mov ah, 4ch
    int 21h
;---------------------UTILITIES--------------------------
get__time proc
    mov ah,2ch
    int 21h
    ret
    endp
DISP proc
    mov dl,BH      ; Since the values are in BX, BH Part
    ADD dl,30H     ; ASCII Adjustment
    mov AH,02H     ; To Print in DOS
    int 21H
    mov dl,BL      ; BL Part 
    ADD dl,30H     ; ASCII Adjustment
    mov AH,02H     ; To Print in DOS
    int 21H
    RET
     endp

get_date proc
    mov ah,2ah
    int 21h
    mov WEEKDAY,al
    mov al,dl
    mov DAY,dl
    call convert
    mov [bx],ax
    mov al,dh
    mov MONTH,dh
    call convert
    mov [bx+3],ax
    mov al,100
    xchg ax,cx
    div cl
    mov ch,ah
    call convert
    mov [bx+6],ax
    mov al,ch
    mov YEAR,cx
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

PrintWeekDay proc
    cmp WEEKDAY,1
    je  mon
    cmp WEEKDAY,2
    je  tue
    cmp WEEKDAY,3
    je  wed
    cmp WEEKDAY,4
    je  thu
    cmp WEEKDAY,5
    je  fri
    cmp WEEKDAY,6
    je  sat
    cmp WEEKDAY,7
    je  sun
mon:
    lea dx,Monday
    call PrintStr
    ret
tue:
    lea dx,Tuesday
    call PrintStr
    ret
wed:
    lea dx,Wednesday
    call PrintStr
    ret
thu:
    lea dx,Thusday
    call PrintStr
    ret
fri:
    lea dx,Friday
    call PrintStr
    ret
sat:
    lea dx,Saturday
    call PrintStr
    ret
sun:
    lea dx,Sunday
    call PrintStr
    ret
    endp
;------------------------------
Continue proc
    lea     DX,AskContinue
    call    PrintStr
 waitl:          
    mov ah, 0bh;check for a key 
    int 21h
    cmp al,0
    je waitl
    xor ax,ax
    mov AH, 01h  
    int 21h
    call CleanScreen
    jmp Menu
    endp
CleanScreen proc
    mov al, 00
    mov ah, 00
    int 10h
    ret
    endp
Printint proc
    mov AH,02h ;print dl
    ADD dl,30h
    int 21h
    ret
    endp
PrintStr proc 
    mov AH, 09h ;PrintStr DX
    int 21h
    ret
    endp
Readint proc
    XOR AL,AL
    mov AH, 01h  
    int 21h 
    SUB AL,30h 
    mov num1, AL
    ret
    endp
Clean proc
    xor dx,dx
    xor ax,ax
    ret
    endp

;---------------------------------------------------------------
.STACK
END programa