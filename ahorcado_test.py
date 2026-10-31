import random

palabras = ["esternocleidomastoideo", "papa yesid", "empapado", "ñerito", "DTMF"]

palabra_secreta = random.choice(palabras).lower()
letras_adivinadas = []
vidas = 7
intentos = 0
adivinada = False

print("el ahorcado")
print(f"la palabra tiene {len(palabra_secreta)} caracteres")

while vidas > 0 and not adivinada:
    mostrar = ""
    for letra in palabra_secreta:
        if letra in letras_adivinadas:
            mostrar += letra + " "
        else:
            mostrar += "_ "

    print(f"palabra: {mostrar}")
    print(f"vidas: {vidas}      |         letras usadas: {' '.join(letras_adivinadas)}")

    intento = input("di una letra: ").lower()

    if len(intento) != 1 or not intento.isalpha():
        print("una sola letra")
        continue

    if intento in letras_adivinadas:
        print("esa letra ya esta")
        continue

    intentos += 1
    letras_adivinadas.append(intento)

    if intento in palabra_secreta:
        print("esa letra si esta")
        adivinada = all(letra == " " or letra in letras_adivinadas for letra in palabra_secreta)
    else:
        vidas -= 1
        print("esa letra no esta pierdes una vida")

if adivinada:
    print(f"ganaste la palabra era {palabra_secreta}")
else:
    print(f"perdiste la palabra era {palabra_secreta}")
print(f"usaste {intentos} intento(s)")