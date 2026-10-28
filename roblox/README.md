# 🥚 Bebé Huevo Triste (Roblox)

Obby frenético de 3 etapas: juegas como un bebé huevo triste, cruzas plataformas
que desaparecen, cintas que te devuelven y aspas que giran, y vuelves a la plaza a
gastar las monedas en cáscaras de colores.

El mapa **se genera por código**: este repo es la fuente de verdad. Lo que edites a
mano en Studio se pierde al reconectar Rojo.

## Requisitos

- Windows con **Roblox Studio** (Studio no corre en Linux)
- Cuenta de Roblox
- Git

## Instalación (una sola vez, ~20 min)

1. Clonar el repo en el portátil y entrar a la carpeta:

   ```sh
   git clone https://github.com/werfelyesid/peneros.git
   cd peneros/roblox
   ```

2. Instalar **Rokit** (administra Rojo). En PowerShell:

   ```powershell
   Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression
   ```

3. Instalar las herramientas del proyecto (lee `rokit.toml`):

   ```sh
   rokit install
   ```

4. Instalar el plugin de Rojo en Studio:

   ```sh
   rojo plugin install
   ```

5. Abrir Studio → plantilla **Baseplate** → pestaña Plugins → **Rojo** → **Connect**.

6. Presionar **Play** (F5). El script borra el Baseplate y construye la plaza,
   el obby y la tienda.

## Uso diario

```sh
cd roblox
rojo serve
```

Studio ya abierto con el plugin conectado: cada vez que guardes un archivo
`.luau` el cambio aparece en el juego. Después de cambiar el **código del
servidor** hay que detener y volver a darle Play.

## Estructura

| Archivo | Qué es |
| --- | --- |
| `default.project.json` | Traduce carpetas a objetos de Roblox (Rojo) |
| `src/shared/Config.luau` | **El tablero de control**: etapas, precios, velocidades |
| `src/shared/Notify.luau` | Manda mensajes al HUD |
| `src/server/Main.server.luau` | Arranca todo, en orden |
| `src/server/ObbyBuilder.luau` | Construye plaza, obby, monedas y tienda |
| `src/server/EggCharacter.luau` | Convierte al avatar en bebé huevo triste |
| `src/server/Progress.luau` | Checkpoints, monedas, caídas y meta |
| `src/server/Shop.luau` | Compra de cáscaras |
| `src/client/Hud.client.luau` | Marcador de monedas/etapa y mensajes |

## Cambiar el juego sin saber programar

Todo está en `src/shared/Config.luau`:

- `Config.Stages`: cuántas plataformas, qué tan lejos, qué trampas (`plain`,
  `small`, `vanish`, `conveyor`, `spinner`).
- `Config.Shop.Shells`: cáscaras, colores y precios.
- `Config.Egg`: tamaño del huevo, velocidad y fuerza de salto.

Cambiar `seed` de una etapa cambia el recorrido; los demás números cambian la
dificultad.

## Notas

- Todo el arte son partes de Studio (esferas y bloques): no se descargó ningún
  asset ni se copió nada del juego original.
- Las monedas y las compras todavía **no se guardan** entre sesiones: eso es la
  siguiente lección (DataStore).
