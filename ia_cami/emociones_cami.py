"""
🤖 emociones_cami.py
Habla con tu IA: escribe una frase en INGLÉS y te dice
si es POSITIVE 😊 o NEGATIVE 😢.
Escribe 'salir' para terminar.
"""

from transformers import pipeline

print("\n🤖 ¡Hola Cami! Soy tu analizador de emociones.")
print("   Escríbeme en INGLÉS cómo te sientes y yo te respondo.")
print("   (Escribe 'salir' para terminar)\n")

# Cargamos el modelo (la primera vez tarda, luego es rápido)
print("📥 Cargando el modelo...")
clasificador = pipeline(
    "sentiment-analysis",
    model="distilbert-base-uncased-finetuned-sst-2-english"
)
print("✅ ¡Listo! Empecemos a hablar.\n")

# Bucle infinito: sigue preguntando hasta que escribas 'salir'
while True:
    frase = input("Tú: ")

    # Si escribes salir/exit/bye/adiós, termina el programa
    if frase.lower() in ["salir", "exit", "bye", "adiós", "adios"]:
        print("🤖 ¡Hasta luego, Cami! 👋\n")
        break

    # Preguntamos a la IA
    resultado = clasificador(frase)[0]
    emocion = resultado['label']     # POSITIVE o NEGATIVE
    confianza = resultado['score']   # 0.0 a 1.0 (qué tan segura está)

    # ──────────────────────────────────────────────────────
    # BONUS: detectar si es NEUTRAL (confianza baja)
    # ──────────────────────────────────────────────────────
    if confianza < 0.70:
        print(f"🤖 Hmm, no estoy muy seguro... eso me suena NEUTRAL 😐")
        print(f"   (confianza: {confianza:.2%})\n")

    elif emocion == "POSITIVE":
        print(f"🤖 ¡Qué bien! Sigue así 💪")
        print(f"   (lo veo {emocion} con {confianza:.2%} de seguridad)\n")

    else:
        print(f"🤖 Ánimo, mañana será mejor 🌈")
        print(f"   (lo veo {emocion} con {confianza:.2%} de seguridad)\n")
