extends Node

## Guarda y carga las monedas y compras en un archivo JSON.
## Las monedas y compras no se pierden al cerrar el juego.

const RUTA := "user://monedas_peñeros.json"

var monedas_cami := 0
var monedas_simon := 0

## Compras realizadas por cada jugador (IDs de items)
var compras_cami: Array[String] = []
var compras_simon: Array[String] = []

func _ready() -> void:
	_cargar()

func _cargar() -> void:
	if not FileAccess.file_exists(RUTA):
		return

	var archivo := FileAccess.open(RUTA, FileAccess.READ)
	if archivo == null:
		return

	var texto := archivo.get_as_text()
	archivo.close()

	var json := JSON.new()
	var error := json.parse(texto)
	if error == OK:
		var datos = json.data
		monedas_cami = int(datos.get("cami", 0))
		monedas_simon = int(datos.get("simon", 0))
		# Cargar compras (compatibilidad con versiones anteriores)
		var cc = datos.get("compras_cami", [])
		if cc is Array:
			for item in cc:
				compras_cami.append(str(item))
		var cs = datos.get("compras_simon", [])
		if cs is Array:
			for item in cs:
				compras_simon.append(str(item))

func _guardar() -> void:
	var datos := {
		"cami": monedas_cami,
		"simon": monedas_simon,
		"compras_cami": compras_cami,
		"compras_simon": compras_simon
	}
	var archivo := FileAccess.open(RUTA, FileAccess.WRITE)
	if archivo == null:
		return

	archivo.store_string(JSON.stringify(datos, "\t"))
	archivo.close()

func sumar_monedas(jugador: String, cantidad: int) -> void:
	if jugador == "cami":
		monedas_cami += cantidad
	else:
		monedas_simon += cantidad
	_guardar()

func gastar_monedas(jugador: String, cantidad: int) -> bool:
	if jugador == "cami":
		if monedas_cami >= cantidad:
			monedas_cami -= cantidad
			_guardar()
			return true
	else:
		if monedas_simon >= cantidad:
			monedas_simon -= cantidad
			_guardar()
			return true
	return false

## Registra la compra de un item para un jugador
func registrar_compra(jugador: String, item_id: String) -> void:
	if jugador == "cami":
		if item_id not in compras_cami:
			compras_cami.append(item_id)
	else:
		if item_id not in compras_simon:
			compras_simon.append(item_id)
	_guardar()

## Verifica si un jugador ya compró un item
func tiene_comprado(jugador: String, item_id: String) -> bool:
	if jugador == "cami":
		return item_id in compras_cami
	else:
		return item_id in compras_simon
