extends Node
@onready var pista1: AudioStreamPlayer2D = $Pista1
@onready var pista2: AudioStreamPlayer2D = $Pista2
@onready var pista3: AudioStreamPlayer2D = $Pista3
@onready var pista4: AudioStreamPlayer2D = $Pista4
@onready var pistaPresentacion1: AudioStreamPlayer2D = $Pista5
var musicRandom

func _ready() -> void:
	musicRandom = randi_range(1,4)
	if musicRandom == 1:
		pista1.play()
	elif musicRandom == 2:
		pista2.play()
	elif musicRandom == 3:
		pista3.play()
	elif musicRandom == 4:
		pista4.play()

func cambiarMusica(pista: int):
	pista1.stop()
	pista2.stop()
	pista3.stop()
	pista4.stop()
	pistaPresentacion1.stop()
	if pista == 1:
		pista1.play()
	if pista == 2:
		pista2.play()
	if pista == 3:
		pista3.play()
	if pista == 4:
		pista4.play()
	if pista == 5:
		pistaPresentacion1.play()
