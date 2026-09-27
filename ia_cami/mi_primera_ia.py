"""
🤖 mi_primera_ia.py
Tu primer modelo de IA Local, Cami!
Este código clasifica emociones (POSITIVE / NEGATIVE) en inglés.
"""

try:
    # Esto importa la librería que ya instalamos
    from transformers import pipeline

    print("\n📥 Descargando el modelo (solo la primera vez)...")
    print("   (Como descargar un juego de Steam: pesa una vez, luego carga rápido)\n")

    # Creamos el clasificador de emociones
    clasificador = pipeline(
        "sentiment-analysis",
        model="distilbert-base-uncased-finetuned-sst-2-english"
    )

    print("✅ Modelo cargado. ¡Probemos!\n")

    # ──────────────────────────────────────────────────────
    # PRUEBA 1: Frases positivas y negativas
    # ──────────────────────────────────────────────────────
    frases = [
        "I love learning AI with Python!",
        "This is the worst day ever.",
        "Cami is creating artificial intelligence!",
        "The code has too many bugs and errors.",
        "😢😢😢😢😊😊😊😊"
    ]

    for frase in frases:
        resultado = clasificador(frase)[0]
        emocion = resultado['label']       # POSITIVE o NEGATIVE
        confianza = resultado['score']      # 0.0 a 1.0 (qué tan seguro está)

        # Mostramos el resultado bonito
        barra = "█" * int(confianza * 20)
        emoji = "😊" if emocion == "POSITIVE" else "😢"

        print(f'  Texto:      "{frase}"')
        print(f"  Emoción:    {emocion} {emoji}")
        print(f"  Confianza:  {confianza:.2%} [{barra}]")
        print()

except Exception as e:
    print(f"\n⚠️  Ups, algo falló: {e}")
    print("\nRevisa que hayas completado los pasos anteriores.")
