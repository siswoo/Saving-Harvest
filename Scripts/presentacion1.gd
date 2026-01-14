extends Node2D
@onready var parte_1: TextureRect = $CanvasLayer/Parte1
@onready var parte_2: TextureRect = $CanvasLayer/Parte2
@onready var parte_3: TextureRect = $CanvasLayer/Parte3
var mundo1 = preload("res://scenes/mundo1.tscn")

func _ready() -> void:
	parte_1.visible = true
	parte_2.visible = false
	parte_3.visible = false
	MUSICAS.cambiarMusica(5)
	PROP_JUGADOR.nuevoJugador()
	$CanvasLayer/Parte1/siguiente1.connect("pressed",interaccionBotones.bind(1))
	$CanvasLayer/Parte2/siguiente2.connect("pressed",interaccionBotones.bind(2))
	$CanvasLayer/Parte2/anterior2.connect("pressed",interaccionBotones.bind(0))
	$CanvasLayer/Parte3/siguiente3.connect("pressed",interaccionBotones.bind(3))
	$CanvasLayer/Parte3/anterior3.connect("pressed",interaccionBotones.bind(1))
	$CanvasLayer/Parte1/siguiente1.connect("mouse_entered",sonidosMouses)
	$CanvasLayer/Parte2/siguiente2.connect("mouse_entered",sonidosMouses)
	$CanvasLayer/Parte3/siguiente3.connect("mouse_entered",sonidosMouses)
	$CanvasLayer/Parte2/anterior2.connect("mouse_entered",sonidosMouses)
	$CanvasLayer/Parte3/anterior3.connect("mouse_entered",sonidosMouses)
	lenguajes()
	CONFIG.connect("Config_lenguajeCambiado",lenguajes)

func lenguajes() -> void:
	GENERALES.refrescarIdioma()
	$CanvasLayer/Parte1/Texto1.text = tr("opciones.gd=CanvasLayer/Parte1/Texto1")
	$CanvasLayer/Parte2/Texto1.text = tr("opciones.gd=CanvasLayer/Parte2/Texto1")
	$CanvasLayer/Parte3/Texto1.text = tr("opciones.gd=CanvasLayer/Parte3/Texto1")
	
func interaccionBotones(boton: int = 0) -> void:
	if boton == 0:
		parte_1.visible = true
		parte_2.visible = false
	elif boton == 1:
		parte_1.visible = false
		parte_2.visible = true
		parte_3.visible = false
	elif boton == 2:
		parte_2.visible = false
		parte_3.visible = true
	elif boton == 3:
		get_tree().change_scene_to_packed(mundo1)

func sonidosMouses() -> void:
	SONIDOS.audio_botones_1.set_stream(CONFIG.sonidoBoton1)
	SONIDOS.audio_botones_1.play()
