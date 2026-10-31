import random

palabras = ["esternocleidomastoideo", "papa yesid", "empapado", "ñerito", "dtmf"]

palabra_secreta = random.choice(palabras).lower()
letras_adivinadas = []
vidas = 7
adivinada = False
intentos = 0

print("El ahorcado")
print(f"La palabra tiene {len(palabra_secreta)} caracteres.")

while vidas > 0 and not adivinada:
    mostrar = ""
    for letra in palabra_secreta:
        if letra == " ":
            mostrar += "  "
        elif letra in letras_adivinadas:
            mostrar += letra + " "
        else:
            mostrar += "_ "

    print(f"\nPalabra: {mostrar}")
    print(f"Vidas: {vidas} | Letras usadas: {' '.join(letras_adivinadas)}")

    intento = input("Di una letra: ").lower()

    if len(intento) != 1 or not intento.isalpha():
        print("Ingresa una sola letra.")
        continue

    if intento in letras_adivinadas:
        print("Ya usaste esa letra.")
        continue

    intentos += 1
    letras_adivinadas.append(intento)

    if intento in palabra_secreta:
        print("Esa letra sí está.")
        adivinada = all(
            letra == " " or letra in letras_adivinadas
            for letra in palabra_secreta
        )
    else:
        vidas -= 1
        print("Esa letra no está. Pierdes una vida.")

if adivinada:
    print(f"\n¡Ganaste! La palabra era: {palabra_secreta}")
else:
    print(f"\nPerdiste. La palabra era: {palabra_secreta}")

print(f"Usaste {intentos} intentos.")
