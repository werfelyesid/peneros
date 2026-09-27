

'''PASO 1: Crear la función hacer_pregunta(pregunta, respuesta_correcta)
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
          0-29%     → "RANGO: ÑERO BEBÉ 👶"'''

def hacer_pregunta(pregunta, respuesta):
    print(pregunta)
    jugador = input("escribe tu respuesta\n>>>: ")
    if jugador == respuesta.lower():
        print("correcto")
        return 1
    print("malll")
    return 0

def mostrar_resultados(puntos, total):
    porcentaje = int(puntos * 100 / total)
    print(f"acertaste {puntos} de {total} ({porcentaje}%)")

    if porcentaje == 100:
        print("¡RANGO: DIOS ÑERO! 👑")
    elif porcentaje >= 60:
        print("¡RANGO: ñero profesional!")
    elif porcentaje >= 40:
        print("¡RANGO: ñero en entrenamiento!")
    elif porcentaje >= 10:
        print("¡RANGO: ñero bebe! 👑")
puntos = 0

def hacer_pregunta(pregunta,respuesta):
    print(pregunta)
    jugador = (input("escribe tu respuesta \n >>>: "))
    if jugador == respuesta:
        print("bien⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️")
        return 1
    else:
        print("malll⚠️⚠️⚠️")
        return 0

preguntas = [  {"pregunta": "¿que que arma elige un ñero, la pata de cabra o el cuchillo mata ganao?", "respuesta": "la pata de cabra"},
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

print("🧠 ¡BIENVENIDO A LA TRIVIA ÑERA!🧠")
print(">" * 300)
print("son {len(preguntas)} preguntas, vamo a darle")
mostrar_resultados(puntos, len(preguntas))
