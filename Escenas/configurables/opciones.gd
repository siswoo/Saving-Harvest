extends CanvasLayer
@onready var fondo: TextureRect = $Fondo
@onready var marco: TextureRect = $Marco
@onready var general_slider: HSlider = $VBoxContainer/HBoxContainer/GeneralSlider
@onready var volumen_slider: HSlider = $VBoxContainer/HBoxContainer3/VolumenSlider
@onready var sfx_slider: HSlider = $VBoxContainer/HBoxContainer2/SFXSlider
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var salir_b: Button = $Marco/salirB
@onready var idiomasSelect: OptionButton = $VBoxContainer/HBoxContainer4/OptionButton
var nivelInicio = load("res://Escenas/inicio.tscn")
var condicionMuestra: bool = false

func _ready() -> void:
	lenguajes()
	itemsIdiomas()
	CONFIG.connect("Config_lenguajeCambiado",lenguajes)
	fondo.visible = false
	marco.visible = false
	v_box_container.visible = false
	salir_b.visible = false
	CONFIG.bus_musica = AudioServer.get_bus_index("Music")
	CONFIG.bus_sfx = AudioServer.get_bus_index("SFX")
	general_slider.value_changed.connect(_generalVolumen)
	volumen_slider.value_changed.connect(_musicaVolumen)
	sfx_slider.value_changed.connect(_SFXVolumen)
	#general_slider.value = db_to_linear(AudioServer.get_bus_volume_db(CONFIG.bus_general))
	#volumen_slider.value = db_to_linear(AudioServer.get_bus_volume_db(CONFIG.bus_musica))
	#sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(CONFIG.bus_sfx))
	general_slider.value = CONFIG.volumen_general
	volumen_slider.value = CONFIG.volumen_musica
	sfx_slider.value = CONFIG.volumen_sfx
	refrescarVolumen()
	get_node("Marco/cancelarB").connect("mouse_entered",sonidosMouses)
	get_node("Marco/guardarB").connect("mouse_entered",sonidosMouses)
	get_node("Marco/salirB").connect("mouse_entered",sonidosMouses)
	get_node("Marco/cancelarB").connect("pressed",mostrar)
	get_node("Marco/guardarB").connect("pressed",guardarCambios)
	get_node("Marco/salirB").connect("pressed",mostrarAdvertencia.bind(true))
	get_node("AdvertenciaCerrar1/siB").connect("pressed",seguroCerrar.bind(true))
	get_node("AdvertenciaCerrar1/noB").connect("pressed",seguroCerrar)

func lenguajes() -> void:
	GENERALES.refrescarIdioma()
	$Marco/Label.text = tr("opciones.gd=Marco/Label")
	$VBoxContainer/HBoxContainer/BusNameL.text = tr("opciones.gd=VBoxContainer/HBoxContainer/BusNameL")
	$VBoxContainer/HBoxContainer3/BusNameL.text = tr("opciones.gd=VBoxContainer/HBoxContainer3/BusNameL")
	$VBoxContainer/HBoxContainer2/BusNameL.text = tr("opciones.gd=VBoxContainer/HBoxContainer2/BusNameL")
	$Marco/cancelarB/Label.text = tr("opciones.gd=Marco/cancelarB/Label")
	$Marco/salirB/Label.text = tr("opciones.gd=Marco/salirB/Label")
	$Marco/guardarB/Label.text = tr("opciones.gd=Marco/guardarB/Label")
	$VBoxContainer/HBoxContainer4/BusNameL.text = tr("opciones.gd=VBoxContainer/HBoxContainer4/BusNameL")
	$AdvertenciaCerrar1/texto.text = tr("opciones.gd=AdvertenciaCerrar1/texto")
	$AdvertenciaCerrar1/siB/Label.text = tr("opciones.gd=AdvertenciaCerrar1/siB/Label")
	$AdvertenciaCerrar1/noB/Label.text = tr("opciones.gd=AdvertenciaCerrar1/noB/Label")

func itemsIdiomas() -> void:
	var contador1 = 0
	for key in CONFIG.listaLenguajes:
		idiomasSelect.add_item(CONFIG.listaLenguajes[key])
		if key == CONFIG.lenguajeDefault:
			idiomasSelect.select(contador1)
		contador1 += 1

func _generalVolumen(value:float)->void:
	CONFIG.volumen_general = value

func _musicaVolumen(value:float)->void:
	CONFIG.volumen_musica = value

func _SFXVolumen(value:float)->void:
	CONFIG.volumen_sfx = value

func mostrar(condicion = false) -> void:
	GENERALES.pausarJuego()
	condicionMuestra = !condicionMuestra
	if condicionMuestra:
		fondo.visible = true
		marco.visible = true
		v_box_container.visible = true
		if condicion:
			salir_b.visible = true
	else:
		fondo.visible = false
		marco.visible = false
		v_box_container.visible = false
		salir_b.visible = false
	
func guardarCambios() -> void:
	refrescarVolumen()
	if idiomasSelect.get_selected_id()==0:
		CONFIG.lenguajeDefault = "es"
	elif idiomasSelect.get_selected_id()==1:
		CONFIG.lenguajeDefault = "en"
	GENERALES.editarOpciones()
	lenguajes()

func refrescarVolumen() -> void:
	AudioServer.set_bus_volume_db(CONFIG.bus_general,linear_to_db(CONFIG.volumen_general))
	AudioServer.set_bus_volume_db(CONFIG.bus_musica,linear_to_db(CONFIG.volumen_musica))
	AudioServer.set_bus_volume_db(CONFIG.bus_sfx,linear_to_db(CONFIG.volumen_sfx))

func sonidosMouses() -> void:
	SONIDOS.audio_botones_1.set_stream(CONFIG.sonidoBoton1)
	SONIDOS.audio_botones_1.play()

func mostrarAdvertencia(condicion: bool = false) -> void:
	if condicion:
		get_node("AdvertenciaCerrar1").visible = true
	else:
		get_node("AdvertenciaCerrar1").visible = false

func seguroCerrar(condicion: bool = false) -> void:
	if condicion:
		get_tree().change_scene_to_packed(nivelInicio)
	else:
		mostrarAdvertencia()
