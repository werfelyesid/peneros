extends Node

## IA que controla un personaje según la configuración del bot.

var objetivo: CharacterBody2D
var personaje: CharacterBody2D
var datos_bot: BotData
var activo := false
var timer_especial := 0.0
var timer_ataque := 0.0
var estaba_en_aire := false
var regen_acumulado := 0.0  # Acumulador de regeneración

func iniciar(pj: CharacterBody2D, obj: CharacterBody2D, bot: BotData) -> void:
	personaje = pj
	objetivo = obj
	datos_bot = bot

	# Aplicar stats del bot al personaje
	if datos_bot:
		personaje.vida = datos_bot.vida
		personaje.vida_maxima = datos_bot.vida
		personaje.speed = int(personaje.speed * datos_bot.multiplicador_velocidad)
		personaje.jump_velocity = int(personaje.jump_velocity * datos_bot.multiplicador_salto)
		# Escalar tamaño
		if datos_bot.multiplicador_tamano != 1.0:
			personaje.scale *= datos_bot.multiplicador_tamano
		# Escalar daño de ataque
		personaje.attack_damage = int(personaje.attack_damage * datos_bot.multiplicador_dano)

	personaje.set_physics_process(false)
	activo = true

func _physics_process(delta: float) -> void:
	if not activo or not is_instance_valid(personaje):
		return
	
	# Boss secreto: lógica diferente
	if jugador1 != null or jugador2 != null:
		_physics_process_boss(delta)
		return
	
	if not is_instance_valid(objetivo):
		return

	# Dummy: no se mueve ni ataca, pero regenera 10 HP/min
	if datos_bot and not datos_bot.se_mueve:
		personaje.velocity.x = 0.0
		if not personaje.is_on_floor():
			personaje.velocity.y += personaje.gravity * delta
		# Regeneración: 10 HP por minuto (acumulador para manejar decimales)
		regen_acumulado += (10.0 / 60.0) * delta
		if regen_acumulado >= 1.0:
			var curar := int(regen_acumulado)
			regen_acumulado -= curar
			personaje.vida = min(personaje.vida + curar, personaje.vida_maxima)
			if personaje.has_signal("vida_cambiada"):
				personaje.emit_signal("vida_cambiada", personaje.vida)
		personaje.move_and_slide()
		return

	var dist_x := objetivo.global_position.x - personaje.global_position.x
	var dist_y := objetivo.global_position.y - personaje.global_position.y
	var distancia: float = abs(dist_x)

	# Velocidad según agresividad
	var vel_bot: float = personaje.speed * (0.4 + datos_bot.agresividad * 0.5)

	# Moverse hacia el objetivo
	if distancia > 80:
		personaje.velocity.x = vel_bot * sign(dist_x)
		personaje.facing_dir = sign(dist_x)
	else:
		personaje.velocity.x = 0.0

	# Gravedad
	var estaba_en_suelo := personaje.is_on_floor()
	if not estaba_en_suelo:
		personaje.velocity.y += personaje.gravity * delta

	# AoE al caer (bot imposible)
	if datos_bot and datos_bot.dano_caida > 0.0:
		if estaba_en_aire and estaba_en_suelo:
			# Acaba de aterrizar: daño en área
			if objetivo.global_position.distance_to(personaje.global_position) < datos_bot.radio_caida:
				if objetivo.has_method("recibir_dano"):
					objetivo.call("recibir_dano", int(datos_bot.dano_caida))
	estaba_en_aire = not estaba_en_suelo

	# Saltar si el objetivo está más alto
	if estaba_en_suelo and dist_y < -30 and distancia < 300:
		personaje.velocity.y = personaje.jump_velocity

	# Atacar cuando está cerca (más agresivo = ataca más seguido)
	timer_ataque -= delta
	var rango_ataque := 100.0 + datos_bot.agresividad * 60.0
	var frecuencia_ataque := 1.2 - datos_bot.agresividad * 0.6
	if distancia < rango_ataque and timer_ataque <= 0.0:
		if personaje.can_attack:
			personaje._attack()
			timer_ataque = frecuencia_ataque

	# Ataque especial (más agresivo = usa especial más seguido)
	timer_especial -= delta
	if distancia < 300 and timer_especial <= 0.0:
		if personaje.puede_especial:
			personaje._ataque_especial()
			timer_especial = 6.0 - datos_bot.agresividad * 3.0
		elif personaje.puede_bola:
			personaje._ataque_bola()
			timer_especial = 6.0 - datos_bot.agresividad * 3.0

	personaje._actualizar_giro()
	personaje.move_and_slide()

## === MODO BOSS SECRETO ===
var jugador1: CharacterBody2D
var jugador2: CharacterBody2D

func iniciar_boss(pj: CharacterBody2D, j1: CharacterBody2D, j2: CharacterBody2D, bot: BotData) -> void:
	personaje = pj
	jugador1 = j1
	jugador2 = j2
	datos_bot = bot
	objetivo = j1  # default
	
	if datos_bot:
		personaje.vida = datos_bot.vida
		personaje.vida_maxima = datos_bot.vida
		personaje.speed = int(personaje.speed * datos_bot.multiplicador_velocidad)
		if datos_bot.multiplicador_tamano != 1.0:
			personaje.scale *= datos_bot.multiplicador_tamano
	
	personaje.set_physics_process(false)
	activo = true

func _physics_process_boss(delta: float) -> void:
	if not activo or not is_instance_valid(personaje):
		return
	
	# Elegir al jugador más cercano como objetivo
	var d1 := 99999.0
	var d2 := 99999.0
	if is_instance_valid(jugador1):
		d1 = personaje.global_position.distance_to(jugador1.global_position)
	if is_instance_valid(jugador2):
		d2 = personaje.global_position.distance_to(jugador2.global_position)
	
	if d1 < d2 and is_instance_valid(jugador1):
		objetivo = jugador1
	elif is_instance_valid(jugador2):
		objetivo = jugador2
	else:
		return  # Ambos muertos
	
	var dist_x := objetivo.global_position.x - personaje.global_position.x
	var dist_y := objetivo.global_position.y - personaje.global_position.y
	var distancia: float = abs(dist_x)
	
	# Moverse rápido hacia el objetivo
	if distancia > 60:
		personaje.velocity.x = personaje.speed * sign(dist_x)
		personaje.facing_dir = sign(dist_x)
	else:
		personaje.velocity.x = 0.0
	
	# Gravedad y AoE al caer
	var estaba_en_suelo := personaje.is_on_floor()
	if not estaba_en_suelo:
		personaje.velocity.y += personaje.gravity * delta
	
	# AoE al aterrizar
	if datos_bot and datos_bot.dano_caida > 0.0:
		if estaba_en_aire and estaba_en_suelo:
			for pj in [jugador1, jugador2]:
				if is_instance_valid(pj) and pj.global_position.distance_to(personaje.global_position) < datos_bot.radio_caida:
					if pj.has_method("recibir_dano"):
						pj.call("recibir_dano", int(datos_bot.dano_caida))
	estaba_en_aire = not estaba_en_suelo
	
	# Saltar si el objetivo está más alto
	if estaba_en_suelo and dist_y < -30 and distancia < 350:
		personaje.velocity.y = personaje.jump_velocity
	
	# Atacar
	timer_ataque -= delta
	if distancia < 120 and timer_ataque <= 0.0:
		if personaje.can_attack:
			personaje._attack()
			timer_ataque = 0.8
	
	# Regeneración: 20 HP por minuto
	regen_acumulado += (20.0 / 60.0) * delta
	if regen_acumulado >= 1.0:
		var curar := int(regen_acumulado)
		regen_acumulado -= curar
		personaje.vida = min(personaje.vida + curar, personaje.vida_maxima)
		if personaje.has_signal("vida_cambiada"):
			personaje.emit_signal("vida_cambiada", personaje.vida)
	
	# Fase 2: si el boss "muere" en fase 1, activar fase 2
	if personaje.has_method("_actualizar_aura") and personaje.get("fase_actual") == 1 and personaje.vida <= 0:
		_activar_fase_dos()
	
	personaje.move_and_slide()

func _activar_fase_dos() -> void:
	if not personaje or not personaje.has_method("_actualizar_aura"):
		return
	personaje.set("fase_actual", 2)
	personaje.vida = 10000
	personaje.vida_maxima = 10000
	personaje.attack_damage = 5
	personaje.scale = Vector2(1.7, 1.7)
	if personaje.has_method("_actualizar_aura"):
		personaje._actualizar_aura()
	
	if personaje.has_signal("vida_cambiada"):
		personaje.emit_signal("vida_cambiada", personaje.vida)
	if personaje.has_signal("fase_dos_activada"):
		personaje.emit_signal("fase_dos_activada")
	
	# Notificar a la arena
	var arena := get_tree().get_first_node_in_group("arena")
	if arena and arena.has_method("_boss_fase_dos"):
		arena._boss_fase_dos()
