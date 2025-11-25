extends Node
@onready var español = load("res://Globales/Lenguajes/es.gd").new()
var archivosCreados: bool = false:
	set(value):
		archivosCreados = value
		todoCreado(value)
var translations = {}
var path = CONFIG.preRuta_pruebas+"Translations.csv"
var cargaCompleta: bool = false
var archivo
var temporizador1: Timer

func _ready():
	temporizador1 = Timer.new()
	add_child(temporizador1)
	export_to_csv(path)

func export_to_csv(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		print("Error: Failed to open file.")
		return
	var header = "key"
	translations = {
		"es": español.translations
	}
	for lang in translations.keys():
		header += "," + lang
	file.store_line(header)

	var keys = []
	for lang in translations.values():
		for key in lang.keys():
			if key not in keys:
				keys.append(key)

	for key in keys:
		var line = key
		for lang in translations.keys():
			line += "," + translations[lang].get(key, "")
		file.store_line(line)

	file.close()
	#ProjectSettings.globalize_path(file_path)
	print("CSV export completed.")
	import_translations_from_csv(file_path)
	#lenguajesHabilitados()

func import_translations_from_csv(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		print("Error: Failed to open CSV file at path: ", file_path)
		return

	# Leer la primera línea (encabezados)
	var header = file.get_line().strip_edges().split(",")
	#var keys_index = header.index("key")
	var keys_index = header.find("key")
	
	if keys_index == -1:
		print("Error: 'key' column not found in the CSV file.")
		return
	
	var translationsImport = {}
	
	# Leer el resto de las líneas (datos)
	while not file.eof_reached():
		var line = file.get_line().strip_edges().split(",")
		if line.size() == header.size():
			var key = line[keys_index]
			for i in range(1, header.size()):
				var lang_code = header[i]
				var translation = line[i]
				if not translationsImport.has(lang_code):
					translationsImport[lang_code] = {}
				translationsImport[lang_code][key] = translation
	file.close()
	print("CSV import completed.")
	# Guardar las traducciones en archivos de lenguaje
	for lang_code in translationsImport.keys():
		save_translation_for_language(lang_code, translationsImport[lang_code])

func save_translation_for_language(language_code: String, translation):
	var file_path = CONFIG.preRuta_pruebas + language_code + ".translation"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file == null:
		print("Error: Failed to open translation file at path: ", file_path)
		return

	# Escribir las traducciones en el archivo
	for key in translations.keys():
		var llavesTrans = translations[key]
		file.store_line(str(llavesTrans))

func lenguajesHabilitados() -> void:
	for key in translations.keys():
		archivo = CONFIG.preRuta_pruebas+"Translate/Translations." + key + ".translation"
		await wait_for_file(archivo)
		var cargaLenguaje = load(archivo)
		#TranslationServer.add_translation(cargaLenguaje)
	cargaCompleta = true

func wait_for_file(file_path: String) -> void:
	while not FileAccess.file_exists(file_path):
		temporizador1.start(0.1)
		await temporizador1.timeout
	temporizador1.stop()

func todoCreado(value) -> void:
	print("listo")
