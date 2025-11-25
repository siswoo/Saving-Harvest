extends MacroInteractivo
@onready var collision: CollisionShape2D = $collision
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	z_index = 2
	area_2d.connect("body_entered",jugadorVisible)
	area_2d.connect("body_exited",jugadorSalio)

func jugadorVisible(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		z_index = 1

func jugadorSalio(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		z_index = 2
