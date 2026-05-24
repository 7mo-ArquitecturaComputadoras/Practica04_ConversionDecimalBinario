# 🔢 Práctica 04 — Conversión de Decimal a Binario en Ensamblador x86

Programa que combina **C++** y **ensamblador x86**: C++ se encarga de leer el número decimal ingresado por el usuario y mostrar el resultado binario, mientras que una función escrita en ensamblador realiza la conversión operando directamente sobre los bits, sin usar ninguna función de biblioteca.

---

## 📑 Índice

- [🎯 ¿Qué hace el programa?](#-qué-hace-el-programa)
- [🧠 Idea central del algoritmo](#-idea-central-del-algoritmo)
- [📂 Estructura del repositorio](#-estructura-del-repositorio)
- [🚀 Cómo empezar](#-cómo-empezar)
- [🔍 Trazado del ejemplo `42 → binario`](#-trazado-del-ejemplo-42--binario)
- [📘 Instrucciones x86 utilizadas](#-instrucciones-x86-utilizadas)
- [📄 Documentación adicional](#-documentación-adicional)

---

## 🎯 ¿Qué hace el programa?

El programa toma un número **decimal ingresado por el usuario** y calcula su **representación en binario** mediante algoritmo bit a bit que:

1. Localiza el **bit más significativo (MSB)**
2. Extrae bits de mayor a menor
3. Imprime la representación binaria en pantalla

Por ejemplo, para el número `42`:
- Entrada: `42` (decimal)
- Salida: `101010` (binario)

La conversión se realiza **completamente en ensamblador x86 MASM**, operando sobre los registros del procesador.

---

## 🧠 Idea central del algoritmo

El algoritmo **escanea bits** del número de forma secuencial:

```
Para cada posición de bit (31 a 0):
    1. Extraer el bit en esa posición
    2. Si el bit es 1, agregar "1" a la salida
    3. Si el bit es 0, agregar "0" a la salida
    4. Continuar hasta que se encuentre el primer 1 (MSB)
```

### Ejemplo: Convertir 42 a binario

```
42 en binario: 101010

Paso 1: 42 = 0b00101010 (32 bits, solo mostramos los relevantes)
Paso 2: Encontrar MSB (bit 5)
Paso 3: Extraer bits de posición 5 a 0: [1][0][1][0][1][0]
Resultado: "101010"
```

---

## 📂 Estructura del repositorio

```
Practica04_ConversionDecimalBinario/
├── documentacion/
│   ├── README_compilacion_latex.md                  # Cómo compilar el .tex a PDF
│   ├── Practica04_ConversionDecimalBinario.pdf      # Reporte técnico compilado
│   ├── Practica04_ConversionDecimalBinario.tex      # Reporte técnico en LaTeX
│   └── imagenes/                                    # Imágenes usadas en el reporte
│
├── proyecto/
│   ├── README_instalacion.md                        # Guía de instalación y puesta en marcha
│   ├── Practica04_ConversionDecimalBinario.slnx     # Solución de Visual Studio
│   ├── Practica04_ConversionDecimalBinario.vcxproj  # Proyecto MSBuild + MASM
│   └── src/
│       ├── conversion.asm                           # Función de conversión en x86
│       └── main.cpp                                 # Interfaz C++ (entrada/salida)
│
├── .gitattributes                                   # Normalización de finales de línea
├── .gitignore                                       # Archivos ignorados por Git
└── README.md                                        # Este archivo
```

---

## 🚀 Cómo empezar

La guía detallada con todos los pasos está en:

➡️ **[Guía de instalación y puesta en marcha](proyecto/README_instalacion.md)**

Resumen rápido:

1. Abre el **Símbolo del sistema** (`cmd`) o **Git Bash**, ubícate en la carpeta donde quieras guardar el proyecto y ejecuta:

```bash
git clone git@github.com:7mo-ArquitecturaComputadoras/Practica04_ConversionDecimalBinario.git
```
2. Abrir `proyecto/Practica04_ConversionDecimalBinario.slnx` en Visual Studio
3. Seleccionar configuración **Debug | Win32**
4. Compilar con `Ctrl + Shift + B` y ejecutar con `Ctrl + F5`

---

## 🔍 Trazado del ejemplo `42 → binario`

| Paso | Acción | Valor | Binario |
|------|--------|-------|---------|
| 1 | Entrada | 42 | — |
| 2 | Encontrar MSB | bit 5 | — |
| 3 | Leer bit 5 | 1 | 1 |
| 4 | Leer bit 4 | 0 | 10 |
| 5 | Leer bit 3 | 1 | 101 |
| 6 | Leer bit 2 | 0 | 1010 |
| 7 | Leer bit 1 | 1 | 10101 |
| 8 | Leer bit 0 | 0 | 101010 |
| 9 | Salida | — | **101010** |

**Resultado:** 42 (decimal) = 101010 (binario) ✅

---

## 📘 Instrucciones x86 utilizadas

| Instrucción | Operación |
|-------------|-----------|
| `MOV` | Copia un valor entre registros o memoria |
| `AND` | Operación lógica AND (extrae bits) |
| `SHR` | Desplazamiento a derecha (divide por 2) |
| `SHL` | Desplazamiento a izquierda (multiplica por 2) |
| `TEST` | Prueba bits sin modificar |
| `JNZ` / `JZ` | Saltos condicionales (no cero / cero) |
| `CALL` | Llama a un procedimiento |
| `RET` | Retorna de un procedimiento |
| `PUSH` / `POP` | Manejo de pila |
| `XOR` | Operación lógica XOR (pone registros a cero) |

---

## 📄 Documentación adicional

| Documento | Descripción |
|---|---|
| 🛠️ [`README_instalacion.md`](proyecto/README_instalacion.md) | Instalación y compilación paso a paso |
| 📄 [`README_compilacion_latex.md`](documentacion/README_compilacion_latex.md) | Cómo compilar el reporte desde LaTeX |
| 📕 [`reporte.pdf`](documentacion/reporte.pdf) | Reporte técnico compilado |
| 📝 [`reporte.tex`](documentacion/reporte.tex) | Fuente LaTeX del reporte técnico |

---

> **Autor:** Edson Joel Carrera Avila
