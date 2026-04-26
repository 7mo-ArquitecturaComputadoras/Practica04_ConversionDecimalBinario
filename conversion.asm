; ============================================================
; Autor: Edson Joel Carrera Avila
; conversion.asm
; ============================================================

.586                       
.model flat, C             

; ============================================================
; SECCIÓN DE DATOS (.data)
; ============================================================
.data
    buffer  BYTE  33 DUP(0)

; ============================================================
; SECCIÓN DE CÓDIGO (.code)
; ============================================================
.code
; --- Inicio del programa ---

decimalABinario PROC numero:DWORD
    push ebx                    ; Guardamos EBX en la pila
    push edi                    ; Guardamos EDI en la pila
    mov  eax, numero            ; EAX = numero que queremos convertir
    lea  edi, buffer            ; EDI apunta al inicio del buffer donde escribiremos

    ; --- ¿x == 0.0? ---
    test eax, eax               
    jz   caso_base              ; Si es cero, saltamos al caso_base

	; --- Buscar el bit más significativo (MSB) ---
    ; BSR recorre el numero de derecha a izquierda buscando
    ; el primer bit en 1 y guarda su posicion en ECX.
    bsr  ecx, eax               ; ECX = posicion del bit mas significativo

	; --- Alinear el numero a la izquierda ---
    ; Para leer los bits de izquierda a derecha necesitamos que MSB
    ; quede en el extremo izquierdo de EAX (31 - posicion_MSB)
    mov  edx, 31
    sub  edx, ecx               ; EDX = cuantos lugares desplazar a la izquierda
    push ecx                    ; Guardamos ECX porque CL lo va a sobreescribir
    mov  cl, dl                 ; CL = cuantos lugares desplazar (SHL solo acepta CL)
    shl  eax, cl                ; Desplazamos EAX: el MSB queda en el extremo izquierdo
    pop  ecx                    ; Recuperamos ECX con la cantidad de bits a escribir
    inc  ecx                    ; Sumamos 1 para que el ciclo incluya el MSB en la cuenta

escribir_bits:
	; --- Extraer el siguiente bit ---
    ; SHL desplaza EAX un lugar a la izquierda; el bit que
    ; "se cae" por el extremo izquierdo queda atrapado en la
    ; bandera de acarreo (Carry Flag).
    shl  eax, 1                 ; El bit mas alto de EAX cae hacia la Carry Flag
    setc bl                     ; BL = 1 si el bit era 1, BL = 0 si el bit era 0

	; --- Convertir a caracter de texto ---
    ; En la tabla ASCII '0' vale 48 y '1' vale 49.
    ; Sumando el valor de '0' (48) a BL (que es 0 o 1)
    ; obtenemos el caracter de texto correcto.
    add  bl, '0'                ; BL = '0' (48) o '1' (49)
    mov  BYTE PTR [edi], bl     ; Escribimos el caracter en la posicion actual del buffer
    inc  edi                    ; Avanzamos el puntero al siguiente espacio del buffer
    dec  ecx                    ; Contamos un bit menos por procesar
    jnz  escribir_bits          ; Si quedan bits (ECX != 0), repetimos el ciclo
    jmp  fin 

caso_base:
    mov  BYTE PTR [edi], '0'    ; Escribimos directamente el caracter '0' en el buffer
    inc  edi                    ; Avanzamos el puntero para dejar lugar al fin de cadena

; --- Fin del programa ---
fin:
    mov  BYTE PTR [edi], 0
    lea  eax, buffer      
    pop  edi              
    pop  ebx              
    ret                   
decimalABinario ENDP            

END                       
