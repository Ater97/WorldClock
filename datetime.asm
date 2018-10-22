
.Model compact
.Data
MENUstr DB 10,13,'MENU$'
Option1str DB 10,13,'1. Show system date-time$'
Option2str  DB 10,13,'2. Enter UTC format$'
Option3str  DB 10,13,'3. Show example countries$'
Option4str  DB 10,13,'4. Update date$'
Option5str  DB 10,13,'5. Analog display$'
AskExit DB 10,13,'6. Exit$'
AskOption DB 10,13, 'Enter the number of your choice: $'
ErrorMenu DB 10,13, ' o.O Please enter a valid option...$'
AskContinue DB 10,13,'Press anything to continue...$'
;------------------Option1--------------------------------  
date    db  'dd:mm:rrrr$'
nl      db 10,13,'$' 
Op1DateStr  DB 13,10, 'System date: $'
Op1TimeStr  DB 13,10, 'System time: $'
Monday db 'Monday $'
Tuesday db 'Tuesday $'
Wednesday db 'Wednesday $'
Thusday db 'Thusday $'
Friday db 'Friday $'
Saturday db 'Saturday $'
Sunday db 'Sunday $'
;------------------Option2-------------------------------- 
Op2str        db 13,10,'Enter the UTC format: $'
Op2Examplestr db 13,10,'Example UTC+05 or UTC-10$'
Op2Helpstr    db 13,10,'UTC$'
Op2Error      db 13,10,':s Please enter a valid format$'
;------------------Option3-------------------------------- 
India       DB 13,10, 'a. India: $'
Alemania    DB 13,10, 'b. Alemania: $'
EEUU        DB 13,10, 'c. EEUU: $'
Argentina   DB 13,10, 'd. Argentina: $'
Japon       DB 13,10, 'e. Japon: $'

;------------------Option4-------------------------------- 
Op4Timestr  DB 13,10,'Enter new time: $'
Op4Datestr  DB 13,10,'Enter new date: $'
;------------------Option5------------------------------- 

;---------------------UTILITIES--------------------------
Salto       DB 13,10, ' $'
YEAR        DW ?
MONTH       DB ?
DAY         DB ?
WEEKDAY     DB ?
HOUR        DB ?
MINUTE      DB ?
Seconds     DB ?
Entrada     db ?
PRUEBA1    DB 13,10, 'PRUEBA1: $'
PRUEBA2    DB 13,10, 'PRUEBA2: $'
num1        db ?
num2        db ?
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
    mov     num1, AL
    cmp     num1,1
    je      Option1
    cmp     num1,2
    je      Option2
    cmp     num1,3
    je      Option3beta
    cmp     num1,4
    je      Option4beta
    cmp     num1,5
    je      Option5beta
    cmp     num1,6
    je      Finish
    call    CleanScreen
    lea     DX,ErrorMenu
    call    PrintStr
    jmp     Menu
Finish:
    mov ah, 4ch
    int 21h
;------------------Option1--------------------------------   
Option1:
    call    CleanScreen
    lea BX, date
    call get_date
    
    lea dx,Op1DateStr
    call PrintStr       ;System date:
    call PrintWeekDay   ;display week day
    lea dx,date
    call PrintStr       ;display date
    lea dx, Op1TimeStr  ;System time:    
    call PrintStr
    call get_time       ;display time
    call Continue
;------------------Option2--------------------------------   
Option3beta:
jmp Option3beta1
Option4beta:
jmp Option4beta1
Option5beta:
jmp Option5beta1
Option2:
    call    CleanScreen
    lea     dx,Op2Examplestr
    call    PrintStr
    lea     dx,Op2str
    call    PrintStr
    lea     dx,Op2Helpstr
    call    PrintStr
    call    ReadChar
    mov     Entrada,al
    cmp     Entrada,2bh ;compare +
    je      plus
    cmp     Entrada,2dh ;compare -
    je      minus
    jmp     Error
    
plus:
    call    ReadTwoint ; number is in num1 & al
    lea     dx,Salto
    call    PrintStr
    call    utcProcedure ;add num1 to datetime

    call    Continue
minus:
    call    ReadTwoint ; number is in num1 & al
    lea     dx,Salto
    call    PrintStr
    ;convert num1 to negative, then do the same with plus case
    call    Continue  
Error:
    call    CleanScreen
    lea     dx,Op2Error
    call    PrintStr
    jmp     Option2
Option3beta1:
jmp Option3
Option4beta1:
jmp Option4
Option5beta1:
jmp Option5
;------------------Option3--------------------------------   
Option3:
    call    CleanScreen
    call Continue
;------------------Option4--------------------------------   
Option4:
    call    CleanScreen
    lea     dx,Op4Timestr
    call    PrintStr


    lea     dx,Op4Datestr
    call    PrintStr
    call    Continue
;------------------Option5--------------------------------   
Option5:
    call    CleanScreen
    call    Continue


;---------------------UTILITIES--------------------------
utcProcedure proc
;Hour Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov AL,CH     ; Hour is in CH
    add al,num1   ;
    mov num2, al  ;new hour in num2
    
    AAM
    mov BX,AX
    call DISP
    ;Minutes and seconds
    call    get_minutes
    lea     dx,Salto
    call    PrintStr

    ;Day Part
    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DL     ; Day is in DL
    AAM
    MOV BX,AX
    CALL DISP

    MOV DL,'/'
    MOV AH,02H    ; To Print / in DOS
    INT 21H

    ;Month Part
    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DH     ; Month is in DH
    AAM
    MOV BX,AX
    CALL DISP

    MOV DL,'/'    ; To Print / in DOS
    MOV AH,02H
    INT 21H

    ;Year Part
    MOV AH,2AH    ; To get System Date
    INT 21H
    ADD CX,0F830H ; To negate the effects of 16bit value,
    MOV AX,CX     ; since AAM is applicable only for AL (YYYY -> YY)
    AAM
    MOV BX,AX
    CALL DISP
ret
endp

set_time proc ;Regresa CH = hora, CL = minutos, DH = segundos y DL = centésimos de segundo.
    mov ah,2d
    int 21h
    ret
    endp
get_minutes proc
    mov DL,':'
    mov AH,02H    ; To Print : in DOS
    int 21H

    ;Minutes Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov AL,CL     ; Minutes is in CL
    AAM
    mov BX,AX
    call DISP

    mov DL,':'    ; To Print : in DOS
    mov AH,02H
    int 21H

    ;Seconds Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov AL,DH     ; Seconds is in DH
    AAM
    mov BX,AX
    call DISP
    ret
    endp
get_time proc
    ;Hour Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov AL,CH     ; Hour is in CH
    AAM
    mov BX,AX
    call DISP

    mov DL,':'
    mov AH,02H    ; To Print : in DOS
    int 21H

    ;Minutes Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov AL,CL     ; Minutes is in CL
    AAM
    mov BX,AX
    call DISP

    mov DL,':'    ; To Print : in DOS
    mov AH,02H
    int 21H

    ;Seconds Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov AL,DH     ; Seconds is in DH
    AAM
    mov BX,AX
    call DISP
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
    ret
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
;-----------------------------------------------------
ReadTwoint  proc
    call    Readint
    mov     num1,al
    call    Readint
    mov     num2,al
    mov al,10
    mul num1    ;a base 10
    add al,num2  
    mov num1, al 
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
ReadChar proc
    MOV AH , 01h
    INT 21h
    ret
    endp
Readint proc
    XOR AL,AL
    mov AH, 01h  
    int 21h 
    SUB AL,30h 
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