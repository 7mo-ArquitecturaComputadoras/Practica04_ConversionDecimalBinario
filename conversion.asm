; ============================================================
; Autor: Edson Joel Carrera Avila
; conversion.asm
; ============================================================

.586
.model flat, C                  ; Convención C para compatibilidad con C++

.data
    buffer  BYTE  33 DUP(0)     ; 32 bits + terminador nulo

.code
decimalABinario PROC numero:DWORD
    push ebx
    push edi

    mov  eax, numero
    lea  edi, buffer

    test eax, eax
    jz   caso_cero

    bsr  ecx, eax           

    mov  edx, 31
    sub  edx, ecx           ; EDX = 31 - índice MSB
    
    push ecx                ; Guardamos el índice original para usarlo como contador luego
    mov  cl, dl             
    shl  eax, cl            ; Desplazamos EAX a la izquierda. ¡El número ya está alineado!
    pop  ecx                ; Recuperamos nuestro contador

    inc  ecx                

escribir_bits:
    shl  eax, 1             ; SHL empuja el bit más alto hacia la bandera de acarreo (Carry Flag o CF)
    setc bl                 ; SETC pone BL en 1 si CF=1, o BL en 0 si CF=0. ¡Directo de hardware!
    add  bl, '0'            ; Convertimos el valor numérico 0 o 1 a texto '0' (48) o '1' (49)
    mov  BYTE PTR [edi], bl ; Escribimos en el buffer
    inc  edi
    dec  ecx
    jnz  escribir_bits      ; Repite el ciclo

    jmp  fin_funcion

caso_cero:
    mov  BYTE PTR [edi], '0'
    inc  edi

fin_funcion:
    mov  BYTE PTR [edi], 0  ; Terminador nulo para que C++ sepa dónde termina la cadena
    lea  eax, buffer        ; Retorna el puntero al buffer en EAX
    
    pop  edi
    pop  ebx
    ret

decimalABinario ENDP

END