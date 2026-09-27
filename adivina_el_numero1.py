import random

secreto = random.randint(1, 20)
jugador = int(input("elije un numero del 1 al 20\n>>>: "))
intentos = 0

while jugador != secreto:
    intentos = intentos + 1
    if jugador < secreto:
        print("más alto 📈")
    else:
        print("más bajo 📉")
    jugador = int(input("intenta otro numero: "))
print("lets gooo!!!!!")
print("lo lograste en", intentos, "intentos")


