# 🎵 DÍA 6 — SONIDOS EN PEÑEROS (Godot)

## 📋 Plan del día (60-90 min)

Hoy SÍ pueden usar IA, pero con reglas (ver abajo).

---

## 🎯 Objetivo

Agregar efectos de sonido al juego Peñeros:
1. Sonido al saltar
2. Sonido al golpear
3. Sonido al recibir daño
4. Sonido al recoger poción
5. Sonido de victoria

---

## 🔍 Paso 1: Conseguir sonidos (15 min)

Busquen juntos en estos sitios:
- https://freesound.org (requiere registro gratuito)
- https://pixabay.com/sound-effects (sin registro)

Descarguen estos sonidos y guárdenlos en `sonidos/`:
```
sonidos/salto.wav
sonidos/golpe.wav
sonidos/danio.wav
sonidos/pocion.wav
sonidos/victoria.wav
```

---

## 🛠️ Paso 2: Agregar AudioStreamPlayer en Godot (20 min)

**PARA CADA JUGADOR** (cami y simon):

1. Abre la escena del personaje (ej. `cami.tscn` o `bot_personaje.tscn`)
2. Haz clic derecho en el nodo raíz → "Add Child Node"
3. Busca `AudioStreamPlayer` y agrégalo
4. Renómbralo a `SonidoSalto`
5. En el Inspector, arrastra `sonidos/salto.wav` a la propiedad "Stream"
6. Repite para cada sonido: `SonidoGolpe`, `SonidoDanio`, `SonidoPocion`, `SonidoVictoria`

Al final, cada personaje debe tener 5 nodos AudioStreamPlayer.

---

## 💻 Paso 3: Conectar sonidos con código (30 min)

Abre el script del personaje (ej. `cami.gd`) y agrega:

### Sonido de salto
Donde ya está el código del salto, agrega:
```gdscript
# Dentro de la función de salto, después de aplicar velocidad:
$SonidoSalto.play()
```

### Sonido de golpe
Donde se aplica el daño al enemigo:
```gdscript
# Cuando el ataque conecta:
$SonidoGolpe.play()
```

### Sonido de recibir daño
Donde el personaje recibe daño:
```gdscript
# Cuando te pegan:
$SonidoDanio.play()
```

### Sonido de poción
En `pocion.gd`, cuando el jugador toca la poción:
```gdscript
# En _on_body_entered:
body.SonidoPocion.play()
```

### Sonido de victoria
Donde se detecta que alguien ganó:
```gdscript
# Cuando la vida del otro llega a 0:
$SonidoVictoria.play()
```

---

## ⚠️ Reglas para usar IA hoy

| Permitido | No permitido |
|-----------|-------------|
| Preguntar "¿cómo se reproduce un sonido en Godot?" | Pedir que escriba todo el código |
| Pedir ayuda si hay un error que no entienden | Copiar y pegar sin entender |
| Usar IA para buscar sonidos | Que la IA haga el trabajo de buscar |

**Regla de oro**: Camilo debe poder explicar cada línea de código que entre al juego.

---

## ✅ Checklist final

- [ ] Los 5 sonidos están descargados en `sonidos/`
- [ ] Cada personaje tiene sus 5 AudioStreamPlayer
- [ ] El sonido de salto suena al saltar
- [ ] El sonido de golpe suena al pegar
- [ ] El sonido de daño suena al recibir daño
- [ ] El sonido de poción suena al recogerla
- [ ] El sonido de victoria suena al ganar
- [ ] Camilo puede explicar qué hace cada línea nueva
