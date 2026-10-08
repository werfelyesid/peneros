import random

palabras = ["esternocleidomastoideo", "papa yesid", "empapado", "ñerito", "DTMF", "terminator", "la abejita maya", "la cebolla", "lo que la mama mas teme", "maduro petro y diddy en la carsel"]

# el dibujo del ahorcado segun las vidas que quedan: dibujos[vidas]
dibujos = [
    # 0 vidas: perdiste
    r"""   +---+
   |   |
   X   |
  /|\  |
  / \  |
       |
  =========""",
    # 1 vida: cuerpo completo
    r"""   +---+
   |   |
   O   |
  /|\  |
  / \  |
       |
  =========""",
    # 2 vidas: le falta una pierna
    r"""   +---+
   |   |
   O   |
  /|\  |
  /    |
       |
  =========""",
    # 3 vidas: los dos brazos, sin piernas
    r"""   +---+
   |   |
   O   |
  /|\  |
       |
       |
  =========""",
    # 4 vidas: le falta un brazo
    r"""   +---+
   |   |
   O   |
  /|   |
       |
       |
  =========""",
    # 5 vidas: solo la cabeza y el cuerpo
    r"""   +---+
   |   |
   O   |
   |   |
       |
       |
  =========""",
    # 6 vidas: solo la cabeza
    r"""   +---+
   |   |
   O   |
       |
       |
       |
  =========""",
    # 7 vidas: la horca vacia
    r"""   +---+
   |   |
       |
       |
       |
       |
  =========""",
]

palabra_secreta = random.choice(palabras)
letra = ""
vidas = 7
adivinada = False
letras_adivinadas = []

print("EL AHORCADO")
print(f" la palabra tiene {len(palabra_secreta)} letras")

while vidas > 0 and not adivinada:
    print(dibujos[vidas])

    mostrar = ""
    for caracter in palabra_secreta:
        if caracter == " " or caracter.lower() in letras_adivinadas:
            mostrar += caracter + " "
        else:
            mostrar += "_ "

    print(mostrar)
    print(f"vidas: {vidas}   |    letras_usadas: {' '.join(letras_adivinadas)}")

    letra = input("di una letra: ").lower()

    if len(letra) != 1:
        print("una sola letra")
        continue

    if not letra.isalpha():
        print("solo letras, sin numeros ni simbolos")
        continue

    if letra in letras_adivinadas:
        print("esa letra ya esta")
        continue

    letras_adivinadas.append(letra)

    if letra in palabra_secreta.lower():
        print("esa letra si esta")
    else:
        vidas -= 1
        print("esa letra no esta, pierdes una vida")

    if all(caracter == " " or caracter.lower() in letras_adivinadas for caracter in palabra_secreta):
        adivinada = True

    print("=" * 35)

if adivinada:
    print(f" ganaste! la palabra era {palabra_secreta}")
else:
    print(dibujos[0])
    print(f"perdiste, la palabra era {palabra_secreta}")
print(f"usaste {len(letras_adivinadas)} letras")