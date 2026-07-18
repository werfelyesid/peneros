"""
=============================
🥊 DÍA 1 — PIEDRA, PAPEL O TIJERA (desde cero)
=============================

INSTRUCCIONES:
-------------
Hoy vas a REESCRIBIR el juego de piedra, papel o tijera
DESDE CERO. No copies del viejo. Escribe línea por línea.

REQUISITOS MÍNIMOS:
-------------------
1. La computadora elige una opción al azar
2. El jugador escribe su opción
3. El programa dice quién ganó

COSAS NUEVAS que debes agregar (no estaban en el viejo):
--------------------------------------------------------
4. Si el jugador escribe mal, el programa avisa y pide de nuevo
5. El programa muestra un marcador de la ronda actual
6. El programa dice "¡Empate!" si ambos eligen lo mismo

AYUDA (solo si de verdad no sabes):
------------------------------------
- Para números al azar: import random
- Para elegir al azar de una lista: random.choice(lista)
- Para repetir algo: while
- Para comparar: if / elif / else

¡ESCRIBE TODO TÚ! Sin copiar del otro archivo.
"""

# ⬇️ ESCRIBE TU CÓDIGO AQUÍ ABAJO ⬇️

import random

opciones = ["piedra", "papel", "tijera"]

puntos_jugador=0
puntos_computadora=0
print("Elije piedra, papel o tijera ahora")
print("ganas si llagas a 3 puntos\n\n")

while puntos_jugador < 3 and puntos_computadora < 3:
    print(f"score🦖: jugador {puntos_jugador} puntos \n PC {puntos_computadora} puntos\n")
    
    eleccion = input("elije, piedra papel o tijera: ").lower()
    if eleccion not in opciones:
        print("escribe bien🦖🦖🦖")
        continue
    
    pc = random.choice(opciones)
    print(f"la pc elijio {pc}")

    if eleccion == puntos_computadora:
        print("!empate¡🦖🦖🦖")
    elif(eleccion == "piedra" and pc == "tijera") or\
        (eleccion == "papel" and pc == "piedra") or\
        (eleccion == "tijera" and pc == "papel"):
        print("ganaste , GOLL;LL🦖🦖🦖🦖🦖🦖🦖")
        puntos_jugador += 1 
    else:
        puntos_computadora += 1
        print("!perdiste gano la pppccc 🦖🦖🦖🦖🦖🦖")
print("=🦖" * 30)
if puntos_jugador == 3:
    print("you win🦖🦖🦖")
else:
    print("perdiste ajjaja🦖🦖🦖")
print(f"score jugador: {puntos_jugador}\n score pc {puntos_computadora}🦖🦖🦖🦖")