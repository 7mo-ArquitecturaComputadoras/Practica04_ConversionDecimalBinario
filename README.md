# Práctica 04 — Conversión de Decimal a Binario en Ensamblador x86

## Descripción

Programa que combina **C++** y **ensamblador x86**: C++ se encarga de leer el número decimal ingresado por el usuario y mostrar el resultado, mientras que una función escrita en ensamblador realiza la conversión a binario operando directamente sobre los bits del valor, sin usar ninguna función de biblioteca.

La conversión se basa en extraer los bits del número de mayor a menor:

```
Paso 1 — Localizar el bit más significativo (MSB):
    BSR ecx, eax      →  ECX = posición del primer bit en 1
                          (ej: 45 = 101101b → MSB en posición 5)

Paso 2 — Alinear el número a la izquierda:
    SHL eax, (31-ECX) →  el MSB queda en el extremo izquierdo de EAX

Paso 3 — Extraer bit por bit (ciclo):
    SHL eax, 1        →  el bit más alto "cae" a la Carry Flag
    SETC bl           →  BL = 1 si CF=1,  BL = 0 si CF=0
    BL + '0'          →  convierte 0/1 al carácter '0'/'1'
```

---

## Estructura del Proyecto

```
Practica04_ConversionDecimalBinario/
├── main.cpp        # Interfaz con el usuario: lee el número y muestra el resultado
└── conversion.asm  # Función de conversión: recibe el entero y devuelve la cadena binaria
```

---

## Interfaz y Convención de Llamada

C++ llama a la función ensamblador mediante `extern "C"`, y el ensamblador devuelve en `EAX` un puntero a la cadena binaria resultante almacenada en su propio buffer.

| Elemento    | Descripción                                                                 |
|-------------|-----------------------------------------------------------------------------|
| `buffer`    | Arreglo de 33 bytes en `.data`; almacena los dígitos binarios y el `\0` final |
| `EAX`       | Recibe el número a convertir; al final contiene el puntero al buffer        |
| `ECX` / `CL`| Contador del ciclo y operando de desplazamiento para `SHL`                  |
| `EDX`       | Calcula temporalmente los lugares de alineación (`31 - posición MSB`)       |
| `BL`        | Recibe el bit extraído vía `SETC` y lo convierte al carácter correspondiente |
| `EDI`       | Puntero de escritura sobre el buffer; avanza un byte por iteración          |

La directiva `.model flat, C` indica modelo de memoria plana con la convención de llamadas de C, compatible con `extern "C"` de C++.

---

## Funcionamiento del Algoritmo

El programa implementa un ciclo de extracción-escritura sobre los bits del número. Antes del ciclo, `BSR` localiza el bit más alto y `SHL` alinea el número para que ese bit quede en el extremo izquierdo de `EAX`. En cada iteración, un nuevo `SHL` desplaza ese extremo hacia la *Carry Flag*, donde `SETC` lo captura y lo convierte al carácter de texto correspondiente.

### Flujo de ejecución

```
Inicio
 └─ EAX = numero, EDI = buffer

 ├─ EAX == 0 ? → escribir '0' → fin
 └─ BSR: ECX = posición del MSB

 └─ SHL EAX, (31 - ECX)    (alineación)
 └─ ECX++                  (incluir el MSB en el conteo)

escribir_bits:
 ├─ SHL EAX, 1  →  bit cae en Carry Flag
 ├─ SETC BL     →  BL = bit (0 ó 1)
 ├─ BL + '0'    →  BL = carácter '0' o '1'
 ├─ [EDI] = BL, EDI++, ECX--
 └─ ECX != 0 ? → repetir

fin_funcion:
 └─ [EDI] = 0 (terminador), EAX = buffer → retornar a C++
```

### Ejemplo con el número `45`

| Iteración | Carry Flag | BL | Carácter escrito | ECX restante |
|-----------|------------|----|-----------------|--------------|
| 1         | 1          | 1  | `'1'`           | 5            |
| 2         | 0          | 0  | `'0'`           | 4            |
| 3         | 1          | 1  | `'1'`           | 3            |
| 4         | 1          | 1  | `'1'`           | 2            |
| 5         | 0          | 0  | `'0'`           | 1            |
| 6         | 1          | 1  | `'1'`           | 0            |

Resultado en buffer: `"101101"` → `31 30 31 31 30 31 00` (hex)

---

## Instrucciones x86 Utilizadas

| Instrucción | Operación |
|-------------|-----------|
| `MOV`       | Copia un valor entre registro y memoria |
| `LEA`       | Carga la dirección de memoria de una variable en un registro |
| `TEST`      | Compara un valor consigo mismo sin modificarlo; detecta si es cero |
| `BSR`       | Busca el primer bit en 1 de derecha a izquierda y guarda su posición |
| `SHL`       | Desplaza los bits a la izquierda; el bit sobrante cae en la *Carry Flag* |
| `SETC`      | Escribe 1 en un registro si la *Carry Flag* está activa; 0 si no |
| `ADD`       | Suma dos valores y guarda el resultado en el primero |
| `INC`       | Incrementa el operando en 1 |
| `DEC`       | Decrementa el operando en 1 |
| `JZ`        | Salta si el resultado de `TEST`/`CMP` fue cero |
| `JNZ`       | Salta si el resultado de `TEST`/`CMP` no fue cero |
| `JMP`       | Salto incondicional |
| `PUSH`      | Guarda un valor en la pila |
| `POP`       | Recupera el último valor guardado en la pila |

---

## Ejemplo de Ejecución

```
Ingresa un numero decimal: 45
DEC: 45
BIN: 101101

Ingresa un numero decimal: 0
DEC: 0
BIN: 0

Ingresa un numero decimal: 255
DEC: 255
BIN: 11111111
```

---

## Requisitos

- **Ensamblador:** MASM (Microsoft Macro Assembler), incluido en Visual Studio
- **Compilador C++:** MSVC, incluido en Visual Studio
- **Arquitectura:** x86 (32 bits), modo protegido plano (`flat`)
- **Sistema operativo:** Windows
- **Convención de llamadas:** `C` (compatible con `extern "C"` de C++)
