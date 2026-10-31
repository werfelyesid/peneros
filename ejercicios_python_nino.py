# 🐱 MI MASCOTA VIRTUAL
# ====================
# Crea un programa que:
# 1. Pregunte el nombre de la mascota
# 2. Diga "¡Hola [nombre]!"
# 3. Pregunte qué edad tiene
# 4. Si tiene menos de 2 años, que diga "¡Eres un bebé! 🍼"
# 5. Si tiene 2 años o más, que diga "¡Ya eres grande! 🎉"



# 👆 Empieza a escribir tu código aquí
nombre = input("Como se llama tu mascota ")
print(f"hola {nombre} gustos ")
edad = int(input(f"Cuantos años tiene {nombre}"))
if edad < 2:
    print("es un bebe")
else:
    print("ya está  crecido") 