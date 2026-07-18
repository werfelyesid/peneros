extends CanvasLayer

## Tienda donde los jugadores pueden gastar sus monedas.

signal tienda_cerrada

## Precios de cada item
const PRECIOS := {
	"espada": 10,
	"lanza": 10,
	"martillo": 9,
	"escudo": 15,
	"botas": 10,
	"capa": 20,
	"pechera": 20,
	"fuego": 25
}

## Nombres bonitos para mostrar
const NOMBRES := {
	"espada": "🗡️ Espada",
	"lanza": "🏹 Lanza",
	"martillo": "🔨 Martillo",
	"escudo": "🛡️ Escudo",
	"botas": "👢 Botas",
	"capa": "🧥 Capa",
	"pechera": "🦺 Pechera",
	"fuego": "🔥 Bola de Fuego"
}

const ITEMS_CAMI := ["espada", "lanza", "martillo", "escudo", "botas", "capa", "pechera", "fuego"]
const ITEMS_SIMON := ["espada", "lanza", "martillo", "escudo", "botas", "capa", "pechera", "fuego"]

@onready var titulo: Label = $Titulo
@onready var info: Label = $Info
@onready var label_cami: Label = $LabelCami
@onready var label_simon: Label = $LabelSimon

var monedero: Node

func _ready() -> void:
	monedero = get_node_or_null("/root/arena/Monedero")
	if monedero == null:
		var arena := get_tree().get_first_node_in_group("arena")
		if arena:
			monedero = arena.get_node_or_null("Monedero")
	
	_actualizar_texto()

func _actualizar_texto() -> void:
	var mc := 0
	var ms := 0
	if monedero:
		mc = monedero.monedas_cami
		ms = monedero.monedas_simon
	
	titulo.text = "🏪 TIENDA PEÑEROS 🏪"
	
	# Construir lista de items con precios y estado de compra
	info.text = "═══ ARMAS (10🪙 c/u) ═══\n"
	info.text += _item_str("espada", 1, "cami") + "\n"
	info.text += _item_str("lanza", 2, "cami") + "     " + _item_str("fuego", 8, "cami") + " (🔥 25🪙)\n"
	info.text += _item_str("martillo", 3, "cami") + "\n\n"
	
	info.text += "═══ ACCESORIOS ═══\n"
	info.text += _item_str("escudo", 4, "cami") + " (15🪙)     " + _item_str("capa", 6, "cami") + " (20🪙)\n"
	info.text += _item_str("botas", 5, "cami") + " (15🪙)     " + _item_str("pechera", 7, "cami") + " (15🪙)\n\n"
	
	info.text += "CAMI: teclas 1-8  |  SIMON: NumPad 1-8\n"
	info.text += "Presiona ENTER para volver a pelear"
	
	label_cami.text = "Cami: %d 🪙" % mc
	label_simon.text = "Simon: %d 🪙" % ms

func _item_str(item_id: String, tecla: int, _jugador: String) -> String:
	var nombre: String = NOMBRES.get(item_id, item_id)
	var s := "%d:%s" % [tecla, nombre]
	# Marcar si ya fue comprado
	if monedero and monedero.tiene_comprado("cami", item_id):
		s += "✅"
	return s

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed):
		return
	
	# Cerrar tienda
	if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
		emit_signal("tienda_cerrada")
		queue_free()
		return
	
	# Compras de Cami (teclas 1-8)
	if event.keycode >= KEY_1 and event.keycode <= KEY_8:
		var idx: int = event.keycode - KEY_1
		if idx < ITEMS_CAMI.size():
			_comprar("cami", ITEMS_CAMI[idx])
	
	# Compras de Simon (NumPad 1-8)
	if event.keycode >= KEY_KP_1 and event.keycode <= KEY_KP_8:
		var idx: int = event.keycode - KEY_KP_1
		if idx < ITEMS_SIMON.size():
			_comprar("simon", ITEMS_SIMON[idx])

func _comprar(jugador: String, item_id: String) -> void:
	if monedero == null:
		return
	
	# Verificar si ya lo compró
	if monedero.tiene_comprado(jugador, item_id):
		_mostrar_mensaje(jugador, "¡Ya tienes " + NOMBRES.get(item_id, item_id) + "!")
		return
	
	var precio: int = PRECIOS.get(item_id, 999)
	if monedero.gastar_monedas(jugador, precio):
		monedero.registrar_compra(jugador, item_id)
		_mostrar_mensaje(jugador, "¡Compraste " + NOMBRES.get(item_id, item_id) + "!")
		_actualizar_texto()
	else:
		_mostrar_mensaje(jugador, "No tienes suficientes monedas (necesitas %d 🪙)" % precio)

func _mostrar_mensaje(jugador: String, msg: String) -> void:
	if jugador == "cami":
		label_cami.text = msg
		# Restaurar después de 2 segundos
		var timer := get_tree().create_timer(2.0)
		timer.timeout.connect(_actualizar_texto)
	else:
		label_simon.text = msg
		var timer := get_tree().create_timer(2.0)
		timer.timeout.connect(_actualizar_texto)
