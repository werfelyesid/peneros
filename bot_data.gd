class_name BotData extends Resource

## Datos de un bot enemigo para el modo 1 jugador.

@export var nombre_bot := "Bot"
@export var descripcion := ""
@export var vida := 100
@export var multiplicador_dano := 1.0       # 1.0 = mismo daño que el jugador
@export var multiplicador_velocidad := 1.0   # 1.0 = misma velocidad base
@export var multiplicador_salto := 1.0       # 1.0 = mismo salto base
@export var multiplicador_tamano := 1.0      # 1.0 = mismo tamaño
@export var dano_caida := 0.0                # Daño en área al caer (0 = sin efecto)
@export var radio_caida := 120.0             # Radio del AoE de caída
@export var costo_monedas := 0               # Monedas para desbloquear (negativo = te da monedas)
@export var recompensa_victoria := 1         # Monedas que ganas al vencerlo
@export var color_bot := Color.RED
@export var se_mueve := true                 # false para dummy
@export var agresividad := 0.5               # 0.0 = pasivo, 1.0 = muy agresivo
