extends TextureRect
@onready var fondo: TextureRect = $fondo
@onready var imagenO: TextureRect = $imagen
@onready var cantidad_l: Label = $cantidadL
@onready var marco_seleccionado: TextureRect = $marcoSeleccionado
var numeroSlot = 0
var id: int
var nombre = ""
var descripcion = ""
var imagen = TextureRect
var rutaImagen = ""
var cantidad: int
var cantidadMaxima: int
var equipable: bool = false
var consumible: bool = false
var cura = 0.0
var daño = 0.0
var regenera = 0.0
var segundos = 0.0
var precioCompra = 0.0
var precioVenta = 0.0
var peso = 0.0
var levelMinimo = 1
var ataque = 0
var defensa = 0
var agilidad = 0
var magia = 0
var fuego = 0
var agua = 0
var roca = 0
var viento = 0
var durabilidad = 0
var rareza = 0
var color
var letraColor

func _ready() -> void:
	PROP_JUGADOR.connect("s_inventarioSlotSeñalado",slotActivo)
	PROP_JUGADOR.connect("s_inventarioSwitch",marcoShow.bind(false))

func _get_drag_data(_at_position: Vector2):
	if id >= 1:
		var data = {}
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		if imagenO != null:
			imagenO.texture = imagen
		else:
			imagenO.texture = load("res://assets/textures/interrogacion1.png")
		drag_texture.texture = imagen
		drag_texture.size = Vector2(50,50)
		set_drag_preview(drag_texture)
		data = {
			"id" = id,
			"cantidad" = cantidad,
			"durabilidad" = durabilidad,
			"self" = self,
			"equipable" = equipable,
			"rutaImagen" = rutaImagen,
			"fondo" = fondo,
		}
		return data

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data.id == 0:
		return false
	else:
		return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	infoEntrante(data)
	pass

func setearInfo(item,cantidadR,durabilidadR,itemId) -> void:
	var lenguajeActual = CONFIG.lenguajeDefault
	id = itemId
	nombre = item["nombre_"+lenguajeActual]
	descripcion = item["descripcion_"+lenguajeActual]
	if item["imagen"] != null:
		rutaImagen = "res://assets/textures/"+item["imagen"]
		imagen = load(rutaImagen)
	cantidad = cantidadR
	cantidadMaxima = item["cantidadMaxima"]
	
	if item["equipable"] == "si":
		equipable = true
	else:
		equipable = false

	if item["consumible"] == "si":
		consumible = true
	else:
		consumible = false
	cura = item["cura"]
	daño = item["daño"]
	regenera = item["regenera"]
	segundos = item["segundos"]
	precioCompra = item["precioCompra"]
	precioVenta = item["precioVenta"]
	peso = item["peso"]
	levelMinimo = item["levelMinimo"]
	ataque = item["ataque"]
	defensa = item["defensa"]
	agilidad = item["agilidad"]
	magia = item["magia"]
	fuego = item["fuego"]
	agua = item["agua"]
	roca = item["roca"]
	viento = item["viento"]
	durabilidad = durabilidadR
	rareza = item["rareza"]
	colorRareza()
	dibujarElementos()

func dibujarElementos() -> void:
	fondo.visible = true
	if imagen != null:
		imagenO.texture = imagen
	else:
		imagenO.texture = load("res://assets/textures/interrogacion1.png")
	cantidad_l.text = str(cantidad)

func infoEntrante(info) -> void:
	get_node(info.self.get_path()).infoSalida(id,cantidad,durabilidad,numeroSlot)
	if info.id == id and info.self != self:
		cantidadesEntrada(true,info.cantidad)
		PROP_JUGADOR.itemInventario[numeroSlot].id = id
		PROP_JUGADOR.itemInventario[numeroSlot].cantidad = cantidad
		PROP_JUGADOR.itemInventario[numeroSlot].durabilidad = durabilidad
	else:
		cantidadesEntrada(false,info.cantidad)
		var nuevo_valor = {
			"id": info.id,
			"cantidad": info.cantidad,
			"durabilidad": info.durabilidad,
		}
		PROP_JUGADOR.itemInventario[numeroSlot] = nuevo_valor
	get_parent().get_parent().get_parent().dibujarSlots()

func cantidadesEntrada(iguales,infoCantidad) -> void:
	if iguales:
		var resultadoCantidad = cantidad + infoCantidad
		if resultadoCantidad <= cantidadMaxima:
			cantidad = resultadoCantidad
		else:
			cantidad = cantidadMaxima
	else:
		cantidad = infoCantidad

func infoSalida(ido,cantidado,durabilidado,sloto) -> void:
	if ido == id:
		cantidadesSalida(true,cantidado)
	elif ido == 0:
		borrarCasilla()
		var nuevo_valor = {
			"id": ido,
			"cantidad": cantidado,
			"durabilidad": durabilidado,
		}
		PROP_JUGADOR.itemInventario[sloto] = nuevo_valor
	else:
		#var temporalDic = PROP_JUGADOR.itemInventario[numeroSlot]
		PROP_JUGADOR.itemInventario[numeroSlot] = PROP_JUGADOR.itemInventario[sloto]
		PROP_JUGADOR.itemInventario[sloto] = {
			"id": id,
			"cantidad": cantidad,
			"durabilidad": durabilidad,
		}
	#get_parent().get_parent().get_parent().dibujarSlots()

func cantidadesSalida(iguales,infoCantidad) -> void:
	if iguales:
		var resultadoCantidad = cantidad + infoCantidad
		if resultadoCantidad <= cantidadMaxima:
			borrarCasilla()
		else:
			cantidad = resultadoCantidad-cantidadMaxima
			PROP_JUGADOR.itemInventario[numeroSlot].id = id
			PROP_JUGADOR.itemInventario[numeroSlot].cantidad = cantidad
			PROP_JUGADOR.itemInventario[numeroSlot].durabilidad = durabilidad
	else:
		cantidad = infoCantidad

func borrarCasilla() -> void:
	PROP_JUGADOR.itemInventario.erase(numeroSlot)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if id != 0:
				PROP_JUGADOR.inventarioSlotSeñalado = str(self)
				PROP_JUGADOR.emit_signal("s_inventarioSlotSeñalado")
			else:
				PROP_JUGADOR.inventarioSlotSeñalado = ""

func colorRareza() -> String:
	if id != 0:
		if rareza == 0:
			# Muy común
			color = "#a0a0a0"
			fondo.modulate = color
			letraColor = "#000000"
		elif rareza == 1:
			# Común
			color = "#ffff"
			fondo.modulate = color
			letraColor = "#000000"
		elif rareza == 2:
			# Poco Común
			color = "#42d676"
			fondo.modulate = color
			letraColor = "#000000"
		elif rareza == 3:
			# Épico
			color = "#423a7c"
			fondo.modulate = color
			letraColor = "#ffffff"
		elif rareza == 4:
			# Mítico
			color = "#d6d442"
			fondo.modulate = color
			letraColor = "#ffffff"
		elif rareza == 5:
			# Legendario
			color = "#ff6215"
			fondo.modulate = color
			letraColor = "#ffffff"
	return color

func consultarItem():
	var infoPopup = {
		"nombre" = nombre,
		"descripcion" = descripcion,
		"rutaImagen" = rutaImagen,
		"cantidad" = cantidad,
		"cantidadMaxima" = cantidadMaxima,
		"equipable" = equipable,
		"consumible" = consumible,
		"cura" = cura,
		"daño" = daño,
		"regenera" = regenera,
		"segundos" = segundos,
		"precioCompra" = precioCompra,
		"precioVenta" = precioVenta,
		"peso" = peso,
		"levelMinimo" = levelMinimo,
		"ataque" = ataque,
		"defensa" = defensa,
		"agilidad" = agilidad,
		"magia" = magia,
		"fuego" = fuego,
		"agua" = agua,
		"roca" = roca,
		"viento" = viento,
		"durabilidad" = durabilidad,
		"rareza" = rareza,
		"color" = color,
		"letraColor" = letraColor,
	}
	return infoPopup

func slotActivo()->void:
	var infoPopup = consultarItem()
	var inventarioPadre = get_parent().get_parent().get_parent()
	var señalado = PROP_JUGADOR.inventarioSlotSeñalado
	if señalado == str(self):
		inventarioPadre._poppup(infoPopup)
		marcoShow(true)
	else:
		marcoShow(false)

func marcoShow(condicion)->void:
	if condicion:
		marco_seleccionado.visible = true
	else:
		marco_seleccionado.visible = false
