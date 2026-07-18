import random

opciones = ["piedra", "papel", "tijera"]
jugador = input("Elige piedra papel o tijera 🔍: ")
computadora = random.choice(opciones)
while jugador not in opciones:
    print("¡Escribe bien! piedra papel o tijera! ")
    jugador = input("Intenta de nuevo ")
    print("Tú elegiste:", jugador)
    print("la computadora eligió:", computadora)
if jugador == computadora:
    print("Empate!!!!!!!!!!!!!!!!!!!!")
elif jugador == "piedra" and computadora == "tijera":
     print("¡Ganaste! ñerositaciones💬")
elif jugador == "tijera" and computadora == "papel":
     print("¡Ganaste! ñerositaciones💬")
elif jugador == "papel" and computadora == "piedra":
     print("¡Ganaste! ñerositaciones💬")
else:
        print("perdiste ñesconsolado bendiciones")