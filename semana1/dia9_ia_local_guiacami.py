"""
╔══════════════════════════════════════════════════════════════════╗
║           🧠 DÍA 9: INTELIGENCIA ARTIFICIAL EN TU COMPU        ║
║              Guía para Cami - ¡Tú eres el piloto!              ║
╚══════════════════════════════════════════════════════════════════╝

¡Hola Cami! Hoy empieza algo MUY diferente. Hasta ahora has creado juegos
en Python (piedra-papel-tijera, trivia, ahorcado...).
 ¡Pero ahora vas a
crear INTELIGENCIA ARTIFICIAL que corra en tu propio computador!
Lo mejor: NO necesitas internet después de descargar los modelos.
Todo corre LOCAL, en tu máquina.

═══════════════════════════════════════════════════════════════════
📚 CONCEPTOS BÁSICOS (léelos con calma, no hay prisa)
═══════════════════════════════════════════════════════════════════
"""

# ─────────────────────────────────────────────────────────────
# CONCEPTO 1: ¿QUÉ ES UN ENTORNO VIRTUAL (venv)?
# ─────────────────────────────────────────────────────────────
# Imagina que tienes una caja de herramientas para carpintería y
# otra para electricidad. No quieres mezclarlas, ¿verdad?
#
# Un venv es EXACTAMENTE eso: una "caja de herramientas" separada
# para cada proyecto Python. Así las herramientas (librerías) de
# un proyecto no chocan con las de otro.

# EJEMPLO DE LA VIDA REAL:
#   Proyecto "Juegos Peñeros"  → caja con: random, time, json
#   Proyecto "IA Local"        → caja con: torch, transformers
#
# Si no usaras venv, ¡sería como tener todas las herramientas
# revueltas en una sola caja gigante!

"""
┌─────────────────────────────────────────────────────────────┐
│ ANALOGÍA para Cami:                                         │
│                                                             │
│  venv = TU HABITACIÓN para este proyecto                    │
│                                                             │
│  Cuando entras a tu habitación (activar venv), todo lo      │
│  que instalas se queda AHÍ. No afecta al resto de la casa.  │
│                                                             │
│  Cuando sales (desactivar venv), vuelves al espacio común.  │
└─────────────────────────────────────────────────────────────┘
"""


# ─────────────────────────────────────────────────────────────
# CONCEPTO 2: ¿QUÉ ES pip?
# ─────────────────────────────────────────────────────────────
# pip = "Pip Installs Packages" (sí, es un acrónimo recursivo 😄)
#
# pip es el INSTALADOR de Python. Como cuando quieres descargar
# un juego en tu celular desde la Play Store, pip descarga
# "librerías" (código que otros ya escribieron) desde internet.
#
# SIN pip: Tendrías que escribir TODO desde cero 😱
# CON pip:   pip install transformers  → ¡listo, IA en segundos!

"""
┌─────────────────────────────────────────────────────────────┐
│ EJEMPLO para Cami:                                          │
│                                                             │
│  Quieres hacer una pizza. Tienes dos opciones:              │
│                                                             │
│  Opción A (sin pip):                                        │
│    → Cultivar el trigo, molerlo, hacer harina               │
│    → Ordeñar la vaca, hacer queso                           │
│    → Sembrar tomates... ¡3 meses después comes pizza!       │
│                                                             │
│  Opción B (con pip):                                        │
│    → pip install masa                                       │
│    → pip install queso                                      │
│    → pip install salsa                                      │
│    → ¡Pizza en 5 minutos!                                   │
│                                                             │
│  pip = Rappi de las librerías de Python 🛵                  │
└─────────────────────────────────────────────────────────────┘
"""


# ─────────────────────────────────────────────────────────────
# CONCEPTO 3: ¿QUÉ ES PyTorch?
# ─────────────────────────────────────────────────────────────
# PyTorch = "Antorcha Python" 🏮
#
# Es el MOTOR que hace funcionar la IA. Como el motor de un carro:
# tú no ves el motor, pero sin él el carro no se mueve.
#
# PyTorch se encarga de:
#   → Hacer millones de operaciones matemáticas por segundo
#   → Manejar "tensores" (como matrices pero en 3D, 4D...)
#   → Entrenar y ejecutar redes neuronales

"""
┌─────────────────────────────────────────────────────────────┐
│ PyTorch en ACCIÓN (ejemplo conceptual):                     │
│                                                             │
│  Imagina que tienes una foto de un perro.                   │
│                                                             │
│  Tus ojos ven: 🐶 "¡Es un Golden Retriever!"                │
│                                                             │
│  PyTorch hace esto mismo pero con matemáticas:              │
│    1. Convierte la foto en una matriz de números            │
│       [0.2, 0.8, 0.1, 0.9, 0.3, ...]                       │
│    2. Multiplica por "pesos" (aprendidos entrenando)        │
│    3. Capa por capa, detecta: borde → oreja → hocico        │
│    4. Resultado: "95% seguro que es un perro"               │
│                                                             │
│  ¡Y esto lo hace en MILISEGUNDOS!                           │
└─────────────────────────────────────────────────────────────┘
"""


# ─────────────────────────────────────────────────────────────
# CONCEPTO 4: ¿QUÉ ES TRANSFORMERS?
# ─────────────────────────────────────────────────────────────
# Transformers es una librería de Hugging Face (una empresa que
# democratiza la IA). Contiene MODELOS ya entrenados.
#
# Piensa en esto:
#   PyTorch    = el motor del carro 🚗
#   Transformers = el carro completo listo para conducir 🏎️
#
# Sin transformers: tendrías que CONSTRUIR la red neuronal desde cero
# Con transformers:   pipeline("sentiment-analysis") → ¡funciona!

"""
┌─────────────────────────────────────────────────────────────┐
│ ¿Qué es un MODELO?                                          │
│                                                             │
│ Un modelo de IA es como un CEREBRO ya educado.              │
│                                                             │
│ Imagina que entrenas a Simón (tu perro):                    │
│   - Le dices "siéntate" 1000 veces                          │
│   - Le das premio cuando lo hace bien                       │
│   - Después de mucho entrenar, Simón APRENDE                │
│                                                             │
│ Un modelo de IA es IGUAL:                                   │
│   - Le muestras MILLONES de ejemplos ("esto es triste")     │
│   - Ajusta sus "neuronas" (pesos matemáticos)               │
│   - Al final, SABE distinguir emociones en texto            │
│                                                             │
│ La diferencia: Simón tardó semanas. La IA tarda horas/días  │
│ pero con computadores potentes. ¡Y tú descargas el cerebro  │
│ ya entrenado!                                               │
└─────────────────────────────────────────────────────────────┘
"""


# ─────────────────────────────────────────────────────────────
# CONCEPTO 5: ¿POR QUÉ "LOCAL" Y NO EN LA NUBE?
# ─────────────────────────────────────────────────────────────

"""
┌──────────────────────────────────────────────────────────────────┐
│              IA EN LA NUBE vs IA LOCAL                           │
├─────────────────────────────┬────────────────────────────────────┤
│  ChatGPT (nube) 🌐          │  Tu IA Local 💻                    │
├─────────────────────────────┼────────────────────────────────────┤
│  Necesitas internet SIEMPRE │  Funciona SIN internet             │
│  Tus datos van a servidores │  Tus datos NUNCA salen de tu PC    │
│  Pagas por uso (API)        │  GRATIS después de descargar       │
│  No sabes qué pasa dentro   │  Tú controlas TODO                 │
│  Limitado por la empresa    │  Ilimitado, es TUYO                │
├─────────────────────────────┼────────────────────────────────────┤
│  Ejemplo: preguntar a       │  Ejemplo: tu asistente personal    │
│  ChatGPT "¿qué es Python?"  │  que corre offline en tu laptop    │
└─────────────────────────────┴────────────────────────────────────┘
"""


# ═══════════════════════════════════════════════════════════════
# PASO A PASO (MANOS A LA OBRA, CAMI)
# ═══════════════════════════════════════════════════════════════

print("🧠 Bienvenido a tu viaje de IA Local, Cami!")
print("=" * 50)


# ─────────────────────────────────────────────────────────────
# PASO 1: ABRE UNA TERMINAL Y CREA LA CARPETA
# ─────────────────────────────────────────────────────────────
#
# Instrucciones para Cami:
#
#   1. Abre la terminal (Ctrl + ` en VS Code, o busca "Terminal")
#   2. Escribe línea por línea y presiona ENTER después de cada una:
#
#       cd ~
#       mkdir ia_cami
#       cd ia_cami
#
#   ¿Qué hace cada línea?
#     cd ~          → "change directory" a tu carpeta personal (/home/cami)
#     mkdir ia_cami → "make directory" = crea la carpeta "ia_cami"
#     cd ia_cami    → entra a la carpeta que acabas de crear
#
#   ✅ CHECKPOINT: Si escribes 'pwd' debe mostrar /home/cami/ia_cami

print("\n📁 PASO 1 completado: Carpeta 'ia_cami' lista para tu proyecto")


# ─────────────────────────────────────────────────────────────
# PASO 2: CREAR ENTORNO VIRTUAL
# ─────────────────────────────────────────────────────────────
#
# En la terminal, escribe:
#
#   python3 -m venv .venv
#
#   ¿Qué significa cada parte?
#     python3  → llama al programa Python versión 3
#     -m venv  → "-m" = módulo, "venv" = Virtual Environment
#                Estás diciendo: "Python, ejecuta el módulo venv"
#     .venv    → nombre de la carpeta donde vivirá el entorno virtual
#                El punto (.) la hace oculta (no molesta a la vista)
#
#   ✅ CHECKPOINT: Escribe 'ls -la' y deberías ver una carpeta .venv

print("\n📦 PASO 2 completado: Entorno virtual creado (.venv)")


# ─────────────────────────────────────────────────────────────
# PASO 3: ACTIVAR EL ENTORNO VIRTUAL
# ─────────────────────────────────────────────────────────────
#
# En la terminal:
#
#   source .venv/bin/activate
#
#   ¿Qué significa?
#     source  → "carga" un archivo en tu terminal actual
#     .venv/bin/activate → el archivo que configura todo
#
#   Después de ejecutarlo verás (.venv) al inicio de tu terminal.
#   ESO significa que estás DENTRO de tu habitación virtual.
#
#   🎮 Analogía gamer:
#     Sin venv  = estás en el menú principal
#     Con venv   = entraste a un nivel específico
#     El (.venv) = el HUD que te dice en qué nivel estás
#
#   ✅ CHECKPOINT: Tu terminal debe mostrar (.venv) al inicio

print("\n🔌 PASO 3 completado: Entorno virtual ACTIVADO (.venv)")


# ─────────────────────────────────────────────────────────────
# PASO 4: INSTALAR PyTorch (EL MOTOR)
# ─────────────────────────────────────────────────────────────
#
# ¡Momento de usar pip! En la terminal:
#
#   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
#
#   Vamos por partes (como dice Jack el Destripador):
#
#     pip install → "pip, instala esto por favor"
#     torch       → PyTorch, el motor de IA
#     torchvision → Herramientas para trabajar con IMÁGENES
#     torchaudio  → Herramientas para trabajar con AUDIO
#     --index-url → "busca los archivos en ESTA dirección web"
#     .../cpu     → versión para CPU (procesador normal)
#                   (si tuvieras tarjeta gráfica NVIDIA, usarías .../cu118)
#
#   ⏱️ Esto descarga como 200-700 MB. Tómate un descanso, camina un poco.
#
#   ✅ CHECKPOINT: Escribe 'pip list' y busca "torch" en la lista

print("\n🔥 PASO 4 completado: PyTorch instalado (el motor está listo)")


# ─────────────────────────────────────────────────────────────
# PASO 5: INSTALAR TRANSFORMERS (EL CARRO COMPLETO)
# ─────────────────────────────────────────────────────────────
#
# En la terminal:
#
#   pip install transformers huggingface_hub
#
#   ¿Qué es cada cosa?
#     transformers    → librería con modelos de IA pre-entrenados
#     huggingface_hub → herramienta para descargar modelos de Hugging Face
#
#   Hugging Face (🤗) es como el "GitHub de la IA":
#     - GitHub guarda CÓDIGO (como tus juegos .py)
#     - Hugging Face guarda MODELOS (cerebros de IA ya entrenados)
#
#   ✅ CHECKPOINT: 'pip list | grep transformers' debe mostrar la versión

print("\n🤗 PASO 5 completado: Transformers instalado")


# ─────────────────────────────────────────────────────────────
# PASO 6: TU PRIMER MODELO DE IA (¡FUNCIONA YA!)
# ─────────────────────────────────────────────────────────────
#
# Crea un archivo nuevo: mi_primera_ia.py
# Copia este código y ejecútalo con: python mi_primera_ia.py

print("\n" + "=" * 50)
print("🤖 EJECUTANDO TU PRIMER MODELO DE IA...")
print("=" * 50)

try:
    # Esto importa la librería que acabamos de instalar
    from transformers import pipeline

    # ──────────────────────────────────────────────────────
    # ¿QUÉ ES UN PIPELINE?
    # ──────────────────────────────────────────────────────
    # Un pipeline es como una "tubería" que conecta todo:
    #   Texto entra → modelo piensa → resultado sale
    #
    # Es la forma MÁS FÁCIL de usar IA. Solo necesitas:
    #   1. Decir qué TAREA quieres hacer
    #   2. Darle el texto
    #   3. ¡Recibir el resultado!
    #
    # Tareas disponibles:
    #   "sentiment-analysis"    → ¿esto es positivo o negativo?
    #   "text-generation"       → escribe texto nuevo
    #   "question-answering"    → responde preguntas
    #   "summarization"         → resume textos largos
    #   "translation"           → traduce entre idiomas
    #   "text-classification"   → clasifica en categorías
    # ──────────────────────────────────────────────────────

    print("\n📥 Descargando el modelo (solo la primera vez)...")
    print("   (Como descargar un juego de Steam: pesa una vez, luego carga rápido)\n")

    # Creamos el clasificador de emociones
    clasificador = pipeline(
        "sentiment-analysis",
        model="distilbert-base-uncased-finetuned-sst-2-english"
    )

    # ──────────────────────────────────────────────────────
    # ¿QUÉ MODELO ES ESTE?
    # "distilbert-base-uncased-finetuned-sst-2-english"
    #
    # Traducción:
    #   distilbert  → BERT "destilado" (versión comprimida, más rápida)
    #   base        → tamaño base (hay small, medium, large)
    #   uncased     → no distingue MAYÚSCULAS/minúsculas
    #   finetuned   → ya fue entrenado para una tarea específica
    #   sst-2       → Stanford Sentiment Treebank (dataset de emociones)
    #   english     → entiende inglés
    #
    # Este modelo pesa ~250 MB. La primera vez lo descarga.
    # Después queda guardado y carga instantáneo.
    # ──────────────────────────────────────────────────────

    print("✅ Modelo cargado. ¡Probemos!\n")

    # ──────────────────────────────────────────────────────
    # PRUEBA 1: Frases positivas y negativas
    # ──────────────────────────────────────────────────────
    frases = [
        "I love learning AI with Python!",
        "This is the worst day ever.",
        "Cami is creating artificial intelligence!",
        "The code has too many bugs and errors.",
        "The life is so short, but unexpected"
    ]

    for frase in frases:
        resultado = clasificador(frase)[0]
        emocion = resultado['label']       # POSITIVE o NEGATIVE
        confianza = resultado['score']      # 0.0 a 1.0 (qué tan seguro está)

        # Mostramos el resultado bonito
        barra = "█" * int(confianza * 20)
        emoji = "😊" if emocion == "POSITIVE" else "😢"

        print(f"  Texto:      \"{frase}\"")
        print(f"  Emoción:    {emocion} {emoji}")
        print(f"  Confianza:  {confianza:.2%} [{barra}]")
        print()

except Exception as e:
    print(f"\n⚠️  Ups, algo falló: {e}")
    print("\nRevisa que hayas completado los pasos anteriores.")


# ─────────────────────────────────────────────────────────────
# 🧪 EXPERIMENTOS PARA CAMI (¡tu turno de jugar!)
# ─────────────────────────────────────────────────────────────

print("\n" + "=" * 50)
print("🧪 AHORA TE TOCA A TI, CAMI")
print("=" * 50)
print("""
Prueba estas cosas (modifica el código y vuelve a ejecutar):

1. CAMBIA las frases por cosas que digas tú en inglés
   Ej: "I scored a goal today!" o "My dog ate my homework"

2. PRUEBA frases en español (aunque el modelo es de inglés)
   ¿Qué pasa? ¿Acierta o falla?

3. BUSCA en Hugging Face (https://huggingface.co/models)
   un modelo que entienda español. Pista: busca "spanish sentiment"

4. ¿Qué pasa si pones una frase NEUTRA como
   "The sky is blue" o "I ate bread"?
""")


# ═══════════════════════════════════════════════════════════════
# 🎮 RETO DEL DÍA
# ═══════════════════════════════════════════════════════════════

print("\n" + "=" * 50)
print("🎮 RETO: Crea tu propio analizador de emociones")
print("=" * 50)
print("""
Tu misión:
  1. Crea un archivo 'emociones_cami.py'
  2. El programa debe:
     a) Preguntar al usuario "¿Cómo te sientes hoy? (en inglés)"
     b) Analizar la respuesta con el modelo de IA
     c) Responder según la emoción detectada:
        - Si es POSITIVE → "¡Qué bien! Sigue así 💪"
        - Si es NEGATIVE → "Ánimo, mañana será mejor 🌈"
  3. BONUS: Haz que también detecte si es NEUTRAL
     (pista: mira el score/confianza, si es bajo = neutral)

¡Tú puedes, Cami! 💻🚀
""")


# ═══════════════════════════════════════════════════════════════
# 📋 RESUMEN DE COMANDOS (para que no se te olvide)
# ═══════════════════════════════════════════════════════════════

COMANDOS = """
┌──────────────────────────────────────────────────────────────────┐
│                    📋 CHET SHEET DE CAMI                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  CREAR PROYECTO:                                                 │
│    mkdir ia_cami && cd ia_cami                                   │
│                                                                  │
│  ENTORNO VIRTUAL:                                                │
│    python3 -m venv .venv          → Crear ambiente aislado       │
│    source .venv/bin/activate      → Entrar al ambiente           │
│    deactivate                     → Salir del ambiente           │
│                                                                  │
│  INSTALAR COSAS (con pip):                                       │
│    pip install <nombre>           → Instalar una librería        │
│    pip list                       → Ver lo instalado             │
│    pip uninstall <nombre>         → Desinstalar                  │
│                                                                  │
│  NUESTRAS LIBRERÍAS DE IA:                                       │
│    torch         = motor matemático (como pygame para juegos)    │
│    transformers  = modelos de IA listos (como tus juegos .py)    │
│    huggingface_hub = descargar modelos (como Steam)              │
│                                                                  │
│  EJECUTAR:                                                       │
│    python mi_primera_ia.py        → Correr tu código             │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
"""

print(COMANDOS)

# ═══════════════════════════════════════════════════════════════
# DICCIONARIO RÁPIDO PARA CAMI
# ═══════════════════════════════════════════════════════════════

DICCIONARIO = """
┌──────────────────────────────────────────────────────────────────┐
│               📖 DICCIONARIO GAMER DE IA                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  venv      = Tu "base" en Minecraft, tu territorio protegido     │
│  pip       = Tienda de la Play Store, descargas apps para Python │
│  torch     = Motor V8 del carro, la potencia bruta               │
│  modelo    = Cerebro ya educado (como un NPC con IA avanzada)    │
│  pipeline  = Tubería mágica: metes texto, sale resultado         │
│  tensor    = Matriz de números (como un tablero de Excel 3D)     │
│  GPU       = Tarjeta gráfica (acelera la IA como nitro en carro) │
│  CPU       = Procesador normal (confiable, aunque más lento)     │
│  dataset   = Colección de ejemplos para entrenar                 │
│  entrenar  = Enseñar al modelo (como entrenar a Simón)           │
│  inferencia = Usar el modelo ya entrenado (Simón ya sabe)        │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
"""

print(DICCIONARIO)

print("\n¡FELICITACIONES CAMI! Has entrado al mundo de la IA Local. 🎉")
print("Recuerda: los mejores programadores no son los que nunca fallan,")
print("sino los que aprenden de cada error. ¡A experimentar!\n")

def cifrar_texto(texto, clave):
    resultado = ""
    ALFABETO = "abcdefghijklmnopqrstuvwxyz"
    texto = texto.lower()
    for letra in texto:
        if letra in ALFABETO:            # ← estaba "if letra in texto" (bug)
            pos = ALFABETO.index(letra)
            nueva_pos = (pos + clave) % 26
            letra_nueva = ALFABETO[nueva_pos]
            resultado = resultado + letra_nueva
        else:                            # espacios y signos se quedan igual
            resultado = resultado + letra
    return resultado


def decifrar_texto(texto, clave):
    # Truco de espía: descifrar = cifrar hacia atrás (26 - clave)
    return cifrar_texto(texto, 26 - clave)


def forzar_texto(texto):
    # Palabras comunes en español para "puntuar" cada intento
    PALABRAS = ["el", "la", "los", "las", "y", "de", "en", "es",
                "un", "una", "que", "con", "por", "para", "esta"]

    print("\n🤖 FUERZA BRUTA: probando las 26 claves posibles...\n")

    mejor_puntaje = -1    # "cuaderno": la mejor nota hasta ahora
    clave_ganadora = 0    # "cuaderno": la clave que dio esa nota
    mensaje_ganador = ""  # "cuaderno": el texto descifrado ganador

    for clave in range(26):                            # 1. prueba 0 a 25
        # Descifrar con "clave" = cifrar hacia atrás = cifrar con 26 - clave
        intento = cifrar_texto(texto, 26 - clave)      # 2. descifra

        puntaje = 0                                    # 3. puntúa
        for palabra in PALABRAS:
            if " " + palabra + " " in " " + intento + " ":
                puntaje = puntaje + 1

        print(f"   clave {clave:2d} → {intento}   (puntaje: {puntaje})")

        if puntaje > mejor_puntaje:                    # 4. guarda el mejor
            mejor_puntaje = puntaje
            clave_ganadora = clave
            mensaje_ganador = intento

    print("\n" + "=" * 44)                             # 5. muestra el ganador
    print("🔓 Clave encontrada: " + str(clave_ganadora))
    print("📜 Mensaje secreto: " + mensaje_ganador.upper() + " 🎉")
    print("=" * 44)


# 🧪 Prueba: mensaje del Dr. Bugs (clave 3)
mensaje_dr_bugs = "ho whvrur hvwd hvfrqglgr hq od eleolrwhfd"
forzar_texto(mensaje_dr_bugs)
