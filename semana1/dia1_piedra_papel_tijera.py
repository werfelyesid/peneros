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
puntos_jugador = 0
puntos_computadora = 0
jugador = input("Elije piedra, papel o  tijera\n: ").lower()
print("el primero a 3 puntos gana\n")
while puntos_jugador < 3 and puntos_computadora < 3:
    print(f"marcador: tu {puntos_jugador} - {puntos_computadora} computadora")
    jugador = input("Elije piedra, papel o  tijera\n: ").lower()
    computadora = random.choice(opciones)

while jugador not in opciones:
    print("escribe bien:\n piedra papel o tijera")
    exit()

if jugador == computadora:
    print("¡Empate!")
elif (jugador == "piedra" and computadora == "tijera"):
    print("¡Ganaste! 🎉")
elif (jugador == "papel" and computadora == "piedra"):
   print("¡Ganaste! 🎉")
elif (jugador == "tijera" and computadora == "papel"):
      print("¡Ganaste! 🎉") 
else:
    puntos_computadora += 1
    print("¡Perdiste! 😢")

print("=" * 30)
if puntos_jugador == 3:
    print("¡Felicidades, ganaste! 🎉")
else:
    print("¡La computadora ganó! 😢")