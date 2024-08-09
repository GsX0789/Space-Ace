extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var shield_duration: Timer = $ShieldDuration
@onready var shield_anim: AnimationPlayer = $ShieldAnim

var shield_health : int = 5
var current_health : int

func _ready() -> void:
	DisableShield()

func DisableShield() -> void:
	shield_duration.stop()
	hide()
	collision_shape_2d.set_deferred("disabled", true)

func EnableShield() -> void:
	current_health = shield_health
	shield_duration.start()
	show()
	collision_shape_2d.set_deferred("disabled", false)
	SoundManager.play_power_up_sound(GameData.POWERUP_TYPE.SHIELD, sound)

func Hit() -> void:
	shield_anim.play("hit")
	current_health -= 1
	if current_health <= 0:
		DisableShield()

func _on_shield_duration_timeout() -> void:
	DisableShield()

func _on_area_entered(area: Area2D) -> void:
	Hit()
