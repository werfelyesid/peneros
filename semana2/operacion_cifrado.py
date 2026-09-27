ALFABETO = "abcdefghijklmnopqrstuvwxyz"
# Lista de palabras comunes en español.
# La usaremos para que la computadora "adivine" cuál
# descifrado tiene sentido (Misión 3).
PALABRAS = ["el", "la", "los", "las", "y", "de", "en", "es",
            "un", "una", "que", "con", "por", "para", "esta"]

def cifrar_texto(texto, clave):

    resultado = ""
    texto = texto.lower()
    ALFABETO = "abcdefghijklmnopqrstuvwxyz"
    for letra in texto:
        if letra in ALFABETO:
            pos = ALFABETO.index(letra)
            nueva_pos = (pos + clave) % 26
            letra_nueva = ALFABETO[nueva_pos]
            resulutado = resultado + letra_nueva
        else:
            resultado = resultado + letra
    return resultado

def forzar(texto):
    print("\n🤖 FUERZA BRUTA: probando las 26 claves posibles... \n")

    mejor_puntaje = -1
    clave_ganadora = 0
    mensaje_ganador = ""

    for clave in range(26):
        intento = cifrar_texto(texto, 26 - clave)

        puntaje = 0
        for palabra in PALABRAS:
            if " " + palabra + " " in " " + " ":
                puntaje +=1

        print(f"    clave {clave:2d} → {intento}    (puntaje: {puntaje})")

        if puntaje > mejor_puntaje:
            mejor_puntaje = puntaje
            clave_ganadora = clave
            mensaje_ganador = intento

    print("\n" + "=" * 44)
    print("clave encontrada: " + str(clave_ganadora))
    print("mensaje secreto: " + mensaje_ganador.upper)
    print("🤖" * 44)

def descifrar_texto(texto, clave):
    return cifrar_texto(texto, 26 - clave)

MENSAJE_SECRETO = "ho whvrur hvwd hvfrqglgr hq od eleolrwhfd"

def pedir_clave():
    while True:
        entrada = input("   Escribe la clave (1-25): ").strip()
        if entrada.isdigit() and 1 <= int(entrada) <= 25:
            return int(entrada)
        print("    Debe ser un numero entre 1 25. Vuelve a intentar")


def menu():
    while True:
        print("\n" + "=" * 44)
        print("🕵️  OPERACIÓN CIFRADO SECRETO 🕵️")
        print("=" * 44)    
        print("1. Cifrar el mensaje")
        print("2. Descifrar (con clave)")
        print("3. ¡Crackear un mensaje secreto!")
        print("4. Salir")

        opcion = input("   Elige una opción (1-4): ").strip()

        if opcion == "1":
            texto = input("    Escribe el mensaje a cifrar: ")
            clave = pedir_clave()
            print("     cifrado: " + cifrar_texto(texto, clave))

        elif opcion == "2":
            texto = input("     escribe el menaje a desifrar: ")
            clave = pedir_clave()
            print("    Desifrado: " + descifrar_texto(texto, clave))

        elif opcion == "3":
            forzar(MENSAJE_SECRETO)

        elif opcion == "4":
            print("    ¡Hasta la proxima, agente Cami!")
            break

        else:
            print("   Opción inválida. Elije 1,2,3,4")


menu()




