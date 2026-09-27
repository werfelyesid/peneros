"""
=============================================
🕵️ OPERACIÓN CIFRADO SECRETO
=============================================
Agente Cami, ¡necesitamos tu ayuda!

El malvado Dr. Bugs escondió un tesoro y dejó un
MENSAJE SECRETO cifrado. Tu misión: construir una
MÁQUINA DE CIFRADO para descifrarlo.

Para esto vas a usar un truco muy antiguo llamado
CIFRADO CÉSAR: se desplaza cada letra del abecedario
un número fijo de posiciones.

  Ejemplo (clave = 3):
    hola  →  krod
    porque cada letra avanza 3: h→k, o→r, l→o, a→d

CONCEPTOS NUEVOS QUE VAS A APRENDER HOY:
-----------------------------------------
1. Trabajar con STRINGS como listas de letras (for letra in texto)
2. El operador %  (módulo) → el "resto" de una división.
   Sirve para que la 'z' + 3 vuelva a la 'a' y no se salga.
   Ejemplo: (25 + 3) % 26 = 2  →  vuelve a la 'c'
3. Métodos de texto: .lower(), .isalpha(), .split()
4. Hacer que la COMPUTADORA deduzca sola (¡mini-IA!)

=============================================
"""

# Ya te dejamos estas constantes listas 👇

# Puedes AGREGAR la ñ si quieres: "abcdefghijklmnñopqrstuvwxyz"
ALFABETO = "abcdefghijklmnopqrstuvwxyz"
# Lista de palabras comunes en español.
# La usaremos para que la computadora "adivine" cuál
# descifrado tiene sentido (Misión 3).
PALABRAS = ["el", "la", "los", "las", "y", "de", "en", "es",
            "un", "una", "que", "con", "por", "para", "esta"]

# ═══════════════════════════════════════════════════════
#  MISIÓN 1 — LA MÁQUINA DE CIFRAR 🛠️
# ═══════════════════════════════════════════════════════
# Crea una función llamada cifrar(texto, clave)
# que reciba un texto y un número (clave) y devuelva
# el texto cifrado.
#
# REGLAS:
#   ✅ Recorre letra por letra (for letra in texto)
#   ✅ Solo cifra letras del abecedario.
#      Los espacios y signos se quedan igual.
#   ✅ Convierte a minúsculas antes de cifrar.
#   ✅ Usa ALFABETO.index(letra) para saber la posición
#      y la fórmula:  nueva_pos = (pos + clave) % 26
#   ✅ PISTA: ALFABETO[nueva_pos] te da la letra nueva
#
# EJEMPLO:
#   cifrar("hola", 3)  →  "krod"
#   cifrar("zapato", 3)  →  "cdsdwr"   (¡la z da la vuelta!)

# ═══════════════════════════════════════════════════════
#  MISIÓN 2 — LA MÁQUINA DE DESCIFRAR 🔓
# ═══════════════════════════════════════════════════════
# Crea la función descifrar(texto, clave) que haga lo
# CONTRARIO de la Misión 1.
#
# REGLAS:
#   ✅ Igual que cifrar, pero en vez de sumar la clave,
#      la RESTA:  nueva_pos = (pos - clave) % 26
#   ✅ Debe devolver el texto original
#
# EJEMPLO:
#   descifrar("krod", 3)  →  "hola"
#
# 💡 TRUCO DE ESPÍA: si ya hiciste la Misión 1,
#    puedes "reusarla" así:
#      return cifrar(texto, 26 - clave)
#    ¡Porque girar 3 a la derecha es lo mismo que
#    girar 23 a la izquierda! (26 - 3 = 23)

# ═══════════════════════════════════════════════════════
#  MISIÓN 3 — EL HACKER DE MENSAJES 🤖 (tu mini-IA)
# ═══════════════════════════════════════════════════════
# Crea la función forzar(texto) que reciba un mensaje
# cifrado SIN saber la clave, y descubra la clave sola.
#
# REGLAS:
#   ✅ Prueba TODAS las claves posibles (0 hasta 25):
#      for clave in range(26)
#   ✅ Para cada clave, descifra el texto.
#   ✅ Cuenta cuántas palabras de PALABRAS aparecen en
#      el resultado (busca " el " por si acaso).
#      Guarda: la clave, el texto y su puntaje.
#   ✅ Al final, muestra el resultado que tenga
#      el MEJOR puntaje.
#   ✅ También imprime el mensaje final en MAYÚSCULAS:
#      ¡crackeado! 🎉
#
# 💡 PISTA:
#   puntaje = 0
#   for palabra in PALABRAS:
#       if " " + palabra + " " in texto_descifrado:
#           puntaje = puntaje + 1
#
# EJEMPLO DE SALIDA:
#   🔓 Clave encontrada: 3
#   📜 Mensaje secreto: EL TESORO ESTA ESCONDIDO EN LA BIBLIOTECA

# ═══════════════════════════════════════════════════════
#  MISIÓN 4 — EL PROGRAMA PRINCIPAL 🚀
# ═══════════════════════════════════════════════════════
# Haz un menú como este:
#
#   🕵️ OPERACIÓN CIFRADO SECRETO 🕵️
#   1. Cifrar mi mensaje
#   2. Descifrar (con clave)
#   3. ¡Crackear un mensaje secreto!  ← la más divertida
#   4. Salir
#
# ✅ Valida que la opción sea 1, 2, 3 o 4
# ✅ Valida que la clave sea un número entre 1 y 25
# ✅ En la opción 3, pásale a forzar() este mensaje
#    que interceptamos del Dr. Bugs:
#    "ho whvrur hvwd hvfrqglgr hq od eleolrwhfd"
#    ¿Qué escondió el Dr. Bugs? 👀
#
# ⬇️ ESCRIBE TUS FUNCIONES Y EL MENÚ AQUÍ ABAJO ⬇️

# ═══════════════════════════════════════════════════════
#  MISIÓN 1 — LA MÁQUINA DE CIFRAR 🛠️
# ═══════════════════════════════════════════════════════
# Crea una función llamada cifrar(texto, clave)
# que reciba un texto y un número (clave) y devuelva
# el texto cifrado.
#
# REGLAS:
#   ✅ Recorre letra por letra (for letra in texto)
#   ✅ Solo cifra letras del abecedario.
#      Los espacios y signos se quedan igual.
#   ✅ Convierte a minúsculas antes de cifrar.
#   ✅ Usa ALFABETO.index(letra) para saber la posición
#      y la fórmula:  nueva_pos = (pos + clave) % 26
#   ✅ PISTA: ALFABETO[nueva_pos] te da la letra nueva
#
# EJEMPLO:
#   cifrar("hola", 3)  →  "krod"
#   cifrar("zapato", 3)  →  "cdsdwr"   (¡la z da la vuelta!)

def cifrar_texto(texto, clave):
    resultado = ""
    texto = texto.lower()
    ALFABETO = "abcdefghijklmnopqrstuvwxyz"
    for letra in texto:
        if letra in ALFABETO:
            pos = ALFABETO.index(letra)
            nueva_pos = (pos + clave) % 26
            letra_nueva = ALFABETO[nueva_pos]
            resultado = resultado + letra_nueva 
        else:    
            resultado = resultado + letra
    return resultado


# (las pruebas se hacen al final, ejecutando el menú de la Misión 4)

def forzar(texto):
    print("\n🤖 FUERZA BRUTA: probando las 26 claves posibles...\n")

    mejor_puntaje = -1
    clave_ganadora = 0
    mensaje_ganador = ""

    for clave in range(26):
        intento = cifrar_texto(texto, 26 - clave)

        puntaje = 0
        for palabra in PALABRAS:
            if " " + palabra + " " in " " + intento + " ":
                puntaje += 1

        print(f"    clave {clave:2d} → {intento}    (puntaje: {puntaje})")

        if puntaje > mejor_puntaje:
            mejor_puntaje = puntaje
            clave_ganadora = clave
            mensaje_ganador = intento

    print("\n" + "=" * 44)
    print("Clave encontrada: " + str(clave_ganadora))
    print("Mensaje secreto: " + mensaje_ganador.upper())
    print("🤖" * 44)


# ═══════════════════════════════════════════════════════
#  MISIÓN 2 — LA MÁQUINA DE DESCIFRAR 🔓
# ═══════════════════════════════════════════════════════
def descifrar_texto(texto, clave):
    # Truco de espía: descifrar = cifrar hacia atrás (26 - clave)
    return cifrar_texto(texto, 26 - clave)


# ═══════════════════════════════════════════════════════
#  MISIÓN 4 — EL PROGRAMA PRINCIPAL 🚀
# ═══════════════════════════════════════════════════════
MENSAJE_SECRETO = "ho whvrur hvwd hvfrqglgr hq od eleolrwhfd"


def pedir_clave():
    """Pide una clave válida (1 a 25) y la devuelve como número."""
    while True:
        entrada = input("   🔑 Escribe la clave (1-25): ").strip()
        if entrada.isdigit() and 1 <= int(entrada) <= 25:
            return int(entrada)
        print("   ⚠️  Debe ser un número entre 1 y 25. Intenta otra vez.")


def menu():
    """El programa principal: muestra el menú y hace la acción elegida."""
    while True:
        print("\n" + "=" * 44)
        print("🕵️  OPERACIÓN CIFRADO SECRETO 🕵️")
        print("=" * 44)
        print("1. Cifrar mi mensaje")
        print("2. Descifrar (con clave)")
        print("3. ¡Crackear un mensaje secreto!")
        print("4. Salir")

        opcion = input("   Elige una opción (1-4): ").strip()

        if opcion == "1":
            texto = input("   ✍️  Escribe el mensaje a cifrar: ")
            clave = pedir_clave()
            print("   🔒 Cifrado: " + cifrar_texto(texto, clave))

        elif opcion == "2":
            texto = input("   ✍️  Escribe el mensaje a descifrar: ")
            clave = pedir_clave()
            print("   🔓 Descifrado: " + descifrar_texto(texto, clave))

        elif opcion == "3":
            forzar(MENSAJE_SECRETO)

        elif opcion == "4":
            print("   👋 ¡Hasta la próxima, agente Cami!")
            break

        else:
            print("   ⚠️  Opción inválida. Elige 1, 2, 3 o 4.")


menu() 
