extends Node
var volumen_general = 1.0
var volumen_musica = 1.0
var volumen_sfx = 1.0
var bus_general: int
var bus_musica: int
var bus_sfx: int
var sonidoBoton1 = preload("res://Sonidos/sonidoBoton1.wav")
var ruta_del_juego = get_scene_file_path()
var lenguajeDefault = "es":
	get:
		return lenguajeDefault
	set(value):
		lenguajeDefault = value
		emit_signal("Config_lenguajeCambiado")
var listaLenguajes = {"es" = "Español","en" = "English"}
var preRuta_produccion = OS.get_user_data_dir()
const preRuta_pruebas = "C:/Users/usuario/Downloads/Temporal/"
const preRuta_base = "res://"
const ruta_guardado = "saves/"
const nombre_archivo_guardado = "save"
const extension_archivo_guardado = ".json"
const codigo_seguridad = "089SADFH"
const nombre_archivo_inicial = "config"
signal Config_lenguajeCambiado()
