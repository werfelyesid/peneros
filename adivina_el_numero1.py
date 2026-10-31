import random

secreto = random.randit(1, 20)
jugador = int(input("elije un numero deel uno al 20\n<><><>: "))
intentos = 0

while jugador != secreto:
    intentos = intentos +1
    if jugador < secreto:
        print("más alto 📈")
    else:
        print("más bajo 📉")
    jugador = int(input("intenta otro numero: "))
print("lets goooo!!!!!")
print("lo lograste en",intentos, "intentos")