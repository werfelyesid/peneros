extends CanvasLayer

## Fase 0: modo (Cami vs bots / Simon vs bots / 2P). Fase 1: bot. Fase 2: arma. Fase 3: accesorio.

const BOTS := [
	preload("res://bot_facil.tres"),
	preload("res://bot_normal.tres"),
	preload("res://bot_dificil.tres"),
	preload("res://bot_imposible.tres"),
	preload("res://bot_dummy.tres"),
]

@export var arma_1: ArmaData
@export var arma_2: ArmaData
@export var arma_3: ArmaData
@export var acc_1: AccesorioData
@export var acc_2: AccesorioData
@export var acc_3: AccesorioData
@export var acc_4: AccesorioData

var modo_juego := 0  # 0=2P, 1=Cami vs bots, 2=Simon vs bots
var bot_elegido: BotData = null
var eleccion_arma_cami: ArmaData
var eleccion_arma_simon: ArmaData
var eleccion_acc_cami: AccesorioData
var eleccion_acc_simon: AccesorioData
var fase_actual := 0  # 0=modo, 1=bot, 2=armas, 3=accesorios

signal seleccion_completa(arma_cami: ArmaData, arma_simon: ArmaData, acc_cami: AccesorioData, acc_simon: AccesorioData, modo: int, bot: BotData)

@onready var label_cami := $VBoxCami/LabelCami as Label
@onready var opcion_cami := $VBoxCami/OpcionCami as Label
@onready var label_simon := $VBoxSimon/LabelSimon as Label
@onready var opcion_simon := $VBoxSimon/OpcionSimon as Label
@onready var titulo := $Titulo as Label
@onready var timer_inicio := $TimerInicio as Timer

var monedero: Node
var boss_secreto_activado := false
var codigo_secreto := [KEY_7, KEY_7, KEY_7, KEY_1, KEY_2, KEY_3, KEY_9, KEY_9, KEY_9]
var codigo_progreso := 0

const MAPA_ARMA_ID := ["espada", "lanza", "martillo"]
const MAPA_ACC_ID := ["escudo", "botas", "capa", "pechera"]

func _ready() -> void:
	monedero = get_node_or_null("/root/arena/Monedero")
	if monedero == null:
		var arena := get_tree().get_first_node_in_group("arena")
		if arena:
			monedero = arena.get_node_or_null("Monedero")
	_mostrar_fase_modo()

func _tiene_comprado(jugador: String, item_id: String) -> bool:
	if monedero == null:
		return true
	return monedero.tiene_comprado(jugador, item_id)

func _armas_disponibles(jugador: String) -> Array:
	var disponibles: Array = []
	var todas := [arma_1, arma_2, arma_3]
	for i in range(todas.size()):
		if _tiene_comprado(jugador, MAPA_ARMA_ID[i]):
			disponibles.append(todas[i])
	if disponibles.is_empty():
		disponibles.append(arma_1)
	return disponibles

func _accesorios_disponibles(jugador: String) -> Array:
	var disponibles: Array = []
	var todas := [acc_1, acc_2, acc_3, acc_4]
	for i in range(todas.size()):
		if _tiene_comprado(jugador, MAPA_ACC_ID[i]):
			disponibles.append(todas[i])
	return disponibles

func _mostrar_fase_modo() -> void:
	titulo.text = "¿QUIÉN JUEGA?\nCAMI elige: 1=Cami vs Bots  2=Simon vs Bots  3=2 Jugadores"
	label_cami.text = "CAMI elige el modo"
	label_simon.text = ""
	opcion_cami.text = "1 = Cami vs Bots    2 = Simon vs Bots    3 = 2P"
	opcion_simon.text = ""

func _mostrar_fase_bot() -> void:
	var jugador_str := "cami" if modo_juego == 1 else "simon"
	var mc := 0
	if monedero:
		mc = monedero.monedas_cami if modo_juego == 1 else monedero.monedas_simon
	
	var quien := "CAMI" if modo_juego == 1 else "SIMON"
	var txt := "🤖 ELIGE TU RIVAL (%s) 🤖\n" % quien
	txt += "Tienes %d 🪙\n\n" % mc
	for i in range(BOTS.size()):
		var b: BotData = BOTS[i]
		var costo_str := ""
		if b.costo_monedas > 0:
			costo_str = " (cuesta %d🪙)" % b.costo_monedas
		elif b.costo_monedas < 0:
			costo_str = " (¡te da %d🪙!)" % abs(b.costo_monedas)
		else:
			costo_str = " (GRATIS)"
		txt += "%d: %s - %s%s\n" % [i + 1, b.nombre_bot, b.descripcion, costo_str]
	
	titulo.text = txt
	if modo_juego == 1:
		label_cami.text = "CAMI (teclas 1-5)"
		label_simon.text = ""
	else:
		label_cami.text = ""
		label_simon.text = "SIMON (NumPad 1-5)"
	opcion_cami.text = ""
	opcion_simon.text = ""

func _mostrar_fase_armas() -> void:
	var armas_cami := _armas_disponibles("cami")
	var armas_simon := _armas_disponibles("simon")
	
	var txt := "⚔️ ELIGE TU ARMA ⚔️\n"
	txt += "CAMI: " + _lista_armas(armas_cami) + "\n"
	txt += "SIMON: " + _lista_armas(armas_simon)
	titulo.text = txt
	
	label_cami.text = "CAMI (teclas 1, 2, 3)"
	label_simon.text = "SIMON (NumPad 1, 2, 3)"
	opcion_cami.text = ""
	opcion_simon.text = ""

func _lista_armas(armas: Array) -> String:
	var partes: Array[String] = []
	for i in range(armas.size()):
		var a: ArmaData = armas[i]
		partes.append("%d: %s" % [i + 1, a.nombre_arma])
	return ", ".join(partes)

func _mostrar_fase_accesorios() -> void:
	var accs_cami := _accesorios_disponibles("cami")
	var accs_simon := _accesorios_disponibles("simon")
	
	var txt := "🛡️ ELIGE TU ACCESORIO 🛡️\n"
	txt += "CAMI: " + _lista_accesorios(accs_cami) + "\n"
	txt += "SIMON: " + _lista_accesorios(accs_simon)
	if accs_cami.is_empty() and accs_simon.is_empty():
		txt += "\n(Ningún accesorio comprado - presiona ENTER para pelear sin accesorio)"
	titulo.text = txt
	
	label_cami.text = "CAMI (teclas 1, 2, 3, 4)"
	label_simon.text = "SIMON (NumPad 1, 2, 3, 4)"
	opcion_cami.text = ""
	opcion_simon.text = ""

func _lista_accesorios(accs: Array) -> String:
	var partes: Array[String] = []
	for i in range(accs.size()):
		var a: AccesorioData = accs[i]
		partes.append("%d: %s" % [i + 1, a.nombre_accesorio])
	if partes.is_empty():
		return "(ninguno disponible)"
	return ", ".join(partes)

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed):
		return
	
	# Detectar código secreto: 777 123 999
	if not boss_secreto_activado:
		var tecla: int = event.keycode
		if tecla == codigo_secreto[codigo_progreso]:
			codigo_progreso += 1
			if codigo_progreso >= codigo_secreto.size():
				boss_secreto_activado = true
				_activar_boss_secreto()
				return
		else:
			codigo_progreso = 0
			# Reintentar si la tecla es el inicio de la secuencia
			if tecla == codigo_secreto[0]:
				codigo_progreso = 1

	if fase_actual == 0:
		_input_modo(event)
	elif fase_actual == 1:
		_input_bot(event)
	elif fase_actual == 2:
		_input_armas(event)
	else:
		_input_accesorios(event)

func _input_modo(event: InputEventKey) -> void:
	match event.keycode:
		KEY_1:
			modo_juego = 1  # Cami vs bots
			opcion_cami.text = "✅ Cami vs Bots"
			fase_actual = 1
			await get_tree().create_timer(0.5).timeout
			_mostrar_fase_bot()
		KEY_2:
			modo_juego = 2  # Simon vs bots
			opcion_cami.text = "✅ Simon vs Bots"
			fase_actual = 1
			await get_tree().create_timer(0.5).timeout
			_mostrar_fase_bot()
		KEY_3:
			modo_juego = 0  # 2P
			opcion_cami.text = "✅ Cami vs Simon"
			fase_actual = 2
			await get_tree().create_timer(0.5).timeout
			_mostrar_fase_armas()

func _input_bot(event: InputEventKey) -> void:
	var idx := -1
	# Cami elige con teclas 1-5, Simon con NumPad 1-5
	if modo_juego == 1:
		if event.keycode >= KEY_1 and event.keycode <= KEY_5:
			idx = event.keycode - KEY_1
	else:
		if event.keycode >= KEY_KP_1 and event.keycode <= KEY_KP_5:
			idx = event.keycode - KEY_KP_1
	
	if idx < 0 or idx >= BOTS.size():
		return
	
	var bot: BotData = BOTS[idx]
	var jugador_str := "cami" if modo_juego == 1 else "simon"
	
	# Verificar monedas
	if monedero:
		var mc: int = monedero.monedas_cami if modo_juego == 1 else monedero.monedas_simon
		if bot.costo_monedas > 0 and mc < bot.costo_monedas:
			if modo_juego == 1:
				opcion_cami.text = "❌ No tienes monedas (necesitas %d🪙)" % bot.costo_monedas
			else:
				opcion_simon.text = "❌ No tienes monedas (necesitas %d🪙)" % bot.costo_monedas
			return
		# Cobrar (o dar) monedas
		if bot.costo_monedas != 0:
			if bot.costo_monedas > 0:
				monedero.gastar_monedas(jugador_str, bot.costo_monedas)
			else:
				monedero.sumar_monedas(jugador_str, abs(bot.costo_monedas))
	
	bot_elegido = bot
	if modo_juego == 1:
		opcion_cami.text = "✅ %s" % bot.nombre_bot
		opcion_cami.add_theme_color_override("font_color", bot.color_bot)
	else:
		opcion_simon.text = "✅ %s" % bot.nombre_bot
		opcion_simon.add_theme_color_override("font_color", bot.color_bot)
	
	fase_actual = 2
	await get_tree().create_timer(0.5).timeout
	_mostrar_fase_armas()

func _input_armas(event: InputEventKey) -> void:
	var armas_cami := _armas_disponibles("cami")
	var armas_simon := _armas_disponibles("simon")
	var es_1p := modo_juego != 0
	
	# El bot elige arma aleatoria
	if es_1p:
		if modo_juego == 1 and eleccion_arma_simon == null and not armas_simon.is_empty():
			# Cami vs bots: Simon es el bot
			eleccion_arma_simon = armas_simon[randi() % armas_simon.size()]
			opcion_simon.text = "✅ %s (CPU)" % eleccion_arma_simon.nombre_arma
			opcion_simon.add_theme_color_override("font_color", eleccion_arma_simon.color_arma)
		elif modo_juego == 2 and eleccion_arma_cami == null and not armas_cami.is_empty():
			# Simon vs bots: Cami es el bot
			eleccion_arma_cami = armas_cami[randi() % armas_cami.size()]
			opcion_cami.text = "✅ %s (CPU)" % eleccion_arma_cami.nombre_arma
			opcion_cami.add_theme_color_override("font_color", eleccion_arma_cami.color_arma)

	if eleccion_arma_cami == null:
		var idx := _tecla_a_idx(event.keycode, false)
		if idx >= 0 and idx < armas_cami.size():
			eleccion_arma_cami = armas_cami[idx]
			opcion_cami.text = "✅ %s" % eleccion_arma_cami.nombre_arma
			opcion_cami.add_theme_color_override("font_color", eleccion_arma_cami.color_arma)

	if not es_1p and eleccion_arma_simon == null:
		var idx := _tecla_a_idx(event.keycode, true)
		if idx >= 0 and idx < armas_simon.size():
			eleccion_arma_simon = armas_simon[idx]
			opcion_simon.text = "✅ %s" % eleccion_arma_simon.nombre_arma
			opcion_simon.add_theme_color_override("font_color", eleccion_arma_simon.color_arma)

	if eleccion_arma_cami != null and eleccion_arma_simon != null:
		if es_1p:
			opcion_cami.text += "\nPresiona ENTER para seguir"
			if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
				fase_actual = 3
				await get_tree().create_timer(0.5).timeout
				_mostrar_fase_accesorios()
		else:
			fase_actual = 3
			await get_tree().create_timer(1.0).timeout
			_mostrar_fase_accesorios()

func _input_accesorios(event: InputEventKey) -> void:
	var accs_cami := _accesorios_disponibles("cami")
	var accs_simon := _accesorios_disponibles("simon")
	var es_1p := modo_juego != 0
	
	# El bot elige accesorio aleatorio
	if es_1p:
		if modo_juego == 1 and eleccion_acc_simon == null:
			if not accs_simon.is_empty():
				eleccion_acc_simon = accs_simon[randi() % accs_simon.size()]
				opcion_simon.text = "✅ %s (CPU)" % eleccion_acc_simon.nombre_accesorio
				opcion_simon.add_theme_color_override("font_color", eleccion_acc_simon.color_accesorio)
			else:
				eleccion_acc_simon = null
		elif modo_juego == 2 and eleccion_acc_cami == null:
			if not accs_cami.is_empty():
				eleccion_acc_cami = accs_cami[randi() % accs_cami.size()]
				opcion_cami.text = "✅ %s (CPU)" % eleccion_acc_cami.nombre_accesorio
				opcion_cami.add_theme_color_override("font_color", eleccion_acc_cami.color_accesorio)
			else:
				eleccion_acc_cami = null

	if eleccion_acc_cami == null:
		var idx := _tecla_a_idx(event.keycode, false)
		if idx >= 0 and idx < accs_cami.size():
			eleccion_acc_cami = accs_cami[idx]
			opcion_cami.text = "✅ %s" % eleccion_acc_cami.nombre_accesorio
			opcion_cami.add_theme_color_override("font_color", eleccion_acc_cami.color_accesorio)
	
	if accs_cami.is_empty() and eleccion_acc_cami == null:
		eleccion_acc_cami = null
	
	if not es_1p and eleccion_acc_simon == null:
		var idx := _tecla_a_idx(event.keycode, true)
		if idx >= 0 and idx < accs_simon.size():
			eleccion_acc_simon = accs_simon[idx]
			opcion_simon.text = "✅ %s" % eleccion_acc_simon.nombre_accesorio
			opcion_simon.add_theme_color_override("font_color", eleccion_acc_simon.color_accesorio)
	
	if accs_simon.is_empty() and eleccion_acc_simon == null:
		eleccion_acc_simon = null

	var cami_listo := eleccion_acc_cami != null or accs_cami.is_empty()
	var simon_listo := eleccion_acc_simon != null or accs_simon.is_empty()
	
	if cami_listo and simon_listo:
		if es_1p:
			opcion_cami.text += "\nPresiona ENTER para pelear"
			if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
				titulo.text = "¡A pelear!"
				timer_inicio.start()
		else:
			titulo.text = "¡Listos! A pelear..."
			timer_inicio.start()

func _tecla_a_idx(keycode: Key, es_simon: bool) -> int:
	if es_simon:
		if keycode >= KEY_KP_1 and keycode <= KEY_KP_4:
			return keycode - KEY_KP_1
	else:
		if keycode >= KEY_1 and keycode <= KEY_4:
			return keycode - KEY_1
	return -1

func _on_timer_inicio_timeout() -> void:
	emit_signal("seleccion_completa", eleccion_arma_cami, eleccion_arma_simon, eleccion_acc_cami, eleccion_acc_simon, modo_juego, bot_elegido)
	queue_free()

func _activar_boss_secreto() -> void:
	modo_juego = 3  # Modo boss secreto
	bot_elegido = preload("res://bot_secreto.tres")
	
	titulo.text = "👑 ¡BOSS SECRETO ACTIVADO! 👑\nCAMI y SIMON vs EL DUMMY\nPresiona ENTER para pelear"
	label_cami.text = "CAMI listo"
	label_simon.text = "SIMON listo"
	opcion_cami.text = "⚔️ Juntos contra El Dummy ⚔️"
	opcion_simon.text = "Presiona ENTER"
	
	# Asignar armas por defecto
	eleccion_arma_cami = arma_1
	eleccion_arma_simon = arma_2
	eleccion_acc_cami = null
	eleccion_acc_simon = null
	fase_actual = 3  # Saltar a fase final
	
	# Auto-iniciar con ENTER o esperar
	if not is_inside_tree():
		await ready
	timer_inicio.start()
