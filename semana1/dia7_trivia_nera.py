"""
=============================
🧠 TRIVIA ÑERA — DÍA DE FUNCIONES
=============================

INSTRUCCIONES:
-------------
Hoy NO hay código viejo. Hoy empiezas desde cero.
Vas a construir un juego de preguntas y respuestas.

CONCEPTO NUEVO: FUNCIONES (def)
--------------------------------
Una función es como una "máquina" que hace un trabajo:

    entrada → [ FUNCIÓN ] → salida

Ejemplo:
    def doblar(numero):
        return numero * 2

    resultado = doblar(5)   # resultado vale 10

CONCEPTO NUEVO: DICCIONARIOS (dict)
------------------------------------
Un diccionario guarda parejas de "llave: valor":

    persona = {
        "nombre": "Cami",
        "edad": 11,
        "arma": "espada"
    }
    
    persona["nombre"]  →  "Cami"

TU MISIÓN (paso a paso):
-------------------------

PASO 1: Crear la función hacer_pregunta(pregunta, respuesta_correcta)
        - Muestra la pregunta con print
        - Pide la respuesta con input
        - Si acierta: suma 1 punto y felicita
        - Si falla: muestra la respuesta correcta
        - DEVUELVE 1 si acertó, 0 si falló

PASO 2: Crear la función mostrar_resultado(puntos, total)
        - Calcula el porcentaje (puntos * 100 / total)
        - Muestra un rango según el puntaje:
          100%      → "¡RANGO: DIOS ÑERO! 👑"
          60-99%    → "¡RANGO: ÑERO AVANZADO! 😎"
          30-59%    → "RANGO: ÑERO EN ENTRENAMIENTO 📚"
          0-29%     → "RANGO: ÑERO BEBÉ 👶"

PASO 3: Crear la lista de preguntas (mínimo 5 preguntas)
        Cada pregunta es un diccionario:
        {"pregunta": "¿...?", "respuesta": "..."}

PASO 4: El programa principal:
        - Da la bienvenida
        - Recorre todas las preguntas con un for
        - Llama a hacer_pregunta() para cada una
        - Al final llama a mostrar_resultado()

EJEMPLO DE CÓMO DEBE FUNCIONAR:
--------------------------------
🧠 ¡BIENVENIDO A LA TRIVIA ÑERA! 🧠
Responde las siguientes preguntas...

Pregunta 1/5:
¿Cuál es la capital de Colombia?
Tu respuesta: Bogotá
✅ ¡Correcto!

Pregunta 2/5:
¿Cuánto es 2 + 2?
Tu respuesta: 5
❌ ¡Fallaste! La respuesta era: 4

... etc ...

==============================
📊 RESULTADO FINAL 📊
Acertaste 3 de 5 (60%)
RANGO: ÑERO AVANZADO 😎
==============================

RETO EXTRA (si te sobra tiempo):
---------------------------------
- Agrega la opción de volver a jugar
- Las preguntas salen en orden aleatorio
- Agrega un límite de tiempo (pista: no uses time, solo cuenta intentos)
"""

# ⬇️ ESCRIBE TU CÓDIGO AQUÍ ABAJO ⬇️



# PASO 1: Función hacer_pregunta
def hacer_pregunta(pregunta, respuesta):
    print(pregunta)
    jugador = input("Tu respuesta: ").lower()
    if jugador == respuesta.lower():
        print("✅ ¡correcto!")
        return 1
    print(f"❌ Fallaste. La respuesta era: {respuesta}")
    return 0
# PASO 2: Función mostrar_resultado
    
def mostrar_resultados(puntos, total):

    porcentaje = int(puntos * 100 / total)


    print(f"acertaste {puntos} de {total} ({porcentaje}%)")

    if porcentaje == 100:
        print("¡RANGO: DIOS ÑERO! 👑")
    elif porcentaje >= 60:
        print("¡RANGO: ÑERO AVANZADO! 😎")
    elif porcentaje >= 30:
        print("RANGO: ÑERO EN ENTRENAMIENTO 📚")
    else:
        print("RANGO: ÑERO BEBÉ 👶")

# PASO 3: Banco de preguntas
preguntas = [
    {"pregunta": "¿que que arma elige un ñero, la pata de cabra o el cuchillo mata ganao?", "respuesta": "la pata de cabra"},
    {"pregunta": "¿cauntas rayas tiene una prenda adidas positiva para ñeros?", "respuesta": "cuatro rayas"},
    {"pregunta": "¿el ñero compra su ropa en las tiendas piolin o en el mercado de las pulgas?", "respuesta": "el mercado de las pulgas"},
    {"pregunta": "¿dode estudian los ñeros en el SENA o en los Andes?", "respuesta": "los Andes"},
    {"pregunta": "¿el ñero costeño se caratexrisa por: la empanada o caribañola?", "respuesta": "caribañola"},
    {"pregunta": "¿la carrera de los ñeros es: socíología o medicina?", "respuesta": "medicina"},
    {"pregunta": "¿ ( verdadero o falso)el ser humano no nacio para trabajar eso es una imposición social?", "respuesta": "verdadero"},
    {"pregunta": "¿quien es la esposa de infantino, pista, juega football?", "respuesta": "Messi"},
    {"pregunta": "¿nombre de un perro rotwiler de un ñero: Satan o pastelito?", "respuesta": "pastelito"},
    {"pregunta": "¿Cualquier ñero sabrá la respuesta a esta ecuación: $ax² + bx + c = ?", "respuesta": "0"}
 ]

# PASO 4: Programa principal
print("=" * 40)
print("🧠 ¡BIENVENIDO A LA TRIVIA ÑERA!🧠")
print("=" * 40)
print(f"Son {len (preguntas)} preguntas. ¡A darle!\n")

puntos = 0

for i, pregunta in enumerate(preguntas):
    print(f"\n--- Pregúnta {i+1} de {len(preguntas)} ---")
    puntos += hacer_pregunta(pregunta["pregunta"], pregunta["respuesta"])

print("\n" + "=" * 40)
print("📊 RESULTADO FINAL 📊")
print("=" * 40)
mostrar_resultados(puntos, len(preguntas))

