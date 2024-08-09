extends Area2D

@onready var p_sprite: Sprite2D = $pSprite
@onready var sound: AudioStreamPlayer2D = $Sound

var powerUpSpeed : float = 110
var powerUpType : GameData.POWERUP_TYPE = GameData.POWERUP_TYPE.HEALTH

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetPowerUpType(powerUpType)
	p_sprite.texture = GameData.POWER_UPS[powerUpType]
	SoundManager.play_powerup_deploy_sound(sound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += delta * powerUpSpeed


func SetPowerUpType(pu_type : GameData.POWERUP_TYPE) -> void:
	powerUpType = pu_type

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	SignalManager.on_powerUp_hit.emit(powerUpType)
	queue_free()
