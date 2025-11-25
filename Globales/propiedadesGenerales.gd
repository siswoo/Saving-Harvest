extends Node
var SAVE_DIR = CONFIG.ruta_del_juego
var SAVE_FILE_NAME = CONFIG.nombre_archivo_inicial
var SAVE_FILE_EXTENSION = CONFIG.extension_archivo_guardado
var SECURITY_KEY = CONFIG.codigo_seguridad
var path = SAVE_DIR + SAVE_FILE_NAME + SAVE_FILE_EXTENSION
var juegoPausado = false
var rutaTraduccionesPerso = "res://TraduccionesPerso/"
var traduccionesPerso = {
	"items" = rutaTraduccionesPerso+"items"
}

func _ready() -> void:
	if FileAccess.file_exists(path):
		cargarOpciones()
	else:
		primerGuardadoOpciones()

func primerGuardadoOpciones() -> void:
	var file = FileAccess.open_encrypted_with_pass(path,FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
	var data = {
		"config_data":{
			"volumen_general": CONFIG.volumen_general,
			"volumen_musica": CONFIG.volumen_musica,
			"volumen_sonido": CONFIG.volumen_sfx,
			"idioma": CONFIG.lenguajeDefault,
		}
	}
	var json_string = JSON.stringify(data,"\t")
	file.store_string(json_string)
	file.close()
	refrescarIdioma()

func cargarOpciones() -> void:
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path,FileAccess.READ,SECURITY_KEY)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if data == null:
			print("toca borrar el archivo de config")
			return
		CONFIG.volumen_general = data["config_data"]["volumen_general"]
		CONFIG.volumen_musica = data["config_data"]["volumen_musica"]
		CONFIG.volumen_sfx = data["config_data"]["volumen_sonido"]
		CONFIG.lenguajeDefault = data["config_data"]["idioma"]

func editarOpciones() -> void:
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path,FileAccess.READ,SECURITY_KEY)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if data == null:
			print("toca borrar el archivo de config")
			return
		data["config_data"]["volumen_general"] = CONFIG.volumen_general
		data["config_data"]["volumen_musica"] = CONFIG.volumen_musica
		data["config_data"]["volumen_sonido"] = CONFIG.volumen_sfx
		data["config_data"]["idioma"] = CONFIG.lenguajeDefault
		var json_string = JSON.stringify(data,"\t")
		file = FileAccess.open_encrypted_with_pass(path,FileAccess.WRITE,SECURITY_KEY)
		file.store_string(json_string)
		file.close()

func pausarJuego() -> void:
	juegoPausado = !juegoPausado
	if juegoPausado:
		get_tree().call_group("pausables","set_process",false)
		get_tree().call_group("pausables","set_physics_process",false)
		get_tree().call_group("PROP_JUGADOR","set_process",false)
	else:
		get_tree().call_group("pausables","process",true)
		get_tree().call_group("pausables","set_physics_process",true)

func refrescarIdioma() -> void:
	TranslationServer.set_locale(CONFIG.lenguajeDefault)
