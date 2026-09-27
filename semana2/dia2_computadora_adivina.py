"""
=============================
🤖 LA COMPUTADORA ADIVINA TU NÚMERO
=============================

INSTRUCCIONES:
-------------
En el juego de "adivina el número" (adivina_pro.py),
TÚ adivinabas el número de la computadora.

Hoy le damos la vuelta: TÚ piensas un número
y la COMPUTADORA trata de adivinarlo. 🧠

CÓMO FUNCIONA:
--------------
1. El jugador piensa un número del 1 al 100 (no lo escribe)
2. La computadora propone un número
3. El jugador responde con UNA de estas palabras:
   - "mas"      → el número secreto es MÁS ALTO
   - "menos"    → el número secreto es MÁS BAJO
   - "correcto" → ¡la computadora adivinó!

CONCEPTOS A REPASAR:
--------------------
- while: repetir hasta acertar
- if / elif / else: decidir según la respuesta
- variables: guardar el mínimo, máximo e intentos

PISTAS (¡muy importantes!):
----------------------------
- La computadora es lista: usa la técnica de "la mitad"
  min = 1
  max = 100
  propuesta = (min + max) // 2   ← el // divide y quita decimales

- Si el jugador dice "mas":
  min = propuesta + 1            ← sube el mínimo
- Si el jugador dice "menos":
  max = propuesta - 1            ← baja el máximo
- Si el jugador dice "correcto":
  el bucle termina

EJEMPLO DE CÓMO DEBE FUNCIONAR:
--------------------------------
🤖 Piensa un número del 1 al 100...
¿Es 50? (mas / menos / correcto): mas
¿Es 75? (mas / menos / correcto): menos
¿Es 62? (mas / menos / correcto): correcto
🎉 ¡Lo adiviné en 3 intentos! Tu número era 62

RETO EXTRA (si te sobra tiempo):
---------------------------------
- Cuenta los intentos y muéstralos al final
- Si el jugador miente, la computadora lo detecta
  (pista: si min > max, es imposible → estaba mintiendo)
- Deja que el jugador elija el rango máximo (ej: 1 al 1000)
"""

# ⬇️ ESCRIBE TU CÓDIGO AQUÍ ABAJO ⬇️

min = 1
max = 100
intentos = 0
print(" piensa en un numero del 1 al 100...")
print("voy a adivinarlo con mi poder ñero!\n")

while True:
    propuesta = (min + max) // 2
    print(f"Es {propuesta} (mas / menos / correcto): ")
    respuesta = input().lower()
    intentos += 1
    if respuesta == "mas":
        min = propuesta + 1
    elif respuesta == "menos":
        max = propuesta - 1
    elif respuesta == "correcto":
        break
print(f"¡lo adivine en {intentos} intentos ! tu numero era {propuesta} siæßð")









min = 1
max = 100
intentos = 0
print("piensa en cualquier numero del 1 al 100")
print("lo adivinare con mi poder ñero...\n")

while True:
    propuesta =(min + max) // 2
    print(f"es {propuesta} (mas / menos / correcto): ")
    intentos+=1
    respuesta = input.lower()

    if propuesta == "menos":
        min = propuesta -1
    elif propuesta == "mas":
        max = propuesta +1
    elif propuesta == "correcto":
        break
print(f"lo adivine en {intentos} intentos tu numero era {propuesta} sii ø→↓ĸ")    
        