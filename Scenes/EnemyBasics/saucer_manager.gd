extends Node2D

@onready var timer : Timer = $Timer
@onready var paths = $Paths.get_children()
@onready var saucer : PackedScene = preload("res://Scenes/EnemyBasics/saucer.tscn")

const WAIT_TIMER : float = 15.0
const TIME_VARIATION : float = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpawnSaucer()

func SpawnSaucer() -> void:
	
	var newSauce = saucer.instantiate()
	var newPath = paths.pick_random()
	
	newPath.add_child(newSauce)
	Utils.SetAndStartTimer(timer, WAIT_TIMER, TIME_VARIATION)

func _on_timer_timeout() -> void:
	SpawnSaucer()
