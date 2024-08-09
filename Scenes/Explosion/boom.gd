extends AnimatedSprite2D

@onready var sound: AudioStreamPlayer2D = $Sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_explosion_random(sound)
	

func _on_animation_finished() -> void:
	queue_free()
