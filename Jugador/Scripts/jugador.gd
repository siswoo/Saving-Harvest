extends CharacterBody2D
@onready var camara1: Camera2D = $Camera1
@onready var animaciones: AnimationPlayer = $AnimationPlayer
@export var velocidad = 150
var movimientoH
var movimientoV
var viendo: String = "abajo"
var estado: String = "Idle"

func _ready() -> void:
	cargarDatos()

func cargarDatos() -> void:
	global_position = Vector2(PROP_JUGADOR.global_position.x,PROP_JUGADOR.global_position.y)

func _process(_delta: float) -> void:
	update_camera_pos()
	PROP_JUGADOR.global_position = Vector2(global_position.x,global_position.y)
	get_node("HUD/CanvasLayer/barraSalud").value = float(PROP_JUGADOR.salud) / float(PROP_JUGADOR.saludMaxima)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("izquierda"):
		viendo = "izquierda"
		velocity.x = -(velocidad)
	elif Input.is_action_pressed("derecha"):
		viendo = "derecha"
		velocity.x = velocidad
	elif Input.is_action_pressed("arriba"):
		viendo = "arriba"
		velocity.y = -(velocidad)
	elif Input.is_action_pressed("abajo"):
		viendo = "abajo"
		velocity.y = velocidad
	
	if velocity.x == 0 and velocity.y == 0:
		estado = "Idle"
	else:
		estado = "Walk"
	
	ejecutarAnimaciones()
	
	move_and_slide()
	velocity = Vector2(0,0)

func update_camera_pos() -> void:
	camara1.global_position.x = global_position.x

func ejecutarAnimaciones() -> void:
	if estado == "Idle":
		if viendo == "izquierda":
			animaciones.play("Idle_L")
		if viendo == "derecha":
			animaciones.play("Idle_R")
		if viendo == "arriba":
			animaciones.play("Idle_B")
		if viendo == "abajo":
			animaciones.play("Idle_F")
	elif estado == "Walk":
		if viendo == "izquierda":
			animaciones.play("Walking_L")
		if viendo == "derecha":
			animaciones.play("Walking_R")
		if viendo == "arriba":
			animaciones.play("Walking_B")
		if viendo == "abajo":
			animaciones.play("Walking_F")

func _input(_event)->void:
	if Input.is_action_just_pressed("escape"):
		get_node("HUD/CanvasLayer/opciones").mostrar()
