

'''PASO 1: Crear la función hacer_pregunta(pregunta, respuesta_correcta)
        - Muestra la pregunta con print
        - Pide la respuesta con input
        - Si acierta: suma 1 punto y felicita
        - Si falla: muestra la respuesta correcta
        - DEVUELVE 1 si acertó, 0 si falló'''

def hacer_pregunta(pregunta, respuesta):
    print(pregunta)
    jugador = input("escibr tu respuesta \n>>>: ").lower()
    if jugador == respuesta.lower():
        print("correcto")
        return 1
    print(f"mallll la respuesta era {respuesta}")
    return 0

def mostrar_resultados(puntos, total):
    porcentaje = int( 100 * puntos / total)

    print(f"caertaste {puntos} de {total} ({porcentaje}%)")

    if porcentaje == 100:
        print("¡RANGO: DIOS ÑERO! 👑")
    elif porcentaje >= 60:
        print("¡RANGO: ÑERO AVANZADO! 😎")
    elif porcentaje >= 40:
        print("¡RANGO: ÑERO EN ENTRENAMIENTO!")
    elif porcentaje >= 30:
        print("¡RANGO: ÑERO BEBE!")

preguntas = [
            {"pregunta": "¿comida favorita del ñero: śúśhí o chicharrón(sin tilde)?", "respuesta": "chicharron"},
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

print("🦖" * 40)
print("🧠 ¡BIENVENIDO A LA TRIVIA ÑERA! 🧠")
print("🦖" * 50)
print(f"Son {len(preguntas)} preguntas. vamo\n")

puntos = 0
for i, p in enumerate(preguntas):
    print(f"\n--- Pregunta {i+1} de {len(preguntas)} ---")
    puntos += hacer_pregunta(p["pregunta"], p["respuesta"])

print("\n" + "=" * 40)
print("📊 RESULTADO FINAL 📊")
print("=" * 40)
mostrar_resultados(puntos, len(preguntas))