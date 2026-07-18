"""
=============================
🛡️ DÍA 4 — PROGRAMA A PRUEBA DE ERRORES
=============================

INSTRUCCIONES:
-------------
Hoy vamos a hacer que el programa sea INDESTRUCTIBLE.
Si el usuario escribe cualquier tontería, el programa
no se rompe, sino que avisa y pide de nuevo.

TU MISIÓN:
----------
Mejora el código del Día 3 agregando validación en TODAS
las partes donde el usuario escribe algo:

1. MENÚ PRINCIPAL:
   - Solo acepta 1, 2 o 3
   - Si escribe otra cosa: "Opción inválida. Elige 1, 2 o 3."

2. OPCIÓN DEL JUGADOR:
   - Solo acepta "piedra", "papel" o "tijera"
   - Da igual si escribe con MAYÚSCULAS o minúsculas
   - Pista: usa .lower() para convertir a minúsculas

3. AL SALIR (opción 3):
   - Muestra el marcador final
   - Pregunta: "¿Seguro que quieres salir? (si/no)"
   - Si dice "no", vuelve al menú

COSAS NUEVAS QUE VAS A USAR:
-----------------------------
- texto.lower() → convierte a minúsculas
- texto.strip() → quita espacios al inicio y final
- if opcion not in ["1", "2", "3"]: → verifica si NO está en la lista

RETO EXTRA (si te sobra tiempo):
---------------------------------
Haz que acepte abreviaturas:
- "p" = piedra
- "pa" = papel
- "t" = tijera
"""

# ⬇️ ESCRIBE TU CÓDIGO AQUÍ ABAJO ⬇️


