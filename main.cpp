// ============================================================
// Autor: Edson Joel Carrera Avila
// main.cpp
// ============================================================

#include <iostream>
using namespace std;

extern "C" char* decimalABinario(int numero);

int main() {
    int decimal;

    cout << "Ingresa un numero decimal: ";
    cin >> decimal;

    char* binario = decimalABinario(decimal);

    cout << "DEC: " << decimal << endl;
    cout << "BIN: " << binario << endl;

    return 0;
}