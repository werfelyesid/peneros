extends Node2D

const BOT_ESCENA := preload("res://bot_personaje.tscn")
const BOSS_SCRIPT := preload("res://boss_secreto.gd")

@onready var simon: CharacterBody2D = $simon
@onready var cami: CharacterBody2D = $cami
@onready var simon_vida_bar: ProgressBar = $UI/SimonVida
@onready var cami_vida_bar: ProgressBar = $UI/CamiVida
@onready var estado_label: Label = $UI/Estado
@onready var label_monedas: Label = $UI/Monedas
@onready var musica_fondo: AudioStreamPlayer = get_node_or_null("MusicaFondo") as AudioStreamPlayer
@onready var sonido_victoria: AudioStreamPlayer = get_node_or_null("SonidoVictoria") as AudioStreamPlayer
@onready var sonido_caida: AudioStreamPlayer = get_node_or_null("SonidoCaida") as AudioStreamPlayer

var victoria_sonada := false
var partida_terminada := false
var pelea_iniciada := false
var bot_actual: BotData = null
var posicion_spawn_simon := Vector2.ZERO
var oponente: CharacterBody2D  # El bot (o Simon en 2P)
var humano: CharacterBody2D    # El jugador humano
var jugador_humano := ""       # "cami" o "simon"
var boss_mode := false         # true si es boss secreto
var boss_fase_dos := false     # true si el boss está en fase 2
var rayo_clash_activo := false  # true durante choque de rayos

func _ready() -> void:
	add_to_group("arena")
	# Crear monedero (guarda monedas en archivo)
	var monedero := preload("res://monedero.gd").new()
	monedero.name = "Monedero"
	add_child(monedero)
	_actualizar_label_monedas()

	# Desactivar jugadores hasta que elijan armas
	simon.set_process(false)
	simon.set_physics_process(false)
	cami.set_process(false)
	cami.set_physics_process(false)

	# Mostrar pantalla de selección de armas y accesorios
	var seleccion := preload("res://seleccion_arma.tscn").instantiate()
	seleccion.seleccion_completa.connect(_on_seleccion_completa)
	add_child(seleccion)

func _on_seleccion_completa(arma_cami: ArmaData, arma_simon: ArmaData, acc_cami: AccesorioData, acc_simon: AccesorioData, modo: int, bot: BotData) -> void:
	bot_actual = bot
	
	cami.arma_actual = arma_cami
	cami.aplicar_accesorio(acc_cami)
	simon.arma_actual = arma_simon
	simon.aplicar_accesorio(acc_simon)

	if modo == 3:
		# 🎉 BOSS SECRETO: Cami y Simon juntos vs El Dummy
		_iniciar_boss_secreto(bot)
		return

	if modo == 0:
		# 2 jugadores
		oponente = simon
		humano = cami
		jugador_humano = "cami"
		simon.visible = true
	else:
		# 1 jugador vs bots
		var es_dummy := bot and not bot.se_mueve
		var ia := preload("res://ia.gd").new()
		ia.name = "IA"
		add_child(ia)
		
		if modo == 1:
			# Cami vs bots
			humano = cami
			jugador_humano = "cami"
			if es_dummy:
				simon.visible = false
				simon.set_process(false)
				simon.set_physics_process(false)
				var bot_pj := BOT_ESCENA.instantiate()
				bot_pj.name = "BotPersonaje"
				bot_pj.global_position = Vector2(960, 870)
				add_child(bot_pj)
				oponente = bot_pj
				posicion_spawn_simon = bot_pj.global_position
				bot_pj.arma_actual = arma_simon
				bot_pj.aplicar_accesorio(acc_simon)
				ia.iniciar(bot_pj, cami, bot)
			else:
				oponente = simon
				simon.visible = true
				ia.iniciar(simon, cami, bot)
		else:
			# Simon vs bots
			humano = simon
			jugador_humano = "simon"
			if es_dummy:
				cami.visible = false
				cami.set_process(false)
				cami.set_physics_process(false)
				var bot_pj := BOT_ESCENA.instantiate()
				bot_pj.name = "BotPersonaje"
				bot_pj.global_position = Vector2(960, 870)
				add_child(bot_pj)
				oponente = bot_pj
				posicion_spawn_simon = bot_pj.global_position
				bot_pj.arma_actual = arma_cami
				bot_pj.aplicar_accesorio(acc_cami)
				ia.iniciar(bot_pj, simon, bot)
			else:
				oponente = cami
				cami.visible = true
				cami.set_process(true)
				cami.set_physics_process(true)
				ia.iniciar(cami, simon, bot)
		
		var nombre_bot := bot.nombre_bot if bot else "CPU"
		var humano := "Cami" if modo == 1 else "Simon"
		estado_label.text = "%s vs %s" % [humano, nombre_bot]

	_iniciar_pelea()

func _iniciar_pelea() -> void:
	pelea_iniciada = true

	# Activar jugadores (todos los que estén visibles)
	if cami.visible:
		cami.set_process(true)
		cami.set_physics_process(true)
	if simon.visible:
		simon.set_process(true)
		simon.set_physics_process(true)
	if oponente and oponente != cami and oponente != simon:
		oponente.set_process(true)
		oponente.set_physics_process(true)

	# Conectar señales de vida (cada personaje a su barra)
	if cami and cami.has_signal("vida_cambiada"):
		cami.connect("vida_cambiada", _on_cami_vida_cambiada)
	if simon and simon.has_signal("vida_cambiada"):
		simon.connect("vida_cambiada", _on_simon_vida_cambiada)
	# Si el oponente es un robot dummy, conectar su vida a la barra de Simon
	if oponente and oponente != cami and oponente != simon and oponente.has_signal("vida_cambiada"):
		oponente.connect("vida_cambiada", _on_simon_vida_cambiada)

	# Configurar barras de vida
	if cami and cami.visible:
		cami_vida_bar.max_value = cami.vida
		cami_vida_bar.value = cami.vida
	if simon and simon.visible:
		simon_vida_bar.max_value = simon.vida
		simon_vida_bar.value = simon.vida
	# Si el oponente es robot dummy, inicializar su barra
	if oponente and oponente != cami and oponente != simon:
		simon_vida_bar.max_value = oponente.vida
		simon_vida_bar.value = oponente.vida

	estado_label.text = "Pelea en curso"

	# Música de fondo
	if musica_fondo:
		musica_fondo.play()

func _process(_delta: float) -> void:
	if partida_terminada or not pelea_iniciada:
		return
	
	# Detectar choque de rayos (2P, ambos usando kamehameha, ambos < 50 HP)
	if not boss_mode and not rayo_clash_activo and is_instance_valid(cami) and is_instance_valid(simon):
		var cami_rayo := cami.has_node("RayoKamehameha")
		var simon_rayo := simon.has_node("RayoKamehameha")
		if cami_rayo and simon_rayo and cami.vida < 50 and simon.vida < 50:
			_iniciar_rayo_clash()

	# Detectar caída al vacío
	if is_instance_valid(oponente) and oponente.global_position.y > 1100:
		if bot_actual and not bot_actual.se_mueve and not boss_mode:
			_revivir_dummy()
		else:
			oponente.queue_free()
			_tocar_sonido_caida()
	if is_instance_valid(humano) and humano.global_position.y > 1100:
		humano.queue_free()
		_tocar_sonido_caida()
	if boss_mode and is_instance_valid(cami) and cami.global_position.y > 1100:
		cami.queue_free()
	if boss_mode and is_instance_valid(simon) and simon.global_position.y > 1100:
		simon.queue_free()

	# Boss secreto: lógica de victoria especial
	if boss_mode:
		if not is_instance_valid(oponente):
			_detener_boss_musica()
			estado_label.text = "👑 ¡DERROTARON AL DUMMY! +1000🪙 cada uno 👑"
			_dar_monedas("cami", 1000)
			_dar_monedas("simon", 1000)
			_tocar_victoria()
		elif not is_instance_valid(cami) and not is_instance_valid(simon):
			estado_label.text = "El Dummy los derrotó a ambos..."
			_tocar_victoria()
		return

	# Detectar quién ganó
	if not is_instance_valid(humano) and not is_instance_valid(oponente):
		estado_label.text = "Empate"
		_tocar_victoria()
	elif not is_instance_valid(humano):
		# El humano perdió
		if bot_actual:
			estado_label.text = "¡%s te derrotó!" % bot_actual.nombre_bot
		else:
			estado_label.text = "Gana %s +5🪙" % ("Simon" if jugador_humano == "cami" else "Cami")
			_dar_monedas("simon" if jugador_humano == "cami" else "cami", 5)
		_tocar_victoria()
	elif not is_instance_valid(oponente):
		# El humano ganó
		if bot_actual and not bot_actual.se_mueve and bot_actual.recompensa_victoria == 0:
			estado_label.text = "Gana %s" % ("Cami" if jugador_humano == "cami" else "Simon")
			_mostrar_logro_dummy()
		else:
			var recompensa: int = bot_actual.recompensa_victoria if bot_actual else 5
			if recompensa <= 0:
				recompensa = 5
			var nombre_humano := "Cami" if jugador_humano == "cami" else "Simon"
			estado_label.text = "Gana %s +%d🪙" % [nombre_humano, recompensa]
			_dar_monedas(jugador_humano, recompensa)
		_tocar_victoria()

func _tocar_sonido_caida() -> void:
	if sonido_caida and not sonido_caida.playing:
		sonido_caida.play()

func _tocar_victoria() -> void:
	if victoria_sonada:
		return
	victoria_sonada = true
	partida_terminada = true
	_detener_boss_musica()
	if sonido_victoria:
		sonido_victoria.play()
	# Parar música de fondo
	if musica_fondo and musica_fondo.playing:
		musica_fondo.stop()

	# Mostrar tienda después de 2 segundos
	await get_tree().create_timer(2.0).timeout
	var tienda := preload("res://tienda.tscn").instantiate()
	tienda.tienda_cerrada.connect(_on_tienda_cerrada)
	add_child(tienda)

func _on_tienda_cerrada() -> void:
	# Reiniciar la escena para volver a pelear
	get_tree().reload_current_scene()

func _on_simon_vida_cambiada(vida_actual: int) -> void:
	simon_vida_bar.value = max(0, vida_actual)

func _on_cami_vida_cambiada(vida_actual: int) -> void:
	cami_vida_bar.value = max(0, vida_actual)

func _dar_monedas(jugador: String, cantidad: int) -> void:
	var monedero := get_node_or_null("Monedero")
	if monedero and monedero.has_method("sumar_monedas"):
		monedero.sumar_monedas(jugador, cantidad)
		_actualizar_label_monedas()

func _actualizar_label_monedas() -> void:
	var monedero := get_node_or_null("Monedero")
	if monedero and label_monedas:
		label_monedas.text = "🪙 Cami: %d  |  Simon: %d" % [monedero.monedas_cami, monedero.monedas_simon]

## Logro especial al vencer al dummy
func _mostrar_logro_dummy() -> void:
	if not is_instance_valid(cami):
		return
	
	var logro := Label.new()
	logro.name = "LogroDummy"
	logro.text = "¡CÓMO LO HICISTE!"
	logro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	logro.add_theme_font_size_override("font_size", 28)
	logro.add_theme_color_override("font_color", Color(0.7, 0.2, 1, 1))  # Morado brillante
	# Sombra para dar efecto brillante
	logro.add_theme_color_override("font_outline_color", Color(0.9, 0.5, 1, 1))
	logro.add_theme_constant_override("outline_size", 4)
	
	cami.add_child(logro)
	logro.position = Vector2(-logro.size.x / 2, -180)  # Encima de la cabeza
	
	# Animación: flotar hacia arriba y desaparecer
	var tween := create_tween()
	tween.tween_property(logro, "position:y", -280, 2.0)
	tween.parallel().tween_property(logro, "modulate:a", 0.0, 2.0)
	tween.tween_callback(logro.queue_free)

## Revive al dummy en su posición original con vida completa
func _revivir_dummy() -> void:
	if not is_instance_valid(oponente):
		return
	oponente.global_position = posicion_spawn_simon
	oponente.velocity = Vector2.ZERO
	oponente.vida = oponente.vida_maxima
	if oponente.has_signal("vida_cambiada"):
		oponente.emit_signal("vida_cambiada", oponente.vida)
	estado_label.text = "¡El Dummy revivió!"
	await get_tree().create_timer(1.5).timeout
	if is_instance_valid(estado_label):
		estado_label.text = "Pelea en curso (vs Dummy)"

## === BOSS SECRETO ===

func _iniciar_boss_secreto(bot: BotData) -> void:
	boss_mode = true
	# Ambos jugadores son humanos
	humano = cami  # referencia para _process
	jugador_humano = "cami"
	
	# Crear el boss en el centro (usa el diseño del robot normal)
	var boss := BOT_ESCENA.instantiate()
	boss.name = "BossSecreto"
	boss.set_script(BOSS_SCRIPT)
	boss.global_position = Vector2(960, 800)
	add_child(boss)
	oponente = boss
	posicion_spawn_simon = boss.global_position
	boss.vida = 7000
	boss.vida_maxima = 7000
	
	# Conectar vida del boss
	if boss.has_signal("vida_cambiada"):
		boss.connect("vida_cambiada", _on_boss_vida_cambiada)
	
	# IA del boss
	var ia := preload("res://ia.gd").new()
	ia.name = "IA_Boss"
	add_child(ia)
	ia.iniciar_boss(boss, cami, simon, bot)
	
	estado_label.text = "👑 Cami y Simon vs El Dummy 👑"
	
	# Activar ambos jugadores
	cami.set_process(true)
	cami.set_physics_process(true)
	simon.set_process(true)
	simon.set_physics_process(true)
	cami.visible = true
	simon.visible = true
	
	# Barras de vida
	cami_vida_bar.max_value = cami.vida
	cami_vida_bar.value = cami.vida
	simon_vida_bar.max_value = simon.vida
	simon_vida_bar.value = simon.vida
	
	# Conectar señales
	if cami.has_signal("vida_cambiada"):
		cami.connect("vida_cambiada", _on_cami_vida_cambiada)
	if simon.has_signal("vida_cambiada"):
		simon.connect("vida_cambiada", _on_simon_vida_cambiada)
	
	pelea_iniciada = true
	estado_label.text = "👑 Cami y Simon vs El Dummy 👑"
	
	# Detener música normal y poner soundtrack del boss fase 1
	if musica_fondo and musica_fondo.playing:
		musica_fondo.stop()
	_reproducir_boss_musica("res://sonidos/dummy_boss_fase1.mp3")

func _boss_bloquea_mensaje() -> void:
	estado_label.text = "El Dummy: ¡ESTOY CANSADO DE ESTO!"
	estado_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3, 1))
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(estado_label):
		estado_label.text = "👑 Cami y Simon vs El Dummy 👑"
		estado_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))

func _boss_esquiva_mensaje() -> void:
	estado_label.text = "¡El Dummy esquivó el ataque!"
	estado_label.add_theme_color_override("font_color", Color(1, 0.8, 0.2, 1))
	await get_tree().create_timer(1.5).timeout
	if is_instance_valid(estado_label):
		estado_label.text = "👑 Cami y Simon vs El Dummy 👑"
		estado_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))

func _on_boss_vida_cambiada(vida_actual: int) -> void:
	simon_vida_bar.max_value = 7000
	simon_vida_bar.value = max(0, vida_actual)

func _boss_fase_dos() -> void:
	boss_fase_dos = true
	
	# Cambiar música a fase 2
	_reproducir_boss_musica("res://sonidos/blood_drain_fase2.mp3")
	# Mensaje de fase 2
	estado_label.text = "El Dummy: ¡EN SERIO, YO PUDO APARECER OTRA VEZ, TONTOS!"
	estado_label.add_theme_color_override("font_color", Color(0.8, 0.3, 1, 1))
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(estado_label):
		estado_label.text = "👑 ¡FASE 2! El Dummy se enfurece 👑"
		estado_label.add_theme_color_override("font_color", Color(1, 0.2, 0.2, 1))
	await get_tree().create_timer(2.0).timeout
	
	# Ajustar jugadores para fase 2
	if is_instance_valid(cami):
		cami.vida = 700
		cami.vida_maxima = 700
		cami.attack_damage = 3
		cami_vida_bar.max_value = 700
		cami_vida_bar.value = 700
		if cami.has_signal("vida_cambiada"):
			cami.emit_signal("vida_cambiada", cami.vida)
	if is_instance_valid(simon):
		simon.vida = 700
		simon.vida_maxima = 700
		simon.attack_damage = 3
		simon_vida_bar.max_value = 10000
		simon_vida_bar.value = 10000  # Boss bar
		if simon.has_signal("vida_cambiada"):
			simon.emit_signal("vida_cambiada", simon.vida)
	
	estado_label.text = "👑 ¡FASE 2! El Dummy se enfurece 👑"
	estado_label.add_theme_color_override("font_color", Color(1, 0.2, 0.2, 1))
	await get_tree().create_timer(2.5).timeout
	if is_instance_valid(estado_label):
		estado_label.text = "👑 FASE 2: Cami y Simon vs El Dummy 👑"
		estado_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))

## === CHOQUE DE RAYOS (2P, ambos < 50 HP) ===

func _iniciar_rayo_clash() -> void:
	rayo_clash_activo = true
	
	# Agrandar rayos INMEDIATAMENTE (antes de que expiren)
	if is_instance_valid(cami) and cami.has_node("RayoKamehameha"):
		cami.get_node("RayoKamehameha").scale = Vector2(3, 3)
	if is_instance_valid(simon) and simon.has_node("RayoKamehameha"):
		simon.get_node("RayoKamehameha").scale = Vector2(3, 3)
	
	# Diálogos rápidos
	estado_label.text = "Cami: Usemos cada última gota, Simon."
	await get_tree().create_timer(1.5).timeout
	estado_label.text = "Simon: Solo esta vez, Cami."
	await get_tree().create_timer(1.2).timeout
	
	# QTE: 3 rondas
	var puntos_cami := 0
	var puntos_simon := 0
	
	for ronda in range(3):
		var teclas: Array = [KEY_1, KEY_2, KEY_3]
		teclas.shuffle()
		var tecla_cami: Key = teclas[0]
		var tecla_simon: Key = teclas[1]
		
		var txt := "⚡ CHOQUE (ronda %d/3) ⚡\nCAMI: %s  |  SIMON: NumPad %s" % [ronda + 1, _tecla_nombre(tecla_cami), _tecla_nombre(tecla_simon)]
		estado_label.text = txt
		
		var listo_cami := false
		var listo_simon := false
		var ganador_ronda := ""
		
		while not listo_cami or not listo_simon:
			await get_tree().physics_frame
			if not listo_cami and Input.is_key_pressed(tecla_cami):
				listo_cami = true
				if ganador_ronda == "":
					ganador_ronda = "cami"
			if not listo_simon and Input.is_key_pressed(tecla_simon):
				listo_simon = true
				if ganador_ronda == "":
					ganador_ronda = "simon"
		
		if ganador_ronda == "cami":
			puntos_cami += 1
		else:
			puntos_simon += 1
		
		estado_label.text = "Ronda %d: ¡%s!" % [ronda + 1, "CAMI" if ganador_ronda == "cami" else "SIMON"]
		await get_tree().create_timer(0.8).timeout
	
	# Resultado
	var ganador: CharacterBody2D
	var perdedor: CharacterBody2D
	
	if puntos_cami > puntos_simon:
		ganador = cami
		perdedor = simon
		estado_label.text = "🔥 ¡CAMI GANA EL CHOQUE! 🔥"
	else:
		ganador = simon
		perdedor = cami
		estado_label.text = "🔥 ¡SIMON GANA EL CHOQUE! 🔥"
	
	if is_instance_valid(perdedor) and perdedor.has_method("recibir_dano"):
		perdedor.call("recibir_dano", 200)
	
	await get_tree().create_timer(2.0).timeout
	rayo_clash_activo = false

func _tecla_nombre(k: Key) -> String:
	match k:
		KEY_1: return "1"
		KEY_2: return "2"
		KEY_3: return "3"
		_: return "?"

var boss_musica_player: AudioStreamPlayer

func _reproducir_boss_musica(ruta: String) -> void:
	# Detener música anterior del boss
	if boss_musica_player and is_instance_valid(boss_musica_player):
		boss_musica_player.stop()
		boss_musica_player.queue_free()
	
	if not FileAccess.file_exists(ruta):
		return  # Archivo no existe, no hay música
	
	var stream := load(ruta) as AudioStream
	if stream == null:
		return
	
	boss_musica_player = AudioStreamPlayer.new()
	boss_musica_player.stream = stream
	boss_musica_player.volume_db = -5.0
	add_child(boss_musica_player)
	boss_musica_player.play()

func _detener_boss_musica() -> void:
	if boss_musica_player and is_instance_valid(boss_musica_player):
		boss_musica_player.stop()
		boss_musica_player.queue_free()
		boss_musica_player = null
