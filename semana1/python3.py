import random

opciones = ["piedra", "papel", "tijera"]
jugador = input("Elije piedra, papel o  tijera\n: ").lower()
computadora = random.choice(opciones)

while jugador not in opciones:
    print("escribe bien:\n piedra papel o tijera")
    