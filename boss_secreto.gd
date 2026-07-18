class_name BossSecreto extends CharacterBody2D

## Boss secreto que bloquea ataques y contraataca. Fase 1 y Fase 2.

@export var speed := 500
@export var jump_velocity := -600
@export var gravity := 600
@export var attack_damage := 4
@export var vida := 7000
@export var vida_maxima := 7000
@export var arma_actual: ArmaData
@export var head_turn_degrees := 0.0
@export var head_turn_speed := 0.0

var can_attack := true
var puede_especial := false
var puede_bola := false
var facing_dir := 1.0
var multiplicador_dano_recibido := 1.0
var regen_acumulado := 0.0
var fase_actual := 1

signal vida_cambiada(vida_actual)
signal fase_dos_activada()

func _ready() -> void:
	# Crear aura si no existe
	if not has_node("Aura"):
		var aura := ColorRect.new()
		aura.name = "Aura"
		aura.offset_left = -40.0
		aura.offset_top = -100.0
		aura.offset_right = 40.0
		aura.offset_bottom = 100.0
		aura.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(aura)
	_actualizar_aura()

func _actualizar_aura() -> void:
	var aura := get_node_or_null("Aura") as ColorRect
	if aura == null:
		return
	if fase_actual == 1:
		aura.color = Color(1, 0.1, 0.1, 0.3)  # Rojo
	else:
		aura.color = Color(0.6, 0.2, 1, 0.35)  # Morado

func recibir_dano(dano: int) -> void:
	var arena := get_tree().get_first_node_in_group("arena")
	
	# 20% probabilidad de esquivar en fase 1
	if fase_actual == 1 and randf() < 0.2:
		if arena and arena.has_method("_boss_esquiva_mensaje"):
			arena._boss_esquiva_mensaje()
		return
	
	# Fase 1: bloquea todo, contraataque 50%
	# Fase 2: recibe 50% del daño, contraataque 35%
	if fase_actual == 1:
		if arena and arena.has_method("_boss_bloquea_mensaje"):
			arena._boss_bloquea_mensaje()
	else:
		# Fase 2: recibe la mitad del daño
		vida -= int(dano * 0.5)
		if vida < 0:
			vida = 0
		emit_signal("vida_cambiada", vida)
		if vida <= 0:
			queue_free()
			return
	
	# Contraataque al más cercano
	var cami := get_node_or_null("../cami") as CharacterBody2D
	var simon := get_node_or_null("../simon") as CharacterBody2D
	
	var atacante: CharacterBody2D = null
	var dist_min := 999999.0
	for pj in [cami, simon]:
		if pj and is_instance_valid(pj):
			var d := global_position.distance_to(pj.global_position)
			if d < dist_min:
				dist_min = d
				atacante = pj
	
	if atacante and atacante.has_method("recibir_dano"):
		var pct := 0.5 if fase_actual == 1 else 0.35
		var dano_contra := int(atacante.vida * pct)
		atacante.call("recibir_dano", dano_contra)

func recibir_vida(_cantidad: int) -> void:
	pass  # El boss no se cura

func _attack() -> void:
	# El boss ataca al jugador más cercano
	var cami := get_node_or_null("../cami") as CharacterBody2D
	var simon := get_node_or_null("../simon") as CharacterBody2D
	
	var objetivo: CharacterBody2D = null
	var dist_min := 999999.0
	for pj in [cami, simon]:
		if pj and is_instance_valid(pj):
			var d := global_position.distance_to(pj.global_position)
			if d < dist_min and d < 150:  # Rango de ataque
				dist_min = d
				objetivo = pj
	
	if objetivo and objetivo.has_method("recibir_dano"):
		objetivo.call("recibir_dano", attack_damage)

func _ataque_especial(_t: float = 0.0) -> void:
	pass  # El boss no usa especial

func _ataque_bola() -> void:
	pass

func _actualizar_giro() -> void:
	pass
