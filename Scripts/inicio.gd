extends CanvasLayer
@onready var audio_botones: AudioStreamPlayer2D = $AudioBotones
@onready var opciones: CanvasLayer = $opciones
@onready var guardados: CanvasLayer = $guardados
var presentacion1 = preload("res://scenes/presentacion1.tscn")

func _ready() -> void:
	lenguajes()
	CONFIG.connect("Config_lenguajeCambiado",lenguajes)
	get_node("iniciarB").connect("mouse_entered",sonidosMouses)
	get_node("cargarB").connect("mouse_entered",sonidosMouses)
	get_node("opcionesB").connect("mouse_entered",sonidosMouses)
	get_node("salirB").connect("mouse_entered",sonidosMouses)
	get_node("iniciarB").connect("pressed",get_tree().change_scene_to_packed.bind(presentacion1))
	#get_node("cargarB").connect("pressed",guardados.mostrar)
	get_node("opcionesB").connect("pressed",opciones.mostrar)
	get_node("salirB").connect("pressed",get_tree().quit)

func lenguajes() -> void:
	GENERALES.refrescarIdioma()
	$iniciarB/Label.text = tr("presentacion1.gd=iniciarB")
	$cargarB/Label.text = tr("presentacion1.gd=cargarB")
	$opcionesB/Label.text = tr("presentacion1.gd=opcionesB")
	$salirB/Label.text = tr("presentacion1.gd=salirB")

func sonidosMouses() -> void:
	audio_botones.set_stream(CONFIG.sonidoBoton1)
	audio_botones.play()

func _on_cargar_b_pressed() -> void:
	guardados.mostrar()
	guardados.mapaPrincipal(true)
