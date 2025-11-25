extends CanvasLayer
@onready var fondo: TextureRect = $Fondo
@onready var marco: TextureRect = $Marco
@onready var container_macro: VBoxContainer = $ContainerMacro
var SAVE_DIR = CONFIG.ruta_guardado
var SAVE_FILE_NAME = CONFIG.nombre_archivo_guardado
var SAVE_FILE_EXTENSION = CONFIG.extension_archivo_guardado
var SECURITY_KEY = CONFIG.codigo_seguridad
var condicionMuestra = false
var condicionPrincipal = false

func _ready() -> void:
	fondo.visible = false
	marco.visible = false
	container_macro.visible = false
	verify_save_directory(SAVE_DIR)
	$ContainerMacro/Container1/guardar1B.connect("pressed",save_data.bind(1))
	$ContainerMacro/Container1/cargar1B.connect("pressed",load_data.bind(1))
	$ContainerMacro/Container2/guardar2B.connect("pressed",save_data.bind(2))
	$ContainerMacro/Container2/cargar2B.connect("pressed",load_data.bind(2))
	$ContainerMacro/Container3/guardar3B.connect("pressed",save_data.bind(3))
	$ContainerMacro/Container3/cargar3B.connect("pressed",load_data.bind(3))
	lenguajes()
	CONFIG.connect("Config_lenguajeCambiado",lenguajes)

func lenguajes() -> void:
	GENERALES.refrescarIdioma()
	$Marco/Label.text = tr("guardados.gd=Marco/Label")
	$Marco/cancelarB/Label.text = tr("guardados.gd=Marco/cancelarB/Label")
	$ContainerMacro/Container1/nombreP.text = tr("guardados.gd=ContainerMacro/Container1/nombreP")
	$ContainerMacro/Container1/cargar1B/Label.text = tr("guardados.gd=ContainerMacro/Container1/cargar1B/Label")
	$ContainerMacro/Container1/guardar1B/Label.text = tr("guardados.gd=ContainerMacro/Container1/guardar1B/Label")
	
	$ContainerMacro/Container2/nombreP.text = tr("guardados.gd=ContainerMacro/Container2/nombreP")
	$ContainerMacro/Container2/cargar2B/Label.text = tr("guardados.gd=ContainerMacro/Container2/cargar2B/Label")
	$ContainerMacro/Container2/guardar2B/Label.text = tr("guardados.gd=ContainerMacro/Container2/guardar2B/Label")
	
	$ContainerMacro/Container3/nombreP.text = tr("guardados.gd=ContainerMacro/Container3/nombreP")
	$ContainerMacro/Container3/cargar3B/Label.text = tr("guardados.gd=ContainerMacro/Container3/cargar3B/Label")
	$ContainerMacro/Container3/guardar3B/Label.text = tr("guardados.gd=ContainerMacro/Container3/guardar3B/Label")
	
func mapaPrincipal(condicion: bool = false) -> void:
	if condicion:
		condicionPrincipal = true
	else:
		condicionPrincipal = false
	iniciarCargas()

func iniciarCargas() -> void:
	var path
	for i in range(1,4):
		path = SAVE_DIR + SAVE_FILE_NAME + str(i) + SAVE_FILE_EXTENSION
		if FileAccess.file_exists(path):
			get_node("ContainerMacro/Container"+str(i)+"/nombreP").text = "Aqui Info"
			get_node("ContainerMacro/Container"+str(i)+"/cargar"+str(i)+"B").disabled = false
			get_node("ContainerMacro/Container"+str(i)+"/cargar"+str(i)+"B/Disabled").visible = false
		else:
			get_node("ContainerMacro/Container"+str(i)+"/nombreP").text = "Ranura Disponible"
			get_node("ContainerMacro/Container"+str(i)+"/cargar"+str(i)+"B").disabled = true
			get_node("ContainerMacro/Container"+str(i)+"/cargar"+str(i)+"B/Disabled").visible = true
		if condicionPrincipal:
			get_node("ContainerMacro/Container"+str(i)+"/guardar"+str(i)+"B").disabled = true
			get_node("ContainerMacro/Container"+str(i)+"/guardar"+str(i)+"B/Disabled").visible = true
		else:
			get_node("ContainerMacro/Container"+str(i)+"/guardar"+str(i)+"B").disabled = false
			get_node("ContainerMacro/Container"+str(i)+"/guardar"+str(i)+"B/Disabled").visible = false

func mostrar() -> void:
	iniciarCargas()
	condicionMuestra = !condicionMuestra
	if condicionMuestra:
		fondo.visible = true
		marco.visible = true
		container_macro.visible = true
	else:
		fondo.visible = false
		marco.visible = false
		container_macro.visible = false

func verify_save_directory(path: String) -> void:
	DirAccess.make_dir_absolute(path)

func save_data(slot: int)-> void:
	var path = SAVE_DIR + SAVE_FILE_NAME + str(slot) + SAVE_FILE_EXTENSION
	var file = FileAccess.open_encrypted_with_pass(path,FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
	var data = guardadoMasivo()
	var json_string = JSON.stringify(data,"\t")
	file.store_string(json_string)
	file.close()
	iniciarCargas()

func load_data(slot: int) -> void:
	var path = SAVE_DIR + SAVE_FILE_NAME + str(slot) + SAVE_FILE_EXTENSION
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path,FileAccess.READ,SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannont parse %s as a json_string (%s)" % [path,content])
			return
		cargaMasiva(data)
	else:
		printerr("Cannot open non-existent file at %s! " %[path])

func _on_guardar_1b_pressed() -> void:
	save_data(1)

func _on_guardar_2b_pressed() -> void:
	save_data(2)

func _on_guardar_3b_pressed() -> void:
	save_data(3)

func _on_cancelar_b_pressed() -> void:
	mostrar()

func guardadoMasivo():
	var data = {
		"player_data":{
			"global_position": {
				"x": PROP_JUGADOR.global_position.x,
				"y": PROP_JUGADOR.global_position.y
			},
			"salud": PROP_JUGADOR.salud,
			"salud_maxima": PROP_JUGADOR.saludMaxima,
			"hambre": PROP_JUGADOR.hambre,
			"hambre_maxima": PROP_JUGADOR.hambreMaxima,
			"sed": PROP_JUGADOR.sed,
			"sed_maxima": PROP_JUGADOR.sedMaxima,
			"energia": PROP_JUGADOR.energia,
			"energia_maxima": PROP_JUGADOR.energiaMaxima,
			"dia": PROP_JUGADOR.dia,
			"mes": PROP_JUGADOR.mes,
			"año": PROP_JUGADOR.año,
			"mundo": 1,
		}
	}
	return data

func cargaMasiva(data) -> void:
	PROP_JUGADOR.salud = data.player_data.salud
	PROP_JUGADOR.saludMaxima = data.player_data.salud_maxima
	PROP_JUGADOR.global_position = Vector2(data.player_data.global_position.x, data.player_data.global_position.y)
	PROP_JUGADOR.mundo = data.player_data.mundo
	print(data)
