
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
date    db  'dd/mm/rrrr$'
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
Indiastr      DB 13,10, 'a. India: $'
Alemaniastr   DB 13,10, 'b. alemania: $'
EEUUstr       DB 13,10, 'c. EEUU: $'
Argentinastr  DB 13,10, 'd. Argentina: $'
Japonstr      DB 13,10, 'e. Japon: $'
Op3Datestr    DB 13,10, 'Date: $'
Op3Timestr    DB 13,10, 'Time: $'
Op3str        DB 13,10,'Coordinated Universal Time$'
;------------------Option4-------------------------------- 
Op4Timestr  DB 13,10,'Enter new time in this format hh:mm:ss : $'
Op4Datestr  DB 13,10,'Enter new date in this format dd/mm/yy: $'

;------------------Option5------------------------------- 

;---------------------UTILITIES--------------------------
Salto       DB 13,10, ' $'
YEAR        DW ?
YEARb       db ?
MONTH       DB ?
DAY         DB ?
WEEKDAY     DB ?
HOUR        DB ?
MINUTE      DB ?
SECOND      DB ?
Entrada     db ?
num1        db ?
num2        db ?
num3        db ?
rst         db ?
rst2        db ?
module      db ?
;----------------------DEBUG----------------------------------
PRUEBA1    DB 13,10, 'PRUEBA1: $'
PRUEBA2    DB 13,10, 'PRUEBA2: $'
tmp        db ?
tmp2        db ?
tmp3       db ?
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
    mov     num1, al
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
    call get__date
    
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
    Op2Err:
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
    call    CleanV
    mov     al,num1    ;convert num1 to negative, then do the same with plus case
    mov     bl,-1
    mul     bl
    mov     num1, al
    call    utcProcedure ;change for negative method
    call    Continue  
Error:
    call    CleanScreen
    lea     dx,Op2Error
    call    PrintStr
    jmp     Op2Err
Option3beta1:
jmp Option3
Option4beta1:
jmp Option4beta2
Option5beta1:
jmp Option5beta2
;------------------Option3--------------------------------   
Option3:
    call    CleanScreen
    lea     dx, Op1TimeStr  ;System time:    
    call    PrintStr
    call    get_time       ;display time

    lea     BX, date
    call    get__date
    lea     dx,Op1DateStr
    call    PrintStr       ;System date:
    lea     dx,date
    call    PrintStr       ;display date

    lea     dx, Salto
    call    PrintStr
    lea     dx,Op3str       ;Coordinated Universal Time
    call    PrintStr
    mov     num1,0
    call    utcProcedure

India: ;UTC+5:30
    lea     dx,Salto
    call    PrintStr
    lea     dx,Indiastr
    call    PrintStr
    mov     num1,5
    mov     num3,30d
    call    utcProcedureIndia
Alemania: ;UTC+2
    lea     dx,Salto
    call    PrintStr
    lea     dx,Alemaniastr
    call    PrintStr
    mov     num1,2
    call    utcProcedure

USA: ;UTC-5
    lea     dx,Salto
    call    PrintStr
    lea     dx,EEUUstr
    call    PrintStr
    mov     num1,-5
    call    utcProcedure

Argentina: ;UTC-3
    lea     dx,Salto
    call    PrintStr
    lea     dx,Argentinastr
    call    PrintStr
    mov     num1,-3
    call    utcProcedure

Japon: ;UTC+9
    lea     dx,Salto
    call    PrintStr
    lea     dx,Japonstr
    call    PrintStr
    mov     num1,9
    call    utcProcedure

    call Continue
Option4beta2:
jmp Option4
Option5beta2:
jmp Option5
;------------------Option4--------------------------------   
Option4:
    call    CleanScreen
    lea     dx,Op4Timestr
    call    PrintStr
    call ReadTwoint ;save on num1
    mov bl,num1
    mov HOUR,bl
    call CleanV
    call ReadChar ;should be : but doesnt matter
    call ReadTwoint ;save on num1
    mov bl,num1
    mov MINUTE,bl
    call CleanV
    call ReadChar ;should be : but doesnt matter
    call ReadTwoint ;save on num1
    mov bl,num1
    mov SECOND,bl
    call set_time
    call    Continue
;------------------Option5--------------------------------   
Option5:
    call    CleanScreen
    call    Continue
;---------------------UTILITIES--------------------------
utcProcedure proc
    ;Hour Part
    lea     dx,Op3Timestr
    call    PrintStr
    mov AH,2CH    ; To get System Time
    int 21H
    mov al,CH     ; Hour is in CH
    add al,num1   ; add extra hours 
    add al,6    ;add 6hours to UTC 00
    mov num2,al
    cmp num2,24
    jg  AdjustmentUTC ;if is necesary to change date
    AAM
    mov BX,AX
    call DISP
    ;Minutes and seconds
    call    get_minutes
    lea     dx,Op3Datestr
    call    PrintStr
    call    get_date
    ret
AdjustmentUTC:
    call    CleanV ;clean dx and ax
    mov     al,num2 ; system hour + num1 (extra hours) + 6 hours
    mov     bl,25
    div     bl
    mov     rst,al      ; add rst to day
    mov     hour,ah   ;new hour
    mov     al,hour     ; Hour is in module
    AAM
    mov     BX,AX
    call    DISP
    call    get_minutes
    lea     dx,Op3Datestr
    call    PrintStr
    ;Day Part
    mov     AH,2AH    ; To get System Date
    int     21H
    mov     al,dl     ; Day is in dl
    add     al,rst
    mov num2,al     ;days 
    mov MONTH,dh  ; Month is in DH
    mov YEAR,cx     ;   (1980 through 2099)
    call getMonthDays ; DAY have the amount of days of the actual month
    call CleanV

    mov al,num2
    mov bl,Day  ;29,31 or 32 for the mod
    div bl
    mov rst,al  ;add rsr to month
    mov module,ah; new day
    mov al,module   ;day is in module
    AAM
    mov BX,AX
    call DISP
    mov dl,'/'
    mov AH,02H    ; To Print / in DOS
    int 21H
    call CleanV
    ;Month Part
    mov al,month   
    add al,rst

    AAM
    mov BX,AX
    call DISP

    mov dl,'/'    ; To Print / in DOS
    mov AH,02H
    int 21H

    ;Year Part (1980 through 2099)
    mov AH,2AH    ; To get System Date
    int 21H
    ADD CX,0F830H ; To negate the effects of 16bit value,
    mov AX,CX     ; since AAM is applicable only for al (YYYY -> YY)
    AAM
    mov BX,AX
    call DISP

ret
endp
utcProcedureIndia proc

    call    CleanV ;clean dx and ax
    lea     dx,Op3Timestr
    call    PrintStr
    ;Minute Part
    mov     AH,2CH    ; To get System Time
    int     21H
    mov     al,cl       ;minutes
    add     al,num3     ;add extra minutes

    mov     bl,61d
    div     bl
    mov rst,al ; add rst to hour
    mov MINUTE,ah ; new minute module
    call    CleanV ;clean dx and ax

    ;Hour Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov al,CH     ; Hour is in CH
    add al,rst    ; extra from minute
    add al,num1   ; extra from utc
    add al,6      ; for UTC00
    mov num2,al   ; system hour + num1 (extra hours) + 6 hours
    div     bl
    mov     rst,al      ; add rst to day
    mov     hour,ah     ;new hour
    call    CleanV ;clean dx and ax

    mov     al,hour     ; Hour is in module
    AAM ;print
    mov BX,AX
    call DISP
    mov dl,':'
    mov AH,02H    ; To Print : in DOS
    int 21H

    ;Minutes Part
    mov al,MINUTE ; Minutes is in CL
    AAM ;print
    mov BX,AX
    call DISP
    mov dl,':'    ; To Print : in DOS
    mov AH,02H
    int 21H
    ;Seconds Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov al,DH     ; Seconds is in DH
    AAM
    mov BX,AX
    call DISP

    call    CleanV ;clean dx and ax
    lea     dx,Op3Datestr
    call    PrintStr
    ;Day Part
    mov     AH,2AH    ; To get System Date
    int     21H
    mov     al,dl     ; Day is in dl
    add     al,rst
    mov num2,al     ;days 
    mov MONTH,dh  ; Month is in DH
    mov YEAR,cx     ;   (1980 through 2099)
    call getMonthDays ; DAY have the amount of days of the actual month
    call CleanV

    mov     al,num2
    mov     bl,Day  ;29,31 or 32 for the mod
    div     bl
    mov     rst,al  ;add rsr to month
    mov     module,ah; new day
    mov     al,module   ;day is in module
    AAM
    mov BX,AX
    call DISP
    mov dl,'/'
    mov AH,02H    ; To Print / in DOS
    int 21H
    call CleanV
    ;Month Part
    mov al,month   
    add al,rst
    AAM
    mov BX,AX
    call DISP
    mov dl,'/'    ; To Print / in DOS
    mov AH,02H
    int 21H

    ;Year Part (1980 through 2099)
    mov AH,2AH    ; To get System Date
    int 21H
    ADD CX,0F830H ; To negate the effects of 16bit value,
    mov AX,CX     ; since AAM is applicable only for al (YYYY -> YY)
    AAM
    mov BX,AX
    call DISP

    
ret
endp
debug proc
    lea dx,PRUEBA1
    call PrintStr
    call printtmp
    lea dx,PRUEBA1
    call PrintStr
    lea dx,Salto
    call PrintStr
    ret 
    endp

set_time proc ;Regresa CH = hora, CL = minutos, DH = segundos y dl = centésimos de segundo.
    call CleanV
    mov ch,HOUR
    mov cl,MINUTE
    mov dh,SECOND
    mov ah,2Dh
    int 21h
    ret
    endp
get_minutes proc
    mov dl,':'
    mov AH,02H    ; To Print : in DOS
    int 21H

    ;Minutes Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov al,CL     ; Minutes is in CL
    AAM
    mov BX,AX
    call DISP

    mov dl,':'    ; To Print : in DOS
    mov AH,02H
    int 21H

    ;Seconds Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov al,DH     ; Seconds is in DH
    AAM
    mov BX,AX
    call DISP
    ret
    endp
get_time proc
    ;Hour Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov al,CH     ; Hour is in CH
    AAM
    mov BX,AX
    call DISP

    mov dl,':'
    mov AH,02H    ; To Print : in DOS
    int 21H

    ;Minutes Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov al,CL     ; Minutes is in CL
    AAM
    mov BX,AX
    call DISP

    mov dl,':'    ; To Print : in DOS
    mov AH,02H
    int 21H

    ;Seconds Part
    mov AH,2CH    ; To get System Time
    int 21H
    mov al,DH     ; Seconds is in DH
    AAM
    mov BX,AX
    call DISP
    ret
    endp
get_date proc
    ;Day Part
    mov AH,2AH    ; To get System Date
    int 21H
    mov al,dl     ; Day is in dl
    AAM
    mov BX,AX
    call DISP

    mov dl,'/'
    mov AH,02H    ; To Print / in DOS
    int 21H

    ;Month Part
    mov AH,2AH    ; To get System Date
    int 21H
    mov al,DH     ; Month is in DH
    AAM
    mov BX,AX
    call DISP

    mov dl,'/'    ; To Print / in DOS
    mov AH,02H
    int 21H

    ;Year Part
    mov AH,2AH    ; To get System Date
    int 21H
    ADD CX,0F830H ; To negate the effects of 16bit value,
    mov AX,CX     ; since AAM is applicable only for al (YYYY -> YY)
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

get__date proc
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
getMonthDays proc
    cmp Month,1
    je  Month1
    cmp Month,2
    je  Month2
    cmp Month,3
    je  Month3
    cmp Month,4
    je  Month4
    cmp Month,5
    je  Month5
    cmp Month,6
    je  Month6
    cmp Month,7
    je  Month7
    cmp Month,8
    je  Month8
    cmp Month,8
    je  Month8
    cmp Month,9
    je  Month9
    cmp Month,10
    je  Month10
    cmp Month,11
    je  Month11
    cmp Month,12
    je  Month12
    Month1:
        mov DAY,32
        ret
    Month2:
        mov day,29
        ret
    Month3:
        mov DAY,32
        ret
    Month4:
        mov DAY,31
        ret
    Month5:
        mov DAY,32
        ret
    Month6:
        mov DAY,31
        ret
    Month7:
        mov DAY,32
        ret
    Month8:
        mov DAY,32
        ret
    Month9:
        mov DAY,31
        ret
    Month10:
        mov DAY,32
        ret
    Month11:
        mov DAY,31
        ret
    Month12:
        mov DAY,32
        ret
    endp
printtmp proc
    call CleanV
    mov al, tmp
    mov BL, 10 
    DIV BL  
    
    mov tmp2,al
    mov tmp3,AH
    XOR DX,DX;clean

    ;print result
    mov AH,02h
    mov dl,tmp2
    ADD dl,30h
    int 21h
    
    XOR DX,DX ;clean
    mov AH,02h
    mov dl,tmp3
    ADD dl,30h
    int 21h
    ret
    endp
;-------------Common stuff----------------------
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
        mov AH , 01h
        int 21h
        ret
        endp
    Readint proc
        XOR al,al
        mov AH, 01h  
        int 21h 
        SUB al,30h 
        ret
        endp
    CleanV proc
        xor dx,dx
        xor ax,ax
        xor cx,cx
        ret
        endp

;---------------------------------------------------------------
.STACK
END programa