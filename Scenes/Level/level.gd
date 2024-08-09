extends Node2D

@onready var sound: AudioStreamPlayer2D = $Sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreManager.ResetScore()
	SignalManager.on_player_death.connect(OnPlayerDied)
		
		
func OnPlayerDied() -> void:
	sound.stop()
	#Get every node that is Node2D in the tree and delete it
	#The canvas and BG will stay
	for node in get_children():
		if(is_instance_valid(node) and node.is_class("Node2D")):
			ObjectMaker.create_explosion(node.global_position,self)
			node.queue_free()
