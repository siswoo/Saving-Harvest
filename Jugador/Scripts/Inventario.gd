extends CanvasLayer
@onready var fondo: TextureRect = $Fondo
@onready var panel: TextureRect = $Panel
@onready var macro_1: GridContainer = $Panel/Macro1
@onready var slots_escena = load("res://Jugador/slotInventario.tscn")
@onready var popup: Panel = $Panel/Popup
#var condicionMuestra: bool = false
var cantidadSlots: int = 0
var itemsDB = {}
var slot_anidado

func _ready() -> void:
	fondo.visible = false
	panel.visible = false
	importarDatos()
	dibujarSlots()
	PROP_JUGADOR.connect("s_inventarioSwitch",_poppupShow.bind(false))

func mostrar() -> void:
	GENERALES.pausarJuego()
	PROP_JUGADOR.emit_signal("s_inventarioSwitch")
	var condicionMuestra = PROP_JUGADOR.inventarioAbierto
	if condicionMuestra:
		fondo.visible = true
		panel.visible = true
	else:
		fondo.visible = false
		panel.visible = false

func importarDatos() -> void:
	var path = "res://TraduccionesPerso/items.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if data == null:
			print("toca borrar el archivo de items")
			return
		itemsDB = data

func dibujarSlots() -> void:
	for hijos in macro_1.get_children():
		hijos.queue_free()
	cantidadSlots = PROP_JUGADOR.slotInventario
	for i in cantidadSlots:
		slot_anidado = slots_escena.instantiate()
		macro_1.add_child(slot_anidado)
		slot_anidado.name = "slot"+str(i+1)
		slot_anidado.numeroSlot = i
		dibujarItems(i,slot_anidado.name)

func dibujarItems(lugarSlot,nombreSlot) -> void:
	if PROP_JUGADOR.itemInventario.has(lugarSlot) == true:
		var itemActual = PROP_JUGADOR.itemInventario[lugarSlot]
		var itemID = itemActual["id"]
		var itemInfo = itemsDB[str(itemID)]
		var cantidad = itemActual["cantidad"]
		var durabilidad = itemActual["durabilidad"]
		get_node("Panel/Macro1/"+nombreSlot).setearInfo(itemInfo,cantidad,durabilidad,itemID)

func _on_button_cerrar_button_up() -> void:
	mostrar()

func _poppupShow(condicion)->void:
	if condicion:
		popup.visible = true
	else:
		popup.visible = false

func _poppup(item) -> void:
	#print(item.letraColor)
	popup.visible = true
	$Panel/Popup/nombre_fondo.modulate = item.color
	$Panel/Popup/nombre_texto.text = item.nombre
	$Panel/Popup/nombre_texto.modulate = item.letraColor
	$Panel/Popup/descripcion_texto.text = item.descripcion
	$Panel/Popup/oro_texto.text = str(item.precioVenta)
	var textoDescripcion2 = ""
	if item.consumible:
		textoDescripcion2 = "[b]Consumible[/b]\nCura = "+str(item.cura)
		textoDescripcion2 += " | Daño = "+str(item.daño)
		textoDescripcion2 += " | Reg x Seg = "+str(item.regenera)+"/"+str(item.segundos)
	if item.equipable:
		pass
	$Panel/Popup/estatus_texto.text = textoDescripcion2
	if item:
		pass

#############################################
############### TEST ##################
#############################################

func _on_uno_mas_pressed() -> void:
	if cantidadSlots+1 <= PROP_JUGADOR.maxSlotInventario:
		PROP_JUGADOR.slotInventario += 1
		dibujarSlots()

func _on_uno_menos_pressed() -> void:
	if cantidadSlots-1 >= PROP_JUGADOR.minSlotInventario:
		PROP_JUGADOR.slotInventario -= 1
		dibujarSlots()
