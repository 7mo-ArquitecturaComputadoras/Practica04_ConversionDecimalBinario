# 🔢 Práctica 04 — Conversión de Decimal a Binario en Ensamblador x86

Programa mixto **ensamblador x86 + C++** que convierte un número entero positivo a su representación binaria sin ceros a la izquierda. La función ensamblador localiza el bit más significativo (MSB) con una sola instrucción `BSR`, alinea el número y extrae los bits uno a uno mediante la bandera de acarreo (`Carry Flag`), escribiéndolos como caracteres ASCII en un buffer terminado en `0` que se devuelve a C++ para imprimir.

---

## 📑 Índice

- [🎯 ¿Qué hace el programa?](#-qué-hace-el-programa)
- [🧠 Idea central del algoritmo](#-idea-central-del-algoritmo)
- [📂 Estructura del repositorio](#-estructura-del-repositorio)
- [🚀 Cómo empezar](#-cómo-empezar)
- [🔍 Trazado del ejemplo `42 → 101010`](#-trazado-del-ejemplo-42--101010)
- [📘 Instrucciones x86 utilizadas](#-instrucciones-x86-utilizadas)
- [📄 Documentación adicional](#-documentación-adicional)

---

## 🎯 ¿Qué hace el programa?

El programa toma un **número entero positivo ingresado por el usuario** desde C++, llama a la función `decimalABinario` escrita en ensamblador y muestra el resultado binario sin ceros a la izquierda.

La operación implementada es:

```
binario(N) = bit_MSB · bit_MSB-1 · ... · bit_1 · bit_0
```

Donde `bit_MSB` es la posición del bit más significativo (más a la izquierda) que vale 1 en `N`.

Por ejemplo, para el número `42`:
- Entrada: `42` (decimal, equivale a `00000000 00000000 00000000 00101010` en 32 bits)
- MSB: bit en posición **5**
- Salida: `101010` (sólo los 6 bits desde el MSB hacia el LSB)

La función ensamblador es invocada desde C++ usando la convención **cdecl** (declarada en MASM con `.model flat, C`), preservando los registros `EBX` y `EDI` según las normas de llamada.

---

## 🧠 Idea central del algoritmo

En lugar de iterar las 32 posiciones de bit del registro `EAX`, la función aprovecha la instrucción **`BSR`** (*Bit Scan Reverse*) para localizar el MSB en una sola operación, y luego extrae los bits de izquierda a derecha usando la **Carry Flag** como vehículo de un bit a la vez.

### Flujo de ejecución

```
Inicio
 └─ EAX = numero, EDI = &buffer[0]
 └─ TEST EAX, EAX → si EAX == 0 → caso_base
 └─ BSR ECX, EAX → ECX = posición del MSB (0..31)
 └─ EDX = 31 - ECX → cuántos lugares desplazar a la izquierda
 └─ SHL EAX, CL → MSB queda en el bit 31 de EAX
 └─ INC ECX → cantidad de bits a escribir = MSB_pos + 1

escribir_bits:
 ├─ SHL EAX, 1        → el bit 31 cae a la Carry Flag
 ├─ SETC BL           → BL = 1 si Carry=1, BL = 0 si Carry=0
 ├─ ADD BL, '0'       → BL = '0' (48) o '1' (49)
 ├─ MOV [EDI], BL     → escribir carácter en el buffer
 ├─ INC EDI           → avanzar puntero del buffer
 ├─ DEC ECX
 └─ JNZ escribir_bits → repetir si ECX != 0

caso_base:
 └─ MOV [EDI], '0' → escribir un solo '0' para representar el cero
 └─ INC EDI

fin:
 └─ MOV BYTE PTR [EDI], 0 → terminador de cadena C (NUL)
 └─ LEA EAX, buffer       → EAX = dirección del buffer
 └─ RET → C++ recibe `char*` y lo imprime con cout
```

### Registros utilizados

| Registro | Rol                                                                       |
|----------|---------------------------------------------------------------------------|
| `EAX`    | Contiene el número a convertir; tras `SHL` se va vaciando bit a bit       |
| `EBX`    | Su byte bajo `BL` recibe el bit extraído de la Carry Flag                 |
| `ECX`    | Contador del bucle: inicia en `MSB + 1` y decrementa hasta `0`            |
| `EDX`    | Variable temporal para calcular `31 - posición_MSB`                       |
| `EDI`    | Puntero al siguiente carácter libre del buffer; avanza 1 byte por iteración |

El buffer `buffer BYTE 33 DUP(0)` reserva 33 bytes en la sección `.data`: 32 caracteres para los bits de un entero de 32 bits, más el byte `0` terminador de cadena.

---

## 📂 Estructura del repositorio

```
Practica04_ConversionDecimalBinario/
├── documentacion/
│   ├── README_compilacion_latex.md                  # Cómo compilar el .tex a PDF
│   ├── reporte.pdf                                  # Reporte técnico compilado
│   ├── reporte.tex                                  # Reporte técnico en LaTeX
│   └── imagenes/                                    # Imágenes usadas en el reporte
│
├── proyecto/
│   ├── README_instalacion.md                        # Guía de instalación y puesta en marcha
│   ├── Practica04_ConversionDecimalBinario.slnx     # Solución de Visual Studio
│   ├── Practica04_ConversionDecimalBinario.vcxproj  # Proyecto MSBuild + MASM
│   └── src/
│       ├── conversion.asm                           # Función decimalABinario en x86 (MASM)
│       └── main.cpp                                 # Interfaz C++ (entrada/salida)
│
├── .gitattributes                                   # Normalización de finales de línea
├── .gitignore                                       # Archivos ignorados por Git
└── README.md                                        # Este archivo
```

---

## 🚀 Cómo empezar

La guía detallada con todos los pasos (instalar Git, Visual Studio, habilitar MASM, compilar y ejecutar) está en un documento aparte:

➡️ **[Guía de instalación y puesta en marcha](proyecto/README_instalacion.md)**

Resumen rápido para quien ya tiene el entorno listo:

1. Abre el **Símbolo del sistema** (`cmd`) o **Git Bash**, ubícate en la carpeta donde quieras guardar el proyecto y ejecuta:

```bash
git clone git@github.com:7mo-ArquitecturaComputadoras/Practica04_ConversionDecimalBinario.git
```
2. Abrir `proyecto/Practica04_ConversionDecimalBinario.slnx` en Visual Studio.
3. Seleccionar configuración **Debug | Win32**.
4. Compilar con `Ctrl + Shift + B` y ejecutar con `Ctrl + F5`.
5. Ingresar un número entero positivo cuando el programa lo solicite.

---

## 🔍 Trazado del ejemplo `42 → 101010`

### Estado inicial

| Registro | Valor                                | Comentario                              |
|----------|--------------------------------------|-----------------------------------------|
| `EAX`    | `0x0000002A` (`...00101010` en bin.) | Número de entrada: 42                   |
| `EDI`    | `&buffer[0]`                         | Inicio del buffer destino               |

### Fase de preparación (antes del bucle)

| Instrucción            | Efecto                                                 | Resultado                  |
|------------------------|--------------------------------------------------------|----------------------------|
| `BSR ECX, EAX`         | ECX = posición del MSB de 42                           | `ECX = 5`                  |
| `MOV EDX, 31`          | EDX = 31                                               | `EDX = 31`                 |
| `SUB EDX, ECX`         | EDX = 31 − 5                                           | `EDX = 26`                 |
| `MOV CL, DL`           | CL = 26                                                | `CL = 26`                  |
| `SHL EAX, CL`          | Desplaza EAX 26 lugares: MSB queda en bit 31           | `EAX = 0xA8000000`         |
| `INC ECX`              | ECX = bits a escribir = MSB + 1 = 6                    | `ECX = 6`                  |

### Iteración del bucle `escribir_bits`

| Iteración | EAX (antes)    | Carry tras SHL | BL    | buffer acumulado |
|-----------|----------------|----------------|-------|------------------|
| 1         | `0xA8000000`   | `1`            | `'1'` | `"1"`            |
| 2         | `0x50000000`   | `0`            | `'0'` | `"10"`           |
| 3         | `0xA0000000`   | `1`            | `'1'` | `"101"`          |
| 4         | `0x40000000`   | `0`            | `'0'` | `"1010"`         |
| 5         | `0x80000000`   | `1`            | `'1'` | `"10101"`        |
| 6         | `0x00000000`   | `0`            | `'0'` | `"101010"`       |

### Resultado final

`buffer = "101010\0"` → C++ imprime `BIN: 101010` ✅

---

## 📘 Instrucciones x86 utilizadas

### Instrucciones clave del algoritmo

| Instrucción  | Operación                                                                                |
|--------------|------------------------------------------------------------------------------------------|
| `BSR`        | *Bit Scan Reverse*: encuentra la posición del bit más significativo activo (`MSB`)        |
| `SHL`        | Desplaza el operando a la izquierda; el bit que se desborda cae en la **Carry Flag**     |
| `SETC`       | Pone un byte a `1` si la Carry Flag está activada, o `0` en caso contrario               |
| `TEST`       | Realiza una AND lógica sin guardar el resultado; actualiza ZF para detectar `EAX == 0`   |

### Propósito general

| Instrucción    | Operación                                                                              |
|----------------|----------------------------------------------------------------------------------------|
| `PUSH` / `POP` | Prólogo/epílogo del marco de pila y preservación de `EBX` y `EDI`                      |
| `MOV`          | Carga el parámetro `numero` desde la pila a `EAX` y mueve constantes entre registros   |
| `LEA`          | *Load Effective Address*: carga la dirección de `buffer` en `EDI` y en `EAX` al retornar |
| `SUB`          | Calcula `31 - posición_MSB` para saber cuántos lugares desplazar a la izquierda        |
| `ADD`          | Convierte el bit (`0` o `1`) en carácter ASCII sumando `'0'` (48)                      |
| `INC`          | Avanza el puntero `EDI` del buffer y suma 1 al contador `ECX` (MSB + 1)                |
| `DEC`          | Decrementa `ECX` y actualiza la bandera ZF para el salto condicional                   |
| `JZ`           | Salta a `caso_base` si el número es `0`                                                |
| `JNZ`          | Repite el bucle si `ECX != 0`                                                          |
| `JMP`          | Salto incondicional desde `escribir_bits` a `fin`                                      |
| `RET`          | Retorna al llamador (`main.cpp`); el resultado es `char*` en `EAX`                     |

---

## 📄 Documentación adicional

| Documento | Descripción |
|---|---|
| 🛠️ [`README_instalacion.md`](proyecto/README_instalacion.md) | Cómo instalar Git, Visual Studio con MASM, compilar y ejecutar el programa paso a paso. |
| 📄 [`README_compilacion_latex.md`](documentacion/README_compilacion_latex.md) | Cómo regenerar el PDF del reporte a partir de `reporte.tex` usando TeX Live, Geany o VS Code, tanto en Linux como en Windows. |
| 📕 [`reporte.pdf`](documentacion/reporte.pdf) | Reporte técnico ya compilado, con análisis detallado del algoritmo y la Carry Flag. |
| 📝 [`reporte.tex`](documentacion/reporte.tex) | Fuente LaTeX del reporte técnico. |

---

> **Autor:** Edson Joel Carrera Avila
