extends Node2D
@onready var barra_salud: TextureProgressBar = $CanvasLayer/barraSalud
@onready var barra_hambre: TextureProgressBar = $CanvasLayer/barraHambre
@onready var barra_sed: TextureProgressBar = $CanvasLayer/barraSed
@onready var barra_energia: TextureProgressBar = $CanvasLayer/barraEnergia

func _on_opciones_b_pressed() -> void:
	get_node("CanvasLayer/opciones").mostrar(true)

func _on_inventario_b_pressed() -> void:
	get_node("CanvasLayer/Inventario").mostrar()

func _on_guardar_b_pressed() -> void:
	get_node("CanvasLayer/guardados").mostrar()
