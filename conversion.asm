; ============================================================
; Autor: Edson Joel Carrera Avila
; conversion.asm
; ============================================================

.586                       
.model flat, C             

.data
    buffer  BYTE  33 DUP(0)

.code

; ------------------------------------------------------------
; FUNCION: decimalABinario
;   Recibe : un numero entero
;   Regresa: la direccion del buffer con la cadena binaria
; ------------------------------------------------------------
decimalABinario PROC numero:DWORD

    push ebx                    ; Guardamos EBX en la pila
    push edi                    ; Guardamos EDI en la pila

    mov  eax, numero            ; EAX = numero que queremos convertir
    lea  edi, buffer            ; EDI apunta al inicio del buffer donde escribiremos

    ; ----------------------------------------------------------
    ; CASO ESPECIAL: verificar si el numero es cero.
    ; ----------------------------------------------------------
    test eax, eax               ; ¿El numero es cero?
    jz   caso_cero              ; Si es cero, saltamos al caso especial

    ; ----------------------------------------------------------
    ; BUSCAR EL BIT MAS SIGNIFICATIVO (MSB)
    ; BSR recorre el numero de derecha a izquierda buscando
    ; el primer bit en 1 y guarda su posicion en ECX.
    ; ----------------------------------------------------------
    bsr  ecx, eax               ; ECX = posicion del bit mas significativo

    ; ----------------------------------------------------------
    ; ALINEAR EL NUMERO A LA IZQUIERDA
    ; Para leer los bits de izquierda a derecha necesitamos que MSB
    ; quede en el extremo izquierdo de EAX (31 - posicion_MSB)
    ; ----------------------------------------------------------
    mov  edx, 31
    sub  edx, ecx               ; EDX = cuantos lugares desplazar a la izquierda
    push ecx                    ; Guardamos ECX porque CL lo va a sobreescribir
    mov  cl, dl                 ; CL = cuantos lugares desplazar (SHL solo acepta CL)
    shl  eax, cl                ; Desplazamos EAX: el MSB queda en el extremo izquierdo
    pop  ecx                    ; Recuperamos ECX con la cantidad de bits a escribir
    inc  ecx                    ; Sumamos 1 para que el ciclo incluya el MSB en la cuenta

; ============================================================
; CICLO PRINCIPAL: convierte el numero bit por bit.
; ============================================================
escribir_bits:

    ; ----------------------------------------------------------
    ; EXTRAER EL SIGUIENTE BIT
    ; SHL desplaza EAX un lugar a la izquierda; el bit que
    ; "se cae" por el extremo izquierdo queda atrapado en la
    ; bandera de acarreo (Carry Flag).
    ; ----------------------------------------------------------
    shl  eax, 1                 ; El bit mas alto de EAX cae hacia la Carry Flag
    setc bl                     ; BL = 1 si el bit era 1, BL = 0 si el bit era 0

    ; ----------------------------------------------------------
    ; CONVERTIR A CARACTER DE TEXTO
    ; En la tabla ASCII '0' vale 48 y '1' vale 49.
    ; Sumando el valor de '0' (48) a BL (que es 0 o 1)
    ; obtenemos el caracter de texto correcto.
    ; ----------------------------------------------------------
    add  bl, '0'                ; BL = '0' (48) o '1' (49)
    mov  BYTE PTR [edi], bl     ; Escribimos el caracter en la posicion actual del buffer
    inc  edi                    ; Avanzamos el puntero al siguiente espacio del buffer
    dec  ecx                    ; Contamos un bit menos por procesar
    jnz  escribir_bits          ; Si quedan bits (ECX != 0), repetimos el ciclo
    jmp  fin_funcion           

caso_cero:
    mov  BYTE PTR [edi], '0'    ; Escribimos directamente el caracter '0' en el buffer
    inc  edi                    ; Avanzamos el puntero para dejar lugar al fin de cadena

fin_funcion:
    mov  BYTE PTR [edi], 0      ; Escribimos el fin de cadena (valor 0) para que C++ sepa donde termina
    lea  eax, buffer            ; Ponemos en EAX la direccion del buffer para devolverlo como resultado
    pop  edi                    ; Restauramos EDI
    pop  ebx                    ; Restauramos EBX
    ret                         ; Regresamos a C++ (EAX lleva el puntero al resultado)

decimalABinario ENDP            

END                       
