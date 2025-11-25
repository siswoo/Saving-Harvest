extends Node
var global_position = Vector2.ZERO
var salud
var saludMaxima
var hambre
var hambreMaxima
var sed
var sedMaxima
var energia
var energiaMaxima
var dia
var mes
var año
var minuto
var hora
var mundo
var slotInventario = 10
var itemInventario = {
	0:{
		"id" = 1,
		"cantidad" = 3,
		"durabilidad" = 20,
	},
	1:{
		"id" = 1,
		"cantidad" = 3,
		"durabilidad" = 18,
	},
	2:{
		"id" = 2,
		"cantidad" = 4,
		"durabilidad" = 20,
	},
	3:{
		"id" = 3,
		"cantidad" = 1,
		"durabilidad" = 20,
	},
	4:{
		"id" = 4,
		"cantidad" = 1,
		"durabilidad" = 20,
	},
	5:{
		"id" = 5,
		"cantidad" = 1,
		"durabilidad" = 0,
	},
}
var maxSlotInventario = 30
var minSlotInventario = 1
var inventarioAbierto: bool = false
var inventarioSlotSeñalado: String
signal s_inventarioSwitch
signal s_inventarioSlotSeñalado

func _ready() -> void:
	add_to_group("PROP_JUGADOR")
	s_inventarioSwitch.connect(_inventarioSwitch)
	#butNeverUsed
	s_inventarioSlotSeñalado.connect(_butNeverUsed)

func nuevoJugador() -> void:
	global_position = Vector2(0,0)
	salud = 10
	saludMaxima = 10
	hambre = 100
	hambreMaxima = 100
	sed = 100
	sedMaxima = 100
	energia = 100
	energiaMaxima = 100
	dia = 1
	mes = 1
	año = 1
	mundo = 1
	slotInventario = 10
	#itemInventario = {}

func _inventarioSwitch()->void:
	inventarioAbierto = !inventarioAbierto
	inventarioSlotSeñalado = ""
	

func _butNeverUsed()->void:
	pass
